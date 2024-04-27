import 'package:app/pages/map.dart';
import 'package:app/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/auth.dart';
import 'package:app/functions.dart';


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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF133068),
              const Color(0xFF0B1425),
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

  Widget _buildLogo() {
    return Image.asset(
      '../lib/assets/logo.png',
      height: 90,
      width: 90,
    );
  }

  Widget _buildVenueTitle() {
    return Container(
      alignment: Alignment.center,
      child: const Text(
        'Venue',
        style: TextStyle(
          color: Color(0xFFE5B80B),
          fontFamily: 'Fredoka',
          fontSize: 65.0,
          fontWeight: FontWeight.bold,  
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text(
            'Sign into your account',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Fredoka',
              color: Color(0xFF443636),
              fontSize: 30.0,
            ),
          ),
          const SizedBox(height: 20.0),
          // Login form fields
          LoginForm(
            emailController: _emailController,
            passwordController: _passwordController,
          ),
          const SizedBox(height: 20.0),
          // Login button
          _buildLoginButton(context),
          const SizedBox(height: 10.0),
          
          // Forgot password option
          _buildForgotPasswordOption(),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          final User? user = await Auth().signInWithEmailAndPassword(
            _emailController.text,
            _passwordController.text,
          );
          if (user != null) {
            newRoute(context, const MapPage());
          } else {
            // Handle case where user is null
            final bool emailExists =
                await Auth().checkEmailExists(_emailController.text);
            if (!emailExists) {
              showErrorBanner(context, 'Email not registered.');
            } else {
              showErrorBanner(context, 'Incorrect password.');
            }
          }
        } catch (e) {
          // Handle login errors
          print('Login Error: $e');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF133068),
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size(double.infinity, 55),
      ),
      child: const Text(
        'Login',
        style: TextStyle(
          fontFamily: 'Fredoka',
          fontSize: 15.0,
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
            // Handle forgot password action here
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
          // GestureDetector for the sign-up option
          GestureDetector(
            onTap: () {
              newRoute(context, const SignUpPage());
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
