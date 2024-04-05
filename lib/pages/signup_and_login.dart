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

class Button extends StatefulWidget {
  final Widget newPage;
  final String buttonText;

  const Button({
    Key? key,
    required this.newPage,
    required this.buttonText,
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isPressed = true;
        });
        newRoute(context, widget.newPage);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.blue.withOpacity(0.8);
          }
          return const Color(0xFF437AE5);
        }),
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
        widget.buttonText,
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

class OtherOption extends StatefulWidget {
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
  _OtherOptionState createState() => _OtherOptionState();
}

class _OtherOptionState extends State<OtherOption> {
  Color _secondTextColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _secondTextColor = Colors.blue.withOpacity(0.8);
        });
      },
      onTapUp: (_) {
        setState(() {
          _secondTextColor = Colors.blue;
        });
        newRoute(context, widget.newPage);
      },
      onTapCancel: () {
        setState(() {
          _secondTextColor = Colors.blue;
        });
      },
      child: Container(
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
              '${widget.firstText} ',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
            Text(
              widget.secondText,
              style: TextStyle(
                color: _secondTextColor,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
