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
