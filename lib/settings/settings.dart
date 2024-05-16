import 'package:app/global.dart';
import 'package:app/pages/login.dart';
import 'package:app/pages/profile.dart';
import 'package:app/services/preferences.dart';
import 'package:app/settings/editsettings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late bool _eventUpdates;
  late bool _eventReminders;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _reloadUser();
  }

  void _reloadUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.reload().then((_) {
        setState(() {});
      }).catchError((error) {});
    }
  }

  void _loadSettings() async {
    _eventUpdates =
        PreferencesService().getBool('eventUpdates', defaultValue: true);
    _eventReminders =
        PreferencesService().getBool('eventReminders', defaultValue: true);
    setState(() {});
  }

  void _updateSetting(String key, bool value) async {
    await PreferencesService().setBool(key, value);
    setState(() {
      if (key == 'eventUpdates') {
        _eventUpdates = value;
      } else if (key == 'eventReminders') {
        _eventReminders = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            newRoute(context, const ProfilePage());
          },
        ),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Account Management',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: const Text(
                'Email',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                user?.email ?? 'No email set',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
            ListTile(
                title: const Text('Change Password',
                    style: TextStyle(color: Colors.white)),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onTap: () {
                  newRoute(context, ChangePasswordPage());
                }),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Delete Account',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () => confirmDeleteAccount(context, user),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Log Out',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
