import 'package:app/pages/map.dart';
import 'package:app/pages/newsfeed.dart';
import 'package:app/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/global.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTextField(emailController, 'Email'),
        const SizedBox(height: 20.0),
        buildTextField(passwordController, 'Password', obscureText: true),
        const SizedBox(height: 20.0),
      ],
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

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
                    buildLogo(),
                    buildVenueTitle(),
                    _buildLoginForm(context),
                    const SizedBox(height: 20.0),
                    _buildSignUpOption(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Sign Into Your Account',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Fredoka',
              color: Color(0xFF443636),
              fontSize: 30.0,
            ),
          ),
          const SizedBox(height: 20.0),
          LoginForm(
            emailController: _emailController,
            passwordController: _passwordController,
          ),
          _buildLoginButton(context),
          const SizedBox(height: 10.0),
          _buildForgotPasswordOption(),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          User? user = userCredential.user;
          if (user != null && !user.emailVerified) {
            showErrorBanner(
                context, 'Please verify your email address to log in.');
          } else if (user != null && user.emailVerified) {
            newRoute(context, const NewsFeedPage());
          } else {
            showErrorBanner(
                context, 'Unexpected error occurred. Please try again.');
          }
        } catch (e) {
          if (e is FirebaseAuthException) {
            if (e.code == 'user-not-found') {
              showErrorBanner(context, 'No user found for that email.');
            } else if (e.code == 'wrong-password') {
              showErrorBanner(
                  context, 'Wrong password provided for that user.');
            } else {
              showErrorBanner(context, e.message ?? 'Failed to login.');
            }
          } else {
            showErrorBanner(context, 'Login error: ${e.toString()}');
          }
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
        'Login',
        style: TextStyle(
          fontFamily: 'Fredoka',
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildForgotPasswordOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            //forgot password logic here
          },
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpOption(BuildContext context) {
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
            'Need an account? ',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
          GestureDetector(
            onTap: () {
              newRoute(context, SignUpPage());
            },
            child: const Text(
              'Sign Up',
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
