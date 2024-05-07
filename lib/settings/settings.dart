import 'package:app/pages/login.dart';
import 'package:app/global.dart';
import 'package:app/pages/profile.dart';
import 'package:app/settings/account.dart';
import 'package:app/settings/notifications.dart';
import 'package:app/settings/privacy.dart';
import 'package:app/settings/activity.dart';
import 'package:app/settings/security.dart';
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
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
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
      'title': 'Activity',
      'icon': Icons.timeline,
      'textColor': Colors.white,
      'description': 'Review your recent activity and history.'
    },
    {
      'title': 'Security',
      'icon': Icons.security,
      'textColor': Colors.white,
      'description':
          'Manage your security settings like passwords and authentication.'
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during authentication.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ...settingsOptions.map((option) => ListTile(
              leading: Icon(
                option['icon'],
                color: Colors.white,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option['title'],
                    style: TextStyle(
                      color: option['textColor'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    option['description'],
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.white),
              contentPadding: const EdgeInsets.all(20),
              onTap: () => handleSettingsOptionTap(context, option['title']),
            )),
        const Divider(color: Colors.white, height: 40),
        ListTile(
          leading: const Icon(
            Icons.exit_to_app,
            color: Colors.red,
          ),
          title: const Text(
            'Log out',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.white),
          contentPadding: const EdgeInsets.all(20),
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ],
    );
  }

  void handleSettingsOptionTap(BuildContext context, String title) {
    switch (title) {
      case 'Account':
        newRoute(context, const Account());
        break;
      case 'Privacy':
        newRoute(context, const Privacy());
        break;
      case 'Notifications':
        newRoute(context, const Notifications());
        break;
      case 'Activity':
        newRoute(context, const ActivityPage());
        break;
      case 'Security':
        newRoute(context, const SecurityPage());
        break;
      case 'Log out':
        FirebaseAuth.instance.signOut();
        newRoute(context, LoginPage());
        break;
    }
  }
}
