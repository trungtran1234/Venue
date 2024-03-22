import 'package:flutter/material.dart';
import 'package:app/pages/map.dart';
import 'package:app/pages/friends.dart';
import 'package:app/pages/profile.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeedPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
          icon: const Icon(Icons.person),
        ),
        title: const Text('News Feed'),
      ),
      body: const Center(
          // Your page content goes here
          ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
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
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            newRoute(context, const MapPage());
          } else if (index == 2) {
            newRoute(context, const FriendsPage());
          }
        },
      ),
    );
  }
}
