import 'package:app/pages/map.dart';
import 'package:app/pages/profile.dart';
import 'package:app/pages/signup_and_login.dart';
import 'package:app/pages/settings/accountsettings.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        backgroundColor: const Color(0xFF437AE5),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              newRoute(context, const ProfilePage());
            },
          ),
        ),
        body: SettingsList(),
      ),
    );
  }
}

class SettingsList extends StatelessWidget {
  SettingsList({super.key});

  final List<Map<String, dynamic>> settingsOptions = [
    {
      'title': 'Account',
      'icon': Icons.account_circle,
      'textColor': Colors.black
    },
    {'title': 'Privacy', 'icon': Icons.shield, 'textColor': Colors.black},
    {
      'title': 'Notifications',
      'icon': Icons.notifications,
      'textColor': Colors.black
    },
    {'title': 'Devices', 'icon': Icons.laptop, 'textColor': Colors.black},
    {'title': 'Log out', 'icon': Icons.exit_to_app, 'textColor': Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: settingsOptions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(
            settingsOptions[index]['icon'],
            color: Colors.black,
          ),
          title: Row(
            children: [
              Text(
                settingsOptions[index]['title'],
                style: TextStyle(
                  color: settingsOptions[index]['textColor'],
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.black),
            ],
          ),
          contentPadding: const EdgeInsets.all(20),
          onTap: () {
            if (settingsOptions[index]['title'] == 'Account') {
              newRoute(context, const AccountSettings());
            } else if (settingsOptions[index]['title'] == 'Privacy') {
              newRoute(context, const Privacy());
            } else if (settingsOptions[index]['title'] == 'Notifications') {
              newRoute(context, const Notifications());
            } else if (settingsOptions[index]['title'] == 'Devices') {
            } else {
              newRoute(context, const LoginPage());
            }
          },
        );
      },
    );
  }
}

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Account Settings'),
        leading: IconButton(
          onPressed: () {
            newRoute(context, const SettingsPage());
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            const Text(
              'Account Information',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Email Address'),
                  Spacer(),
                  Text('johndoe@example.com'),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                newRoute(context, const ChangeEmail());
              },
            ),
            ListTile(
              title: const Text('Change Password'),
              onTap: () {
                newRoute(context, const ChangePassword());
              },
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Account Management',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              title: const Text(
                'Delete Account',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

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
