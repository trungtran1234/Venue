import 'package:app/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/functions.dart';

class SignUpForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController reEnterPasswordController;

  const SignUpForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.reEnterPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTextField(emailController, 'Email'),
        const SizedBox(height: 20.0),
        buildTextField(passwordController, 'Password', obscureText: true),
        const SizedBox(height: 20.0),
        buildTextField(reEnterPasswordController, 'Re-Enter Password',
            obscureText: true),
      ],
    );
  }
}

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reEnterPasswordController =
      TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF133068),
              Color(0xFF0B1425),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLogo(),
                    _buildVenueTitle(),
                    _buildSignUpForm(
                      context,
                      emailController,
                      passwordController,
                      reEnterPasswordController,
                    ),
                    const SizedBox(height: 20.0),
                    _buildLoginOption(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'lib/assets/logo.png',
      height: 125,
      width: 100,
    );
  }

  Widget _buildVenueTitle() {
    return Text(
      'Venue',
      style: TextStyle(
        foreground: Paint()
          ..shader = const LinearGradient(
            colors: [
              Color(0xFFFFD700),
              Color(0xFFFFFACD),
              Color(0xFFFFD700),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
        fontFamily: 'Fredoka',
        fontSize: 75.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSignUpForm(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController reEnterPasswordController,
  ) {
    return Container(
      padding: const EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Create An Account',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF443636),
              fontFamily: 'Fredoka',
              fontSize: 30.0,
            ),
          ),
          const SizedBox(height: 20.0),
          SignUpForm(
            emailController: emailController,
            passwordController: passwordController,
            reEnterPasswordController: reEnterPasswordController,
          ),
          const SizedBox(height: 20.0),
          _buildSignUpButton(
            context,
            emailController,
            passwordController,
            reEnterPasswordController,
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController reEnterPasswordController,
  ) {
    return ElevatedButton(
      onPressed: () async {
        if (emailController.text.isEmpty ||
            passwordController.text.isEmpty ||
            reEnterPasswordController.text.isEmpty) {
          showErrorBanner(context, 'Please fill in all fields');
          return;
        }

        if (passwordController.text != reEnterPasswordController.text) {
          showErrorBanner(context, 'Passwords do not match');
          return;
        }

        try {
          User? user =
              (await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          ))
                  .user;

          if (user != null) {
            await user.sendEmailVerification(); // send verification email

            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Verify Your Email'),
                content: Text(
                    'A verification email has been sent to ${user.email}. Please verify your account before logging in.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        } catch (e) {
          showErrorBanner(context, 'Error during sign-up: ${e.toString()}');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF133068),
        padding: const EdgeInsets.symmetric(vertical: 25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size(double.infinity, 55),
      ),
      child: const Text(
        'Create Account',
        style: TextStyle(
          fontFamily: 'Fredoka',
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLoginOption(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
                color: Colors.blue,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
