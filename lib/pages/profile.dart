import 'package:app/pages/map.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/settings.dart';
import '../objects/userprofile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    UserProfile user = UserProfile(username: "username", location: "location");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              newRoute(context, const SettingsPage());
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      //body: const SingleChildScrollView( //to remove blue underlines
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('lib/assets/Default_pfp.svg.png'),
            ),
            const SizedBox(height: 20.0),
            Text(
              '${user.username}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '${user.location}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16.0),
            ),
            Container(
              width: 300, // Adjust width as needed
              child: Text(
                '${user.bio}',
                style: const TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, // Handles overflow text
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 115.0), // Adjust the value as needed
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 150.0),
                      const SizedBox(height: 10.0),
                      Text(
                        '${user.friends}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const Text(
                        'Friends',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  const VerticalDivider(thickness: 10, color: Colors.black),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 200.0),
                      const SizedBox(height: 10.0),
                      Text(
                        '${user.eventsAttended}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const Text(
                        'Events Attended',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 200.0),
                      const SizedBox(height: 10.0),
                      Text(
                        '${user.eventsHosted}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const Text(
                        'Events Hosted',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            const Row(
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
