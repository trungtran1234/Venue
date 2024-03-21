import 'package:app/pages/profile.dart';
import 'package:app/pages/settings.dart';
import 'package:app/pages/friends.dart';
import 'package:app/pages/newsfeed.dart';
import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewsFeedPage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MapPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FriendsPage()),
            );
          }
        },
      ),
    );
  }

  // void _showCreateEventModal(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true, // Allow the modal to fill the whole page
  //     builder: (BuildContext context) {
  //       return SingleChildScrollView(
  //         child: Padding(
  //           padding: EdgeInsets.only(
  //             bottom: MediaQuery.of(context).viewInsets.bottom,
  //             left: 20,
  //             right: 20,
  //             top: 20,
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   const Text(
  //                     'Create Event',
  //                     style: TextStyle(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   IconButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     icon: const Icon(Icons.close),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 20),
  //               const TextField(
  //                 decoration: InputDecoration(
  //                   hintText: 'Event Name',
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               const TextField(
  //                 decoration: InputDecoration(
  //                   hintText: 'Location',
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               TextFormField(
  //                 maxLines: null, // Multiline
  //                 decoration: const InputDecoration(
  //                   hintText: 'Description',
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               Row(
  //                 children: [
  //                   Checkbox(
  //                     value: false, // Initial value for friends only checkbox
  //                     onChanged: (bool? value) {},
  //                   ),
  //                   const Text('Friends Only'),
  //                 ],
  //               ),
  //               const SizedBox(height: 20),
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Text('Create Event'),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
