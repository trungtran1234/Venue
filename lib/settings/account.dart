import 'package:app/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:app/global.dart';
import 'package:app/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  AccountSettingsState createState() => AccountSettingsState();
}

class AccountSettingsState extends State<Account> {
  String userEmail = ''; // Variable to store user's email

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  void _loadUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      setState(() {
        userEmail = user.email!;
      });
    }
  }

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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Email Address',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    userEmail, // Display the current user's email
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Icon(
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
              onTap: () async {
                // Show a confirmation dialog
                final bool confirmDelete = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text(
                            'Are you sure you want to delete your account? This action cannot be undone.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(false); // User presses "No"
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(true); // User presses "Yes"
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    ) ??
                    false; // if null, consider it as "false"

                if (confirmDelete) {
                  final user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    try {
                      await user.delete();
                      // Log out from Firebase Auth after deletion
                      await FirebaseAuth.instance.signOut();
                      // If deletion and sign out are successful, navigate to a login or home screen
                      newRoute(context, LoginPage());
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'requires-recent-login') {
                        // Handle the case where the user needs to re-authenticate
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                'Please re-authenticate and try again.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // Optionally navigate to a re-authentication screen
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Handle other errors
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: Text('An error occurred: ${e.message}'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  ChangeEmailState createState() => ChangeEmailState();
}

class ChangeEmailState extends State<ChangeEmail> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Email'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            newRoute(context, const Account());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            InputField(
              controller: emailController,
              labelText: 'Enter New Email',
            ),
            InputField(
              controller: passwordController,
              labelText: 'Enter Current Password',
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _changeEmail,
                    child: const Text('Save'),
                  ),
          ],
        ),
      ),
    );
  }

  void _changeEmail() async {
    final String newEmail = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (newEmail.isEmpty || password.isEmpty) {
      _showDialog('Error', 'Please enter all fields.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Re-authenticate user
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: _auth.currentUser!.email!, password: password);

      // Update email after successful re-authentication
      await credential.user!.updateEmail(newEmail);
      await credential.user!.sendEmailVerification();

      _showDialog('Confirmation Needed',
          'Please confirm your new email. A confirmation link has been sent to $newEmail.');
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: ${e.code} - ${e.message}');
      _showDialog(
          'Error',
          e.message ??
              'An unexpected error occurred. Please ensure the email is formatted correctly and try again.');
    } catch (e) {
      print('General Exception: $e');
      _showDialog('Error', 'An unexpected error occurred. Please try again.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            newRoute(context, const Account());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            InputField(
              controller: currentPasswordController,
              labelText: 'Enter Current Password',
              obscureText: true,
            ),
            InputField(
              controller: newPasswordController,
              labelText: 'Enter New Password',
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _changePassword,
                    child: const Text('Save'),
                  ),
          ],
        ),
      ),
    );
  }

  void _changePassword() async {
    final String currentPassword = currentPasswordController.text.trim();
    final String newPassword = newPasswordController.text.trim();
    if (currentPassword.isEmpty || newPassword.isEmpty) {
      _showDialog('Error', 'Please fill in all fields.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Attempt to re-authenticate the user
    try {
      User? user = _auth.currentUser;
      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(cred);

      // If re-authentication is successful, proceed to update the password
      await user.updatePassword(newPassword);
      _showDialog('Success', 'Your password has been updated successfully.');
    } on FirebaseAuthException catch (e) {
      _showDialog(
          'Error', e.message ?? 'An error occurred while updating password.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;

  const InputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 8.0), // Added padding for consistency
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          isDense: true, // Added isDense for consistency
        ),
      ),
    );
  }
}
