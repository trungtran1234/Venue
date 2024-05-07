import 'package:app/pages/map.dart';
import 'package:app/pages/newsfeed.dart';
import 'package:app/pages/notifications.dart';
import 'package:app/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget buildLogo() {
  return Image.asset(
    'lib/assets/logo.png',
    height: 125,
    width: 100,
  );
}

Widget buildVenueTitle() {
  return Text(
    'Venue',
    style: TextStyle(
      foreground: Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFFFFD700),
            Color(0xFFFFFACD),
            Color(0xFFFFD700),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
      fontFamily: 'Fredoka',
      fontSize: 75.0,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center,
  );
}

TextField buildTextField(TextEditingController controller, String hintText,
    {bool obscureText = false}) {
  return TextField(
    controller: controller,
    style: const TextStyle(
      color: Colors.white,
    ),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey[500],
      ),
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
        borderSide: BorderSide.none,
      ),
    ),
    obscureText: obscureText,
    cursorColor: Colors.white,
  );
}

Widget buildBottomNavigationBar(BuildContext context, int selectedIndex) {
  return SizedBox(
    height: 55,
    child: BottomNavigationBar(
      backgroundColor: Colors.black,
      currentIndex: selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled, size: 20),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, size: 20),
          label: 'Discover',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications, size: 20),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 20),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            newRoute(context, const NewsFeedPage());
            break;
          case 1:
            newRoute(context, const MapPage());
            break;
          case 2:
            newRoute(context, const NotificationsPage());
            break;
          case 3:
            newRoute(context, const ProfilePage());
            break;
        }
      },
    ),
  );
}

void newRoute(BuildContext context, Widget newRoute) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => newRoute),
  );
}

void showTopSnackBar(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context)
          .padding
          .top, // Position right below the status bar
      left: 10,
      right: 10,
      child: Material(
        elevation: 10.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  // Automatically remove the overlay after 3 seconds
  Future.delayed(const Duration(seconds: 3))
      .then((value) => overlayEntry.remove());
}

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
