import 'package:flutter/material.dart';
import 'package:app/global.dart';
import 'package:app/settings/settings.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  AccountSettingsState createState() => AccountSettingsState();
}

class AccountSettingsState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Account Settings',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            newRoute(context, SettingsPage());
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            const Text(
              'Account Information',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            ListTile(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Email Address',
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  Text(
                    'johndoe@example.com',
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ),
              onTap: () {
                newRoute(context, const ChangeEmail());
              },
            ),
            ListTile(
              title: const Text(
                'Change Password',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                newRoute(context, const ChangePassword());
              },
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Account Management',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            ListTile(
              title: const Text(
                'Delete Account',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

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
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
        title: const Text('Change Password',
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Current Password:',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            InputField(
                hintText: 'Current Password',
                obscureText: true,
                controller: currentPasswordController),
            const SizedBox(height: 20.0),
            const Text(
              'Enter New Password:',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
