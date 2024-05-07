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
      onPressed: () async {
        // Trim the input and check for empty fields
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();

        String errorMessage = '';
        if (email.isEmpty && password.isEmpty) {
          errorMessage = 'Please enter your email and password.';
        } else if (email.isEmpty) {
          errorMessage = 'Please enter your email.';
        } else if (password.isEmpty) {
          errorMessage = 'Please enter your password.';
        }

        if (errorMessage.isNotEmpty) {
          showTopSnackBar(context, errorMessage);
          return;
        }

        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Handle email verification status
          User? user = userCredential.user;
          if (user != null) {
            if (!user.emailVerified) {
              showTopSnackBar(
                  context, 'Please verify your email address to log in.');
            } else {
              newRoute(context, const NewsFeedPage());
            }
          }
        } catch (e) {
          errorMessage = 'Login error: Please try again later.';
          if (e is FirebaseAuthException) {
            switch (e.code) {
              case 'user-not-found':
              case 'invalid-email':
                errorMessage = 'Invalid email address provided.';
                break;
              case 'wrong-password':
                errorMessage = 'Incorrect password, please try again.';
                break;
              default:
                errorMessage =
                    'Login error: ${e.message ?? "Please try again later."}';
                break;
            }
          }
          showTopSnackBar(context, errorMessage);
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
        'Login',
        style: TextStyle(
          fontFamily: 'Fredoka',
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildForgotPasswordOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            newRoute(context, ForgotPasswordPage());
          },
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              color: Color(0xFF007AFF),
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

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  ForgotPasswordPage({super.key});

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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildLogo(),
                    buildVenueTitle(),
                    Container(
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
                            'Find Your Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Fredoka',
                              color: Colors.white,
                              fontSize: 30.0,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Enter your email and we'll send you a link to reset your password.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          buildTextField(_emailController, 'Email'),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => _resetPassword(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF007AFF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: const Size(double.infinity, 55),
                            ),
                            child: const Text('Send Reset Link'),
                          ),
                          const SizedBox(height: 20),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text('OR'),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              newRoute(context, LoginPage());
                            },
                            child: const Text(
                              'Back to Login',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showTopSnackBar(
      BuildContext context, Widget content, Color backgroundColor) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(10),
            color: backgroundColor,
            child: content,
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Automatically remove the snackbar after some duration
    Future.delayed(const Duration(seconds: 3))
        .then((value) => overlayEntry.remove());
  }

  Future<void> _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      showTopSnackBar(
        context,
        const Text('Password reset link sent! Check your email.',
            style: TextStyle(color: Colors.white)),
        Colors.green,
      );
    } catch (e) {
      showTopSnackBar(
        context,
        const Text('Please enter your email.',
            style: TextStyle(color: Colors.white)),
        Colors.red,
      );
    }
  }
}
