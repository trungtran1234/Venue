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
  List<Map<String, String>> _searchResults = [];
  List<Map<String, String>> _friendsList = [];
  Set<String> _pendingRequests = Set<String>();
  String? _currentUserUsername;

  @override
  void initState() {
    super.initState();
    popupManager = PopupManager();
    connectivityChecker =
        ConnectivityChecker(onStatusChanged: onConnectivityChanged);
    fetchCurrentUser();
    fetchFriends();
  }

  void fetchCurrentUser() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            _currentUserUsername =
                (documentSnapshot.data() as Map<String, dynamic>)['username'];
          });
        }
      });
    }
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
          fetchFriendDetails(friendUIDs);
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
        backgroundColor: Colors.black,
        title: const Text('Friends',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
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
          hintText: 'Find Friends',
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              _searchController.clear();
              _performSearch("");
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
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: '$query\uf8ff')
        .get()
        .then((querySnapshot) {
      var allResults = querySnapshot.docs
          .map((doc) =>
              {'username': doc.data()['username'] as String, 'uid': doc.id})
          .toList();
      setState(() {
        _searchResults = allResults;
      });
    });
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        final username = result['username'];
        final uid = result['uid'];
        bool isFriend = _friendsList.any((friend) => friend['uid'] == uid);
        bool isCurrentUser = username == _currentUserUsername;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(username ?? 'Unknown',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: isCurrentUser
                ? Text('This is you', style: TextStyle(color: Colors.grey[600]))
                : null,
            trailing: isCurrentUser
                ? null
                : (isFriend
                    ? _buildFriendOptions(username!)
                    : _buildAddFriendButton(username!, uid!)),
          ),
        );
      },
    );
  }

  IconButton _buildAddFriendButton(String username, String uid) {
    bool isPending = _pendingRequests.contains(uid);
    return IconButton(
      icon: Icon(isPending ? Icons.hourglass_top : Icons.person_add),
      color: isPending ? Colors.amber : Colors.green,
      onPressed: () {
        if (!isPending) {
          sendFriendRequest(username, uid);
        }
      },
    );
  }

  PopupMenuButton<String> _buildFriendOptions(String username) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'invite',
          child: ListTile(
            leading: const Icon(Icons.mail_outline, color: Colors.blue),
            title: const Text('Invite'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem<String>(
          value: 'unfriend',
          child: ListTile(
            leading: const Icon(Icons.remove_circle_outline, color: Colors.red),
            title: const Text('Unfriend'),
            onTap: () {
              String? friendUID = _friendsList.firstWhere(
                  (friend) => friend['username'] == username)['uid'];
              _unfriend(friendUID);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFriendsList() {
    return ListView.builder(
      itemCount: _friendsList.length,
      itemBuilder: (context, index) {
        var friend = _friendsList[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              friend['username'] ?? 'Unknown',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.deepPurple),
              onSelected: (value) {
                switch (value) {
                  case 'invite':
                    // Add invite functionality
                    break;
                  case 'unfriend':
                    _unfriend(friend['uid']);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'invite',
                  child: Row(
                    children: [
                      Icon(Icons.mail_outline, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Invite'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'unfriend',
                  child: Row(
                    children: [
                      Icon(Icons.remove_circle_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Unfriend'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void sendFriendRequest(String username, String uid) {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      showTopSnackBar(context, "You must be logged in to send friend requests.",
          backgroundColor: Colors.red);
      return;
    }

    // Optimistically update the UI
    setState(() {
      _pendingRequests.add(uid);
    });

    FirebaseFirestore.instance.collection('notifications').add({
      'senderUID': currentUser.uid,
      'senderUsername': currentUser.email ?? 'Unknown User',
      'receiverUID': uid,
      'title': 'Friend Request',
      'message':
          '${currentUser.email ?? 'A user'} wants to add you as a friend',
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    }).then((_) {
      showTopSnackBar(context, "Friend request sent successfully to $username",
          backgroundColor: Colors.green);
    }).catchError((error) {
      showTopSnackBar(context, "Failed to send friend request",
          backgroundColor: Colors.red);
      // Roll back on error
      setState(() {
        _pendingRequests.remove(uid);
      });
    });
  }

  void _unfriend(String? uid) {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && uid != null) {
      String currentUserUID = currentUser.uid;

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference currentUserRef =
            FirebaseFirestore.instance.collection('users').doc(currentUserUID);
        DocumentReference friendUserRef =
            FirebaseFirestore.instance.collection('users').doc(uid);

        DocumentSnapshot currentUserDoc = await transaction.get(currentUserRef);
        DocumentSnapshot friendUserDoc = await transaction.get(friendUserRef);

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
          _friendsList.removeWhere((friend) => friend['uid'] == uid);
          showTopSnackBar(context, "Unfriended successfully",
              backgroundColor: Colors.orange);
        });
      }).catchError((error) {
        showTopSnackBar(context, "Error unfriending: $error",
            backgroundColor: Colors.red);
      });
    }
  }
}
