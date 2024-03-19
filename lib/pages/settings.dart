import 'package:flutter/material.dart';
import 'login.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        backgroundColor: Color(0xFF437AE5),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
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
  final List<String> settingsOptions = [
    'Account',
    'Security and Privacy',
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
            if (settingsOptions[index] == 'Log out') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            } else {
              // Handle navigation to other settings pages
            }
          },
        );
      },
    );
  }
}
