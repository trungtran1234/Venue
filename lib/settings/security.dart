import 'package:app/global.dart';
import 'package:app/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  SecurityPageState createState() => SecurityPageState();
}

class SecurityPageState extends State<SecurityPage> {
  bool _twoFactorEnabled = false; // Assume this is fetched from the backend

  @override
  void initState() {
    super.initState();
    // Load the current state of two-factor authentication from your backend or Firebase
    _loadTwoFactorState();
  }

  void _loadTwoFactorState() {
    // Example: Check if user has 2FA enabled
    // This part would involve fetching data from your backend or Firebase
    final user = FirebaseAuth.instance.currentUser;
    // Assume we have a method to fetch 2FA state from Firebase or another service
    setState(() {
      _twoFactorEnabled =
          user != null && user.emailVerified; // Simplified example
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Security Settings',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            newRoute(context, SettingsPage());
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          ListTile(
            title: const Text('Change Password',
                style: TextStyle(color: Colors.white)),
            onTap: () => _changePassword(context),
          ),
          SwitchListTile(
            title: const Text('Enable Two-Factor Authentication',
                style: TextStyle(color: Colors.white)),
            subtitle: const Text(
                'Add an extra layer of security to your account',
                style: TextStyle(color: Colors.grey)),
            value: _twoFactorEnabled,
            onChanged: (bool value) {
              setState(() {
                _twoFactorEnabled = value;
              });
              _toggleTwoFactorAuthentication(value);
            },
            activeColor: Colors.white,
            activeTrackColor: Colors.green,
          ),
          ListTile(
            title: const Text('Session Management',
                style: TextStyle(color: Colors.white)),
            onTap: () => _manageSessions(context),
          ),
          ListTile(
            title: const Text('Security Alerts',
                style: TextStyle(color: Colors.white)),
            onTap: () => _setupSecurityAlerts(context),
          ),
        ],
      ),
    );
  }

  void _changePassword(BuildContext context) {
    // This method should redirect to a page where the user can change their password
  }

  void _toggleTwoFactorAuthentication(bool enabled) {
    // Enable or disable two-factor authentication
    // This would involve API calls to your backend or Firebase
  }

  void _manageSessions(BuildContext context) {
    // Manage active sessions, allowing users to see all devices where they're logged in and log out remotely
  }

  void _setupSecurityAlerts(BuildContext context) {
    // Setup or manage security alerts, such as receiving emails or SMS for unusual activities
  }
}
