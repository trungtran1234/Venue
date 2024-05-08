import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/pages/login.dart';
import 'package:app/global.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPasswordController =
      TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121212), Color.fromARGB(255, 16, 19, 24)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildLogo(),
                  buildVenueTitle(),
                  _buildSignUpForm(context),
                  const SizedBox(height: 20.0),
                  _buildLoginOption(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Colors.black26,
              spreadRadius: 1,
              blurRadius: 15,
              offset: Offset(0, 5)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const Text('Create An Account',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 30.0)),
            const SizedBox(height: 20),
            buildTextField(_emailController, 'Email'),
            const SizedBox(height: 20),
            buildTextField(_passwordController, 'Password', obscureText: true),
            const SizedBox(height: 20),
            buildTextField(_reEnterPasswordController, 'Re-Enter Password',
                obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _handleSignUp(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(double.infinity, 55)),
              child: const Text('Create Account',
                  style: TextStyle(fontSize: 15, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSignUp(BuildContext context) async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _reEnterPasswordController.text.isEmpty) {
      showTopSnackBar(context, 'Please fill in all fields');
      return;
    }
    if (_passwordController.text != _reEnterPasswordController.text) {
      showTopSnackBar(context, 'Passwords do not match');
      return;
    }
    try {
      User? user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      if (user != null) {
        await user.sendEmailVerification();
        showVerificationDialog(context, user);
      }
    } catch (e) {
      showTopSnackBar(
          context, 'The email is already in use by another account.');
    }
  }

  Widget _buildLoginOption(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Have an account? ',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
          GestureDetector(
            onTap: () {
              newRoute(context, LoginPage());
            },
            child: const Text(
              'Login',
              style: TextStyle(
                color: Color(0xFF007AFF),
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showVerificationDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Verify Your Email'),
        content: Text(
            'A verification email has been sent to ${user.email}. Please verify your account before logging in.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              newRoute(context, LoginPage());
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
