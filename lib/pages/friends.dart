import 'package:flutter/material.dart';
import 'package:app/pages/map.dart';
import 'package:app/pages/newsfeed.dart';
import 'package:app/pages/profile.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            newRoute(context, const ProfilePage());
          },
          icon: const Icon(Icons.person),
        ),
        title: const Text('Friends'),
      ),
      body: const Center(
          // Your page content goes here
          ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
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
          if (index == 0) {
            newRoute(context, const NewsFeedPage());
          } else if (index == 1) {
            newRoute(context, const MapPage());
          }
        },
      ),
    );
  }
}
