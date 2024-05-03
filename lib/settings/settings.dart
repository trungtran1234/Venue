import 'package:app/pages/login.dart';
import 'package:app/global.dart';
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
        backgroundColor: const Color(0xFF0B1425),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
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
      'textColor': Colors.white,
      'description': 'Manage your account settings and personal information.'
    },
    {
      'title': 'Privacy',
      'icon': Icons.shield,
      'textColor': Colors.white,
      'description': 'Control your privacy settings and access permissions.'
    },
    {
      'title': 'Notifications',
      'icon': Icons.notifications,
      'textColor': Colors.white,
      'description': 'Customize your notification preferences.'
    },
    {
      'title': 'Log out',
      'icon': Icons.exit_to_app,
      'textColor': Colors.red,
      'description': 'Sign out of your account on this device.'
    },
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
            color: Colors.white, // Icons color
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                settingsOptions[index]['title'],
                style: TextStyle(
                  color: settingsOptions[index]['textColor'],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                settingsOptions[index]['description'],
                style: TextStyle(
                  color: Colors.grey[400], // Light grey for the description
                  fontSize: 12,
                ),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.white),
          contentPadding: const EdgeInsets.all(20),
          onTap: () {
            handleSettingsOptionTap(context, settingsOptions[index]['title']);
          },
        );
      },
    );
  }

  void handleSettingsOptionTap(BuildContext context, String title) {
    switch (title) {
      case 'Account':
        print("Account tapped");
        newRoute(context, const Account());
        break;
      case 'Privacy':
        newRoute(context, const Privacy());
        break;
      case 'Notifications':
        newRoute(context, const Notifications());
        break;
      case 'Log out':
        FirebaseAuth.instance.signOut();
        newRoute(context, LoginPage());
        break;
    }
  }
}
