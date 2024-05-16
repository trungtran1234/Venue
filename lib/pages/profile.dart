import 'dart:io';
import 'dart:typed_data';
import 'package:app/database/storage_methods.dart';
import 'package:app/global.dart';
import 'package:app/pages/friends.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:app/settings/settings.dart';
import '../services/connectivity_checker.dart';
import '../services/reconnection_popup.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

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
  String? _image;

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

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    String pfpUrl =
        await StorageMethods().uploadImageToStorage('pfps', image, true);

    Map<String, dynamic> updatedData = {
      'profilePicturePath': pfpUrl,
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update(updatedData);

    setState(
      () {
        _image = pfpUrl;
      },
    );
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
        title: const Text('Profile',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              newRoute(context, const SettingsPage());
            },
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Center(
          child: _isLoading
              ? CircularProgressIndicator(color: Theme.of(context).primaryColor)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            _image ?? userData['profilePicturePath']),
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.camera_alt, size: 28),
                        color: Colors.white,
                        tooltip: 'Change Profile Picture',
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '${userData['firstName']} ${userData['lastName']}',
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '@${userData['username']}',
                      style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${userData['bio']}',
                      style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.group, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        Text('Friends: ${userData['friends']?.length ?? 0}',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        newRoute(context, const EditProfilePage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text('Edit Profile'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FriendsPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
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
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  final firebase_auth.User? user =
      firebase_auth.FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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

  Future<void> uploadImageAndUpdateProfile() async {
    if (user != null) {
      String imageUrl = '';
      if (_image != null) {
        String fileName = 'profile_${user!.uid}.jpg';
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(fileName);
        await storageRef.putFile(_image!);
        imageUrl = await storageRef.getDownloadURL();
      }

      Map<String, dynamic> updatedData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'username': _usernameController.text,
        'bio': _bioController.text,
      };

      if (imageUrl.isNotEmpty) {
        updatedData['profilePictureUrl'] = imageUrl;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update(updatedData);
      newRoute(context, const ProfilePage());
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
            onPressed: uploadImageAndUpdateProfile,
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
