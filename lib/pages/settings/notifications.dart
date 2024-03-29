import 'package:app/pages/map.dart';
import 'package:app/pages/settings/settings.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool _notificationEnabled = true;
  bool _likes = true;
  bool _comments = true;
  bool _shares = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Notifications'),
        leading: IconButton(
          onPressed: () {
            newRoute(context, const SettingsPage());
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Receive Notifications',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _notificationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationEnabled = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Notification Settings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text('Likes'),
              subtitle: const Text('Receive notifications for likes'),
              value: _likes,
              onChanged: (value) {
                setState(() {
                  _likes = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Comments'),
              subtitle: const Text('Receive notifications for comments'),
              value: _comments,
              onChanged: (value) {
                setState(() {
                  _comments = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Shares'),
              subtitle: const Text('Receive notifications for shares'),
              value: _shares,
              onChanged: (value) {
                setState(() {
                  _shares = value;
                });
              },
            ),
            // Add more ListTile widgets for additional notification settings
          ],
        ),
      ),
    );
  }
}
