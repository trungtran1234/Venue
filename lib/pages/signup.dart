import 'package:app/pages/login.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            // Venue title
            Container(
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
            // Container for the sign-up form
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  const
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
                  const SizedBox(height: 20.0), // Spacer
                  // Sign-up form fields
                  SignUpForm(),
                  const SizedBox(height: 20.0), // Spacer
                  // Create Account button
                  ElevatedButton(
                    onPressed: () {
                      // Handle sign-up logic here
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF437AE5)),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(_emailController, 'Email'),
        const SizedBox(height: 20.0),
        _buildTextField(_usernameController, 'Username'),
        const SizedBox(height: 20.0),
        _buildTextField(_passwordController, 'Password', obscureText: true),
        const SizedBox(height: 20.0),
        _buildTextField(
          _reEnterPasswordController,
          'Re-Enter Password',
          obscureText: true,
        ),
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
