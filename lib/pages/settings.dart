import 'package:flutter/material.dart';
import 'login.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blue,
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('Settings'),
        ),
        body: SettingsList(),
      ),
    );
  }
}

class SettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Account'),
          onTap: () {
            // Navigate to Account settings page
            // You can implement navigation here
          },
        ),
        ListTile(
          title: Text('Security and Privacy'),
          onTap: () {
            // Navigate to Security and Privacy settings page
            // You can implement navigation here
          },
        ),
        ListTile(
          title: Text('Notifications'),
          onTap: () {
            // Navigate to Notifications settings page
            // You can implement navigation here
          },
        ),
        ListTile(
          title: Text('Premium'),
          onTap: () {
            // Navigate to Premium settings page
            // You can implement navigation here
          },
        ),
        ListTile(
          title: Text('Preferences'),
          onTap: () {
            // Navigate to Preferences settings page
            // You can implement navigation here
          },
        ),
        ListTile(
            title: Text('Log out'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            }),
      ],
    );
  }
}
