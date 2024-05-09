import 'package:app/pages/newsfeed.dart';
import 'package:app/pages/resetpassword.dart';
import 'package:app/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/global.dart';

const kBackgroundColor = Color(0xFF121212);
const kBoxDecorationColor = Color(0xFF1E1E1E);
const kPrimaryColor = Color(0xFF007AFF);
const kErrorColor = Colors.red;

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
            colors: [kBackgroundColor, Color.fromARGB(255, 16, 19, 24)],
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
        color: kBoxDecorationColor,
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
            'Sign Into Your Account',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Fredoka',
              color: Colors.white,
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
          _buildForgotPasswordOption(context),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleLogin(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
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

  void _handleLogin(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    String? errorMessage;
    if (email.isEmpty || password.isEmpty) {
      errorMessage = 'Please enter your email and password.';
    } else {
      try {
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        final user = userCredential.user;
        if (user != null && user.emailVerified) {
          newRoute(context, const NewsFeedPage());
        } else {
          showTopSnackBar(
              context, 'Please verify your email address to log in.');
        }
      } on FirebaseAuthException catch (e) {
        errorMessage = 'Incorrect password. Please try again.';
      } catch (e) {
        errorMessage = 'An unexpected error occurred. Please try again later.';
      }
    }
    if (errorMessage != null) {
      showTopSnackBar(context, errorMessage);
    }
  }

  Widget _buildForgotPasswordOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            newRoute(context, ResetPasswordPage());
          },
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              color: kPrimaryColor,
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
        color: kBoxDecorationColor,
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
                color: kPrimaryColor,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
