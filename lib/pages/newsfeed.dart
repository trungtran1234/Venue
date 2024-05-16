import 'package:app/database/firestore_methods.dart';
import 'package:app/global.dart';
import 'package:app/pages/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import '../services/connectivity_checker.dart';
import '../services/reconnection_popup.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  State<NewsFeedPage> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeedPage> {
  final int _selectedIndex = 0;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
  Map<String, dynamic> userData = {};
  List<String> userFriends = [];
  Map<String, Map<String, dynamic>> eventDetailsCache = {};

  final ConnectivityChecker _connectivityChecker = ConnectivityChecker();
  final PopupManager _popupManager = PopupManager();

  @override
void initState() {
  super.initState();
  _connectivityChecker.onStatusChanged = _handleConnectivityChange;
  fetchUserData().then((_) {
    fetchUserFriends().then((_) {
      preloadEventDetails(); // Ensure this is called after user data and friends are loaded
    });
  });
  initFetch();
}

Future<void> initFetch() async {
  if (user != null) {
    await fetchUserData();
    await fetchUserFriends();
    await preloadEventDetails();
    setState(() {
      _isLoading = false;  // Set this false only after all data is fetched
    });
  }
}

  Future<void> preloadEventDetails() async {
  var eventCollection = FirebaseFirestore.instance.collection('events');
  var snapshot = await eventCollection.get();
  for (var doc in snapshot.docs) {
    eventDetailsCache[doc.id] = doc.data();
  }
}


  Future<void> fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>;
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> fetchUserFriends() async {
  if (user != null) {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    if (userDoc.exists) {
      var data = userDoc.data() as Map<String, dynamic>?; 
      if (data != null && data.containsKey('friends')) {
        setState(() {
          userFriends = List<String>.from(data['friends']);
        });
      }
    }
  }
}


  void _handleConnectivityChange(bool isConnected) {
    if (!isConnected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _popupManager.showConnectivityPopup(context);
      });
    } else {
      _popupManager.dismissConnectivityPopup();
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _connectivityChecker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Venue'),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : _buildPostList(),
      bottomNavigationBar: buildBottomNavigationBar(context, _selectedIndex),
    );
  }

  Widget _buildPostList() {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datePublished', descending: true)
        .snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData) {
        return const Text("No data available");
      }

      var filteredDocs = snapshot.data!.docs.where((doc) {
        var postData = doc.data();
        var eventId = postData['eventId'];
        var event = eventDetailsCache[eventId];
        if (event == null) {
          return false;
        }

        var visibility = event['visibility'] ?? 'public';
        var creatorId = postData['uid'];

        bool filterCondition = visibility == 'public' || (visibility == 'friendsOnly' && userFriends.contains(creatorId));

        return filterCondition;
      }).toList();

      return ListView.builder(
        itemCount: filteredDocs.length,
        itemBuilder: (context, index) {
          return PostCard(snap: filteredDocs[index].data());
        },
      );
    },
  );
}
}
