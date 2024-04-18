import 'package:app/pages/friends.dart';
import 'package:app/pages/map.dart';
import 'package:app/pages/newsfeed.dart';
import 'package:app/pages/profile.dart';
import 'package:flutter/material.dart';

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

IconButton profile(BuildContext context) {
  return IconButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    },
    icon: const Icon(Icons.person),
  );
}

BottomNavigationBar buildBottomNavigationBar(
    BuildContext context, int selectedIndex) {
  return BottomNavigationBar(
    backgroundColor: Colors.white,
    currentIndex: selectedIndex,
    selectedItemColor: Colors.blue,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.newspaper),
        label: 'Feed',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.map),
        label: 'Map',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.group),
        label: 'Friends',
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
  } else {
    newRoute(context, const FriendsPage());
  }
}

void newRoute(BuildContext context, Widget newRoute) {
  if (!Navigator.of(context).canPop()) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => newRoute));
  } else {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => newRoute));
  }
}

void showErrorBanner(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Some optional action when OK is pressed
        },
      ),
    ),
  );
}
