import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                'Venue',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 100.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Create An Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF443636),
                      fontSize: 30.0,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  SignUpForm(),
                  SizedBox(
                      height:
                          20.0), // Add spacing between text fields and button
                  ElevatedButton(
                    onPressed: () {
                      // Handle sign-up logic here
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF437AE5)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
                        color: Colors.white, // Set text color to white
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.all(30.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Have an account? ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle navigation to sign-up page here
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

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
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'Email',
            filled: true,
            fillColor: Color(0xFFE6E6E6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 20.0),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: 'Username',
            filled: true,
            fillColor: Color(0xFFE6E6E6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 20.0),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: 'Password',
            filled: true,
            fillColor: Color(0xFFE6E6E6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
          obscureText: true,
        ),
        SizedBox(height: 20.0),
        TextField(
          controller: _reEnterPasswordController,
          decoration: InputDecoration(
            hintText: 'Re-Enter Password',
            filled: true,
            fillColor: Color(0xFFE6E6E6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
          obscureText: true,
        ),
      ],
    );
  }
}
