import 'package:app/pages/account.dart';
import 'package:app/pages/map.dart';
import 'package:app/pages/notifications.dart';
import 'package:app/pages/privacy.dart';
import 'package:app/pages/profile.dart';
import 'package:app/pages/login.dart';
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
          title: const Text('Settings'),
        ),
        body: SettingsList(),
      ),
    );
  }
}

class SettingsList extends StatelessWidget {
  SettingsList({super.key});

  final List<String> settingsOptions = [
    'Account',
    'Privacy',
    'Notifications',
    'Log out'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: settingsOptions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(settingsOptions[index]),
          contentPadding: const EdgeInsets.all(20),
          onTap: () {
            if (settingsOptions[index] == 'Account') {
              newRoute(context, const AccountSettings());
            } else if (settingsOptions[index] == 'Privacy') {
              newRoute(context, const Privacy());
            } else if (settingsOptions[index] == 'Notifications') {
              newRoute(context, const Notifications());
            } else {
              newRoute(context, const LoginPage());
            }
          },
        );
      },
    );
  }
}
