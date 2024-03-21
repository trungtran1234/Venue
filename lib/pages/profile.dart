import 'package:app/pages/map.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/settings.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // Fix back button going back to login page

        actions: [
          IconButton(
            onPressed: () {
              newRoute(context, const SettingsPage());
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/profile_picture.jpg'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Name',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Biography',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Friends, Events Attended, Events Hosted
              ],
            ),
          ],
        ),
      ),
    );
  }
}
