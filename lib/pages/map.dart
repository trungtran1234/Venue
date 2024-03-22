import 'package:app/pages/profile.dart';
import 'package:app/pages/friends.dart';
import 'package:app/pages/newsfeed.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Map'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
          icon: const Icon(Icons.person),
        ),
      ),
      body: const Center(
          // Your page content goes here
          ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex, // Set the current index
        selectedItemColor: Colors.blue, // Set the selected item color to blue
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
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            newRoute(context, const NewsFeedPage());
          } else if (index == 2) {
            newRoute(context, const FriendsPage());
          }
        },
      ),
    );
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
