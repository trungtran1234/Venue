import 'package:app/pages/login.dart';
import 'package:app/functions.dart';
import 'package:app/pages/profile.dart';
import 'package:app/settings/account.dart';
import 'package:app/settings/notifications.dart';
import 'package:app/settings/privacy.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  final LocalAuthentication auth = LocalAuthentication();

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

  Future<void> authenticateAndNavigate(BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to access account settings',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (didAuthenticate) {
        newRoute(context, const Account());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Authentication failed. Please try again.')),
        );
      }
    } catch (e) {
      print('Error during authentication: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during authentication.')),
      );
    }
  }

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
              print("Account tapped");
              newRoute(context, const Account());
              // authenticateAndNavigate(context);
            } else if (settingsOptions[index]['title'] == 'Privacy') {
              newRoute(context, const Privacy());
            } else if (settingsOptions[index]['title'] == 'Notifications') {
              newRoute(context, const Notifications());
            } else if (settingsOptions[index]['title'] == 'Devices') {
            } else {
              FirebaseAuth.instance.signOut();
              newRoute(context, LoginPage());
            }
          },
        );
      },
    );
  }
}
