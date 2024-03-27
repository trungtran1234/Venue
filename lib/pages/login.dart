import 'package:app/pages/main/map.dart';
import 'package:app/pages/signup.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Venue title
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Venue',
                style: TextStyle(
                  color: Colors.orange,
                  fontFamily: 'Fredoka',
                  fontSize: 75.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10.0), // Spacer
            // Container for the login form
            Container(
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  // Title for the login form
                  const Text(
                    'Sign into your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      color: Color(0xFF443636),
                      fontSize: 30.0,
                    ),
                  ),
                  const SizedBox(height: 20.0), // Spacer
                  // Login form fields
                  LoginForm(),
                  const SizedBox(height: 20.0), // Spacer
                  // Login button
                  ElevatedButton(
                    onPressed: () {
                      newRoute(context, const MapPage());
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF437AE5)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(vertical: 25.0),
                      ),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(double.infinity,
                            55), // Set the width to be as wide as possible
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 15.0,
                        color: Colors.white, // Set text color to white
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // Forgot password option
                  Row(
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
                  )
                ],
              ),
            ),
            const SizedBox(height: 20.0), // Spacer
            // Container for the sign-up option
            Container(
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
            ),
          ],
        ),
      ),
    );
  }
}

// LoginForm widget containing the login form fields
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(_emailController, 'Email'),
        const SizedBox(height: 20.0),
        _buildTextField(_passwordController, 'Password', obscureText: true),
        const SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFE6E6E6),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: obscureText,
    );
  }
}
