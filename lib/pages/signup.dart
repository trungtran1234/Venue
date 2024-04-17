import 'package:app/pages/login.dart';
import 'package:app/pages/map.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/auth.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const Text(
              'Venue',
              style: TextStyle(
                color: Colors.orange,
                fontFamily: 'Fredoka',
                fontSize: 75.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(30.0),
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
                    emailController: _emailController,
                    passwordController: _passwordController,
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await Auth().createUserWithEmailAndPassword(
                          _emailController.text,
                          _passwordController.text,
                        );
                        newRoute(context, const LoginPage());
                      } catch (e) {
                        print('Sign-up Error: $e');
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF437AE5)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(vertical: 25.0)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size(double.infinity, 55)),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
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
                  GestureDetector(
                    onTap: () {
                      newRoute(context, const LoginPage());
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

class SignUpForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignUpForm({
    required this.emailController,
    required this.passwordController,
  });

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _reEnterPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(widget.emailController, 'Email'),
        const SizedBox(height: 20.0),
        _buildTextField(widget.passwordController, 'Password',
            obscureText: true),
        const SizedBox(height: 20.0),
        _buildTextField(_reEnterPasswordController, 'Re-Enter Password',
            obscureText: true),
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: obscureText,
    );
  }
}
