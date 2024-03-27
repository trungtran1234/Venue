import 'package:flutter/material.dart';
import 'package:app/pages/main/newsfeed.dart';
import 'package:app/pages/main/profile.dart';
import 'package:app/pages/main/map.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  int _selectedIndex = 2;

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
        actions: [
          IconButton(
            onPressed: () {
              // Handle the action for the icon on the right side
            },
            icon: const Icon(Icons.search),
          ),
        ],
        title: const Text('Friends'),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context)
                    .padding
                    .top), // Add padding to avoid covering the app bar
            child: Column(
              children: List.generate(
                8,
                (index) => GestureDetector(
                  onTap: () {
                    // Handle tap on each friend
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(1),
                          spreadRadius: 1,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(25),
                          child: const CircleAvatar(
                            radius: 40,
                            child: CircleAvatar(radius: 8),
                          ),
                        ),
                        const Text("Profile Name"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
