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
        backgroundColor: Colors.transparent,
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
          .where('username', isLessThanOrEqualTo: '$query\uf8ff')
          .get()
          .then((querySnapshot) {
        var allResults = querySnapshot.docs
            .map((doc) =>
                {'username': doc.data()['username'] as String, 'uid': doc.id})
            .toList();
        _sortSearchResults(allResults);
      });
    } else {
      setState(() {
        _searchResults.clear();
      });
    }
  }

  void _sortSearchResults(List<Map<String, String>> results) {
    var friendsResults = [];
    var nonFriendsResults = [];

    for (var result in results) {
      var isFriend =
          _friendsList.any((friend) => friend['uid'] == result['uid']);
      if (isFriend) {
        friendsResults.add(result);
      } else {
        nonFriendsResults.add(result);
      }
    }

    setState(() {
      _searchResults = [...friendsResults, ...nonFriendsResults];
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

        return ListTile(
          title: Text(username ?? 'Unknown'),
          trailing: isCurrentUser
              ? null
              : (isFriend
                  ? _buildFriendOptions(username!)
                  : _buildAddFriendButton(username!)),
        );
      },
    );
  }

  IconButton _buildAddFriendButton(String username) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        sendFriendRequest(username);
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
                    _unfriend(friend['uid']);
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
      showTopSnackBar(context, "You must be logged in to send friend requests.",
          backgroundColor: Colors.red);
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get()
        .then((userDoc) {
      String senderUsername =
          userDoc.data()?['username'] ?? currentUser.email ?? 'Unknown User';

      FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: receiverUsername)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          var receiverData = querySnapshot.docs.first;
          FirebaseFirestore.instance.collection('notifications').add({
            'senderUID': currentUser.uid,
            'senderUsername': senderUsername,
            'receiverUID': receiverData.id,
            'title': 'Friend Request',
            'message': '$senderUsername wants to add you as a friend',
            'status': 'pending',
            'timestamp': FieldValue.serverTimestamp(),
          }).then((_) {
            showTopSnackBar(context,
                "Friend request sent successfully to $receiverUsername",
                backgroundColor: Colors.green);
          }).catchError((error) {
            showTopSnackBar(context, "Failed to send friend request",
                backgroundColor: Colors.red);
          });
        } else {
          showTopSnackBar(
              context, "No user found with the username $receiverUsername",
              backgroundColor: Colors.red);
        }
      });
    }).catchError((error) {
      showTopSnackBar(context, "Failed to retrieve user information",
          backgroundColor: Colors.red);
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
