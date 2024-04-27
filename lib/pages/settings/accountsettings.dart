import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChangeEmail extends StatelessWidget {
  const ChangeEmail({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Email'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter New Email:',
              style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white
              ),
            ),
            InputField(hintText: '', controller: emailController),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle changing email
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Current Password:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            InputField(
                hintText: 'Current Password',
                obscureText: true,
                controller: currentPasswordController),
            const SizedBox(height: 20.0),
            const Text(
              'Enter New Password:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            InputField(
                hintText: '',
                obscureText: true,
                controller: newPasswordController),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle changing password
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String hintText;
  final bool? obscureText;
  final TextEditingController controller;

  const InputField({
    super.key,
    required this.hintText,
    this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
