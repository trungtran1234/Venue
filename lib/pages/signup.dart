import 'package:app/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/global.dart';

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
              Color(0xFF121212),
              Color.fromARGB(255, 16, 19, 24),
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
                    buildLogo(),
                    buildVenueTitle(),
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

  Widget _buildSignUpForm(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController reEnterPasswordController,
  ) {
    return Container(
      padding: const EdgeInsets.all(30.0),
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
      child: Column(
        children: [
          const Text(
            'Create An Account',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
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
          showTopSnackBar(context, 'Please fill in all fields');
          return;
        }

        if (passwordController.text != reEnterPasswordController.text) {
          showTopSnackBar(context, 'Passwords do not match');
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
            await user.sendEmailVerification();

            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Verify Your Email'),
                content: Text(
                    'A verification email has been sent to ${user.email}. Please verify your account before logging in.'),
                actions: <Widget>[
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
        } catch (e) {
          showTopSnackBar(
              context, 'The email is already in use by another account.');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007AFF),
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
}
