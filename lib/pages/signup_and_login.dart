import 'package:app/pages/map.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            AppName(),
            SignUpForm(),
            SizedBox(height: 20.0),
            OtherOption(
              firstText: 'Have an account?',
              secondText: 'Login',
              newPage: LoginPage(),
            )
          ],
        ),
      ),
    );
  }
}

class AppName extends StatelessWidget {
  const AppName({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(30.0),
      child: const Column(
        children: [
          Text(
            'Create An Account',
            style: TextStyle(
              color: Color(0xFF443636),
              fontFamily: 'Fredoka',
              fontSize: 30.0,
            ),
          ),
          SizedBox(height: 20.0),
          InputFields(label: 'Email', obscureText: false),
          SizedBox(height: 20.0),
          InputFields(label: 'Username', obscureText: false),
          SizedBox(height: 20.0),
          InputFields(label: 'Password', obscureText: true),
          SizedBox(height: 20.0),
          InputFields(label: 'Re-Enter Password', obscureText: true),
          SizedBox(height: 20.0),
          Button(newPage: LoginPage(), buttonText: 'Create Account'),
        ],
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppName(),
            LoginForm(),
            SizedBox(height: 20.0),
            OtherOption(
              firstText: 'Need an account?',
              secondText: 'Sign Up',
              newPage: SignUpPage(),
            )
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        children: [
          Text(
            'Sign Into Your Account',
            style: TextStyle(
              color: Color(0xFF443636),
              fontFamily: 'Fredoka',
              fontSize: 30.0,
            ),
          ),
          SizedBox(height: 20.0),
          InputFields(label: 'Email', obscureText: false),
          SizedBox(height: 20.0),
          InputFields(label: 'Password', obscureText: true),
          SizedBox(height: 20.0),
          Button(newPage: MapPage(), buttonText: 'Login'),
          SizedBox(height: 10.0),
          ForgotPasswordOption(),
        ],
      ),
    );
  }
}

class ForgotPasswordOption extends StatelessWidget {
  const ForgotPasswordOption({super.key});

  @override
  Widget build(BuildContext context) {
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
}

class Button extends StatelessWidget {
  final Widget newPage;
  final String buttonText;

  const Button({
    Key? key,
    required this.newPage,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        newRoute(context, newPage);
      },
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0xFF437AE5)),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 25.0),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(double.infinity, 55),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          fontFamily: 'Fredoka',
          fontSize: 15.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class InputFields extends StatelessWidget {
  final String label;
  final bool obscureText;

  const InputFields({
    Key? key,
    required this.label,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: label,
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

class OtherOption extends StatelessWidget {
  final String firstText;
  final String secondText;
  final Widget newPage;

  const OtherOption({
    Key? key,
    required this.firstText,
    required this.secondText,
    required this.newPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Text(
            '$firstText ',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
          GestureDetector(
            onTap: () {
              newRoute(context, newPage);
            },
            child: Text(
              secondText,
              style: const TextStyle(
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
