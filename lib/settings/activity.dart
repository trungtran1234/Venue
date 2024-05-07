import 'package:app/global.dart';
import 'package:app/settings/settings.dart';
import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  bool _showLikes = true;
  bool _showShares = true;
  bool _showComments = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Activity Settings',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            newRoute(context, SettingsPage());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Show Likes',
                  style: TextStyle(color: Colors.white)),
              subtitle: const Text('Display your likes on friends\' posts',
                  style: TextStyle(color: Colors.grey)),
              value: _showLikes,
              onChanged: (bool value) {
                setState(() {
                  _showLikes = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: Colors.green,
            ),
            SwitchListTile(
              title: const Text('Show Shares',
                  style: TextStyle(color: Colors.white)),
              subtitle: const Text('Display your shares on friends\' posts',
                  style: TextStyle(color: Colors.grey)),
              value: _showShares,
              onChanged: (bool value) {
                setState(() {
                  _showShares = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: Colors.green,
            ),
            SwitchListTile(
              title: const Text('Show Comments',
                  style: TextStyle(color: Colors.white)),
              subtitle: const Text('Display your comments on friends\' posts',
                  style: TextStyle(color: Colors.grey)),
              value: _showComments,
              onChanged: (bool value) {
                setState(() {
                  _showComments = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
