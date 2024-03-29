import 'package:app/pages/map.dart';
import 'package:app/pages/settings/settings.dart';
import 'package:flutter/material.dart';

class Privacy extends StatefulWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  bool _privateAccount = true;
  bool _hideFromSearch = true;
  bool _hideOnlineStatus = false;
  bool _allowFriendRequests = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Privacy'),
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
            const Text(
              'Account Privacy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Private Account'),
              subtitle:
                  const Text('Only approved followers can see your posts'),
              value: _privateAccount,
              onChanged: (value) {
                setState(() {
                  _privateAccount = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Hide From Search'),
              subtitle: const Text(
                  'Prevent your account from appearing in search results'),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Hide Online Status'),
              subtitle: const Text('Hide your online status from other users'),
              value: _hideOnlineStatus,
              onChanged: (value) {
                setState(() {
                  _hideOnlineStatus = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Allow Friend Requests'),
              subtitle: const Text('Allow others to send you friend requests'),
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
