import 'package:app/login.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Venue title
            Container(
              alignment: Alignment.center,
              child: Text(
                'Venue',
                style: TextStyle(
                  color: Colors.orange,
                  fontFamily: 'Fredoka',
                  fontSize: 75.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0), // Spacer
            // Container for the sign-up form
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: [
                  // Title for the sign-up form
                  Text(
                    'Create An Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF443636),
                      fontFamily: 'Fredoka',
                      fontSize: 30.0,
                    ),
                  ),
                  SizedBox(height: 20.0), // Spacer
                  // Sign-up form fields
                  SignUpForm(),
                  SizedBox(height: 20.0), // Spacer
                  // Create Account button
                  ElevatedButton(
                    onPressed: () {
                      // Handle sign-up logic here
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF437AE5)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 25.0),
                      ),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(double.infinity,
                            55), // Set the width to be as wide as possible
                      ),
                    ),
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 15.0,
                        color: Colors.white, // Set text color to white
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0), // Spacer
            // Container for the sign-up option
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Have an account? ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  ),
                  // GestureDetector for the login option
                  GestureDetector(
                    onTap: () {
                      // Handle navigation to login page
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      'Login',
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

// SignUpForm widget containing the sign-up form fields
class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPasswordController =
      TextEditingController();

  // String? _validateEmail(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter your email';
  //   }
  // }

  // String? _validateUsername(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter a username';
  //   }
  // }

  // String? _validatePassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter a password';
  //   }
  // }

  // String? _validateReEnterPassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please re-enter your password';
  //   }
  //   if (value != _passwordController.text) {
  //     return 'Passwords do not match';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email field
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'Email',
            filled: true,
            fillColor: Color(0xFFE6E6E6),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 20.0), // Spacer
        // Username field
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: 'Username',
            filled: true,
            fillColor: Color(0xFFE6E6E6),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 20.0), // Spacer
        // Password field
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: 'Password',
            filled: true,
            fillColor: Color(0xFFE6E6E6),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide.none,
            ),
          ),
          obscureText: true,
        ),
        SizedBox(height: 20.0), // Spacer
        // Re-enter password field
        TextField(
          controller: _reEnterPasswordController,
          decoration: InputDecoration(
            hintText: 'Re-Enter Password',
            filled: true,
            fillColor: Color(0xFFE6E6E6),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide.none,
            ),
          ),
          obscureText: true,
        ),
      ],
    );
  }
}
