import 'package:app/global.dart';
import 'package:app/pages/friends.dart';
import 'package:flutter/material.dart';
import 'package:app/settings/settings.dart';
import '../services/connectivity_checker.dart';
import '../services/reconnection_popup.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late PopupManager popupManager;
  late ConnectivityChecker connectivityChecker;
  final int _selectedIndex = 3;
  firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
  Map<String, dynamic> userData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    popupManager = PopupManager();
    connectivityChecker = ConnectivityChecker(
      onStatusChanged: onConnectivityChanged,
    );
    fetchUserData();
  }

  void fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>;
            _isLoading =
                false; // Set isLoading to false when data is successfully fetched
          });
        }
      } catch (e) {
        // Handle exceptions by setting isLoading to false and logging error or showing a message
        setState(() {
          _isLoading = false;
        });
        print('Error fetching user data: $e');
      }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              newRoute(context, SettingsPage());
            },
            icon: const Icon(Icons.settings),
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: _isLoading
              ? CircularProgressIndicator() // Display spinner when isLoading is true
              : Column(
                  // Display user data when isLoading is false
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          AssetImage('lib/assets/Default_pfp.svg.png'),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${userData['firstName']} ${userData['lastName']}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${userData['username']}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${userData['bio']}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Friends: ${userData['friends'] ?? 0}'),
                        const Text(' | '),
                        Text('Posts: ${userData['posts'] ?? 0}'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        newRoute(context, const EditProfilePage());
                      },
                      child: const Text('Edit Profile'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FriendsPage(),
                          ),
                        );
                      },
                      child: const Text('Friends'),
                    ),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, _selectedIndex),
    );
  }

  @override
  void dispose() {
    connectivityChecker.dispose();
    super.dispose();
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final firebase_auth.User? user =
      firebase_auth.FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      _firstNameController.text = userData['firstName'] ?? '';
      _lastNameController.text = userData['lastName'] ?? '';
      _usernameController.text = userData['username'] ?? '';
      _bioController.text = userData['bio'] ?? '';
    }
  }

  Future<void> updateProfileData() async {
    Map<String, dynamic> updatedData = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'username': _usernameController.text,
      'bio': _bioController.text,
    };

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update(updatedData);
      newRoute(context,
          const ProfilePage()); // Optionally pop back to profile page after update
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded),
            onPressed: updateProfileData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(labelText: 'Biography'),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
