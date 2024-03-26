import 'package:app/pages/map.dart';
import 'package:app/pages/settings.dart';
import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Account'),
        leading: IconButton(
          onPressed: () {
            newRoute(context, const SettingsPage());
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: const Center(
          // Your page content goes here
          ),
    );
  }
}
