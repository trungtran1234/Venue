import 'package:app/pages/friends.dart';
import 'package:app/pages/map.dart';
import 'package:app/pages/newsfeed.dart';
import 'package:app/pages/notifications.dart';
import 'package:app/pages/profile.dart';
import 'package:app/settings/notifications.dart';
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
    decoration: InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFE6E6E6),
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
  );
}

BottomNavigationBar buildBottomNavigationBar(
    BuildContext context, int selectedIndex) {
  return BottomNavigationBar(
    backgroundColor: Colors.transparent,
    currentIndex: selectedIndex,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_filled),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Discover',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.notifications),
        label: 'Notifications',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
    onTap: (index) {
      _onItemTapped(context, index);
    },
  );
}

void _onItemTapped(BuildContext context, int index) {
  if (index == 0) {
    newRoute(context, const NewsFeedPage());
  } else if (index == 1) {
    newRoute(context, const MapPage());
  } else if (index == 2) {
    newRoute(context, const NotificationsPage());
  } else {
    newRoute(context, const ProfilePage());
  }
}

void newRoute(BuildContext context, Widget newRoute) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => newRoute),
  );
}

void showErrorBanner(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Some optional action when OK is pressed
        },
      ),
    ),
  );
}

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  print('No image selected');
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
