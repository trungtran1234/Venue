import 'package:flutter/material.dart';
import 'package:app/pages/map.dart';

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
        leading: profile(context),
        actions: [
          IconButton(
            onPressed: () {
              // Handle the action for the icon on the right side
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: friendsList(context),
      bottomNavigationBar: buildBottomNavigationBar(context, _selectedIndex),
    );
  }

  Container friendsList(BuildContext context) {
    return Container(
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
    );
  }
}
