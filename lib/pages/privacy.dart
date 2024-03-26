import 'package:app/pages/map.dart';
import 'package:app/pages/settings.dart';
import 'package:flutter/material.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Privacy'),
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
