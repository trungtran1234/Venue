import 'package:app/global.dart';
import 'package:flutter/material.dart';
import 'package:app/settings/settings.dart';
import '../objects/userprofile.dart';
import '../services/connectivity_checker.dart';
import '../services/reconnection_popup.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late PopupManager popupManager;
  late ConnectivityChecker connectivityChecker;
  final int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    popupManager = PopupManager();
    connectivityChecker = ConnectivityChecker(
      onStatusChanged: onConnectivityChanged,
    );
    // If needed, start listening for connectivity changes here
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
    UserProfile user = UserProfile(
        username: "username",
        firstName: "firstname",
        lastName: "lastName",
        location: "location");

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
              color: Colors.white),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0), // Add space at the top
            const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('lib/assets/Default_pfp.svg.png'),
            ),
            const SizedBox(height: 20.0),
            Text(
              user.username,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(userProfile: user),
                  ),
                );
              },
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 10.0),
            Text(user.location,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                )),
            const SizedBox(height: 10.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                user.bio,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Adjust alignment
              children: [
                _buildStatisticColumn(user.friends, 'Friends'),
                _buildStatisticColumn(user.eventsAttended, 'Events Attended'),
                _buildStatisticColumn(user.eventsHosted, 'Events Hosted'),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
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

  Widget _buildStatisticColumn(int value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final UserProfile userProfile;

  const EditProfilePage({super.key, required this.userProfile});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    // Assume you might initialize _image here if userProfile has an image
    // _image = widget.userProfile.profilePicture; // Uncomment if userProfile has a profilePicture
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        // Optionally update the userProfile with the new image
        // widget.userProfile.uploadProfilePicture(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Implement the logic to save the updated profile details
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap:
                      _pickImage, // Correctly reference the _pickImage method
                  child: CircleAvatar(
                    radius: 60, // Increased size for better visibility
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : const AssetImage(
                                UserProfile.defaultProfilePicturePath)
                            as ImageProvider,
                    backgroundColor:
                        Colors.grey[200], // Provides a fallback color
                  ),
                ),
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    color: Colors.blue, // Camera icon background color
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(_usernameController, 'Username'),
            const SizedBox(height: 10),
            _buildTextField(_firstNameController, 'First Name'),
            const SizedBox(height: 10),
            _buildTextField(_lastNameController, 'Last Name'),
            const SizedBox(height: 10),
            _buildTextArea(_bioController, 'Bio'),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildTextArea(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: controller,
        maxLines: 5,
        decoration: InputDecoration(
          labelText: labelText,
          alignLabelWithHint: true,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
