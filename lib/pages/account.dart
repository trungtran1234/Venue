import 'package:app/pages/map.dart';
import 'package:app/pages/settings.dart';
import 'package:flutter/material.dart';

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
                // Handle email address management
              },
            ),
            ListTile(
              title: const Text('Change Password'),
              onTap: () {
                // Handle changing password
              },
            ),
            ListTile(
              title: const Text('Linked Accounts'),
              onTap: () {
                // Handle linking/unlinking accounts
              },
            ),
            ListTile(
              title: const Text('Two-Factor Authentication (2FA)'),
              onTap: () {
                // Handle enabling/disabling 2FA
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
