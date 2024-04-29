import 'package:app/functions.dart';
import 'package:flutter/material.dart';
import 'package:app/settings/settings.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  PrivacyState createState() => PrivacyState();
}

class PrivacyState extends State<Privacy> {
  bool _privateAccount = true;
  bool _hideFromSearch = true;
  bool _hideOnlineStatus = true;
  bool _allowFriendRequests = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Privacy', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: () {
            newRoute(context, SettingsPage());
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Privacy',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            buildSwitchListTile(
              title: 'Private Profile',
              subtitle: 'Only friends can see your posts',
              value: _privateAccount,
              onChanged: (value) {
                setState(() {
                  _privateAccount = value;
                });
              },
            ),
            buildSwitchListTile(
              title: 'Hide From Search',
              subtitle: 'Prevent your profile from appearing in search results',
              value: _hideFromSearch,
              onChanged: (value) {
                setState(() {
                  _hideFromSearch = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Activity Privacy',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            buildSwitchListTile(
              title: 'Hide Online Status',
              subtitle: 'Hide your online status from other users',
              value: _hideOnlineStatus,
              onChanged: (value) {
                setState(() {
                  _hideOnlineStatus = value;
                });
              },
            ),
            buildSwitchListTile(
              title: 'Allow Friend Requests',
              subtitle: 'Allow others to send you friend requests',
              value: _allowFriendRequests,
              onChanged: (value) {
                setState(() {
                  _allowFriendRequests = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildTile({
  required String title,
  String? subtitle,
  Color textColor = Colors.black,
  VoidCallback? onTap,
}) {
  return ListTile(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title),
        const Spacer(),
        if (subtitle != null) Text(subtitle),
        const Icon(Icons.arrow_forward_ios, size: 16),
      ],
    ),
    onTap: onTap,
    contentPadding: EdgeInsets.zero,
    trailing: const SizedBox(width: 24.0), // Adjust trailing space
  );
}

Widget buildSwitchListTile({
  required String title,
  required String subtitle,
  required bool value,
  required Function(bool)? onChanged,
}) {
  return SwitchListTile(
    title: Text(title, style: const TextStyle(color: Colors.white)),
    subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
    value: value,
    onChanged: onChanged,
    activeColor: Colors.white,
    activeTrackColor: Colors.green,
  );
}
