import 'package:app/global.dart';
import 'package:app/pages/friends.dart';
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
  final UserProfile user = UserProfile(
    username: "username",
    firstName: "firstname",
    lastName: "lastName",
    location: "location",
  );

  @override
  void initState() {
    super.initState();
    popupManager = PopupManager();
    connectivityChecker = ConnectivityChecker(
      onStatusChanged: onConnectivityChanged,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('lib/assets/Default_pfp.svg.png'),
            ),
            const SizedBox(height: 20.0),
            Text(
              '${user.firstName} ${user.lastName}',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              user.username,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Align buttons in the center of the Row
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Navigate to EditProfilePage and await result
                    final UserProfile? updatedProfile = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProfilePage(userProfile: user),
                      ),
                    );

                    // Update user profile if there's an updated profile
                    if (updatedProfile != null) {
                      setState(() {
                        user.username = updatedProfile.username;
                        user.firstName = updatedProfile.firstName;
                        user.lastName = updatedProfile.lastName;
                        user.bio = updatedProfile.bio;
                      });
                    }
                  },
                  child: const Text('Edit Profile'),
                ),
                const SizedBox(width: 10), // Space between the buttons
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
            const SizedBox(height: 10.0),
            Text(
              user.location,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              widget.userProfile.username = _usernameController.text;
              widget.userProfile.firstName = _firstNameController.text;
              widget.userProfile.lastName = _lastNameController.text;
              widget.userProfile.bio = _bioController.text;

              // Navigate back to ProfilePage with updated userProfile
              Navigator.pop(context, widget.userProfile);
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
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : const AssetImage(
                                UserProfile.defaultProfilePicturePath)
                            as ImageProvider,
                    backgroundColor: Colors.grey[200],
                  ),
                ),
                Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
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
            _buildTextField(_bioController, 'Bio'),
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
}
