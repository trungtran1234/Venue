import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/connectivity_checker.dart';
import '../services/reconnection_popup.dart';
import 'package:app/global.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  FriendsPageState createState() => FriendsPageState();
}

class FriendsPageState extends State<FriendsPage> {
  late ConnectivityChecker connectivityChecker;
  late PopupManager popupManager;
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  List<Map<String, String>> _friendsList = [];

  @override
  void initState() {
    super.initState();
    popupManager = PopupManager();
    connectivityChecker = ConnectivityChecker(
      onStatusChanged: onConnectivityChanged,
    );
    fetchFriends();
  }

  void fetchFriends() {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var userData = documentSnapshot.data() as Map<String, dynamic>;
          List<String> friendUIDs = List.from(userData['friends'] ?? []);
          fetchFriendDetails(
              friendUIDs); // Fetch details like usernames for each friend UID
        }
      });
    }
  }

  void fetchFriendDetails(List<String> friendUIDs) {
    for (String uid in friendUIDs) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var friendData = documentSnapshot.data() as Map<String, dynamic>;
          setState(() {
            _friendsList.add({'username': friendData['username'], 'uid': uid});
          });
        }
      });
    }
  }

  void onConnectivityChanged(bool isConnected) {
    if (isConnected) {
      popupManager.dismissConnectivityPopup();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        popupManager.showConnectivityPopup(context);
      });
    }
  }

  @override
  void dispose() {
    connectivityChecker.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              _performSearch(_searchController.text);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _searchResults.isNotEmpty
                ? _buildSearchResults()
                : _buildFriendsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by username',
          suffixIcon: IconButton(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchResults.clear();
              });
            },
            icon: const Icon(Icons.clear),
          ),
        ),
        onChanged: (query) {
          _performSearch(query);
        },
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: query + '\uf8ff')
          .get()
          .then((querySnapshot) {
        setState(() {
          _searchResults = querySnapshot.docs
              .map((doc) => doc.data()['username'] as String)
              .toList();
        });
      });
    } else {
      setState(() {
        _searchResults.clear();
      });
    }
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final username = _searchResults[index];
        return ListTile(
          title: Text(username),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              sendFriendRequest(username);
            },
          ),
        );
      },
    );
  }

  Widget _buildFriendsList() {
    return ListView.builder(
      itemCount: _friendsList.length,
      itemBuilder: (context, index) {
        var friend = _friendsList[index];
        return ListTile(
          title: Text(friend['username'] ?? 'Unknown'),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'invite',
                child: ListTile(
                  title: const Text('Invite'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuItem<String>(
                value: 'unfriend',
                child: ListTile(
                  title: const Text('Unfriend'),
                  onTap: () {
                    _unfriend(friend['uid']); // Use UID for unfriending
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void sendFriendRequest(String receiverUsername) {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You must be logged in to send friend requests."),
        backgroundColor: Colors.red,
      ));
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: receiverUsername)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var receiverData = querySnapshot.docs.first;
        FirebaseFirestore.instance.collection('notifications').add({
          'senderUID': currentUser.uid,
          'senderUsername': currentUser.displayName ?? currentUser.email,
          'receiverUID':
              receiverData.id, // Receiver's UID for receiverUID field
          'title': 'Friend Request',
          'message':
              '${currentUser.displayName ?? currentUser.email} wants to add you as a friend',
          'status': 'pending',
          'timestamp': FieldValue.serverTimestamp(),
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Friend request sent successfully to $receiverUsername"),
            backgroundColor: Colors.green,
          ));
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to send friend request"),
            backgroundColor: Colors.red,
          ));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("No user found with the username $receiverUsername"),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  void _unfriend(String? uid) {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && uid != null) {
      // Get the UID of the current user
      String currentUserUID = currentUser.uid;

      // Transaction to ensure both updates are processed
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference currentUserRef =
            FirebaseFirestore.instance.collection('users').doc(currentUserUID);
        DocumentReference friendUserRef =
            FirebaseFirestore.instance.collection('users').doc(uid);

        // Get snapshots without waiting for network with transaction.get
        DocumentSnapshot currentUserDoc = await transaction.get(currentUserRef);
        DocumentSnapshot friendUserDoc = await transaction.get(friendUserRef);

        // Remove each other from friends lists if both documents exist
        if (currentUserDoc.exists && friendUserDoc.exists) {
          transaction.update(currentUserRef, {
            'friends': FieldValue.arrayRemove([uid])
          });
          transaction.update(friendUserRef, {
            'friends': FieldValue.arrayRemove([currentUserUID])
          });
        }
      }).then((_) {
        setState(() {
          // Update the UI to reflect the friend removal
          _friendsList.removeWhere((friend) => friend['uid'] == uid);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Unfriended successfully"),
            backgroundColor: Colors.orange,
          ));
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error unfriending: $error"),
          backgroundColor: Colors.red,
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("You must be logged in and select a valid user to unfriend"),
        backgroundColor: Colors.red,
      ));
    }
  }
}
