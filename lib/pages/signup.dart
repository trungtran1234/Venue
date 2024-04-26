import 'package:app/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/auth.dart';
import 'package:app/functions.dart';
import '../connectivity_checker.dart';
import '../reconnection_popup.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);
  @override
  SignUpFormState createState() => SignUpFormState();
}
  

 class SignUpFormState extends State<SignUpForm>{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reEnterPasswordController = TextEditingController();

  late PopupManager popupManager;
  late ConnectivityChecker connectivityChecker;

  @override
  void initState() {
    super.initState();
    popupManager = PopupManager();
    connectivityChecker = ConnectivityChecker(
      onStatusChanged: onConnectivityChanged,
    );
  }

  void onConnectivityChanged(bool isConnected) {
    if (isConnected) {
      popupManager.dismissConnectivityPopup();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        popupManager.showConnectivityPopup(context);
      });
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers and connectivity checker
    emailController.dispose();
    passwordController.dispose();
    reEnterPasswordController.dispose();
    connectivityChecker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTextField(emailController, 'Email'),
        const SizedBox(height: 20.0),
        buildTextField(passwordController, 'Password', obscureText: true),
        const SizedBox(height: 20.0),
        buildTextField(reEnterPasswordController, 'Re-Enter Password',
            obscureText: true),
        _buildSignUpButton(),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () async {
        // Check if any text field is empty
        if (emailController.text.isEmpty ||
            passwordController.text.isEmpty ||
            reEnterPasswordController.text.isEmpty) {
          showErrorBanner(context, 'Please fill in all fields');
          return;
        }

        // Check if passwords match
        if (passwordController.text != reEnterPasswordController.text) {
          showErrorBanner(context, 'Passwords do not match.');
          return;
        }

        // Check if the email already exists
        try {
          final user = await Auth().getUserByEmail(emailController.text);
          if (user != null) {
            showErrorBanner(context, 'This email is already registered.');
            return;
          }
        } catch (e) {
          print('Error checking email: $e');
        }

        // All conditions passed
        try {
          await Auth().createUserWithEmailAndPassword(
            emailController.text,
            passwordController.text,
          );
          newRoute(context, LoginPage());
        } catch (e) {
          print('Sign-up Error: $e');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF437AE5),
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size(double.infinity, 55),
      ),
      child: const Text(
        'Create Account',
        style: TextStyle(
          fontFamily: 'Fredoka',
          fontSize: 15.0,
          color: Colors.white,
        ),
      ),
    );
  }

}


  

class SignUpPage extends StatelessWidget {
   const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildVenueTitle(),
              const SizedBox(height: 20.0),
              const SignUpForm(), // No controllers are passed
              const SizedBox(height: 20.0),
              _buildLoginOption(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVenueTitle() {
    return const Text(
      'Venue',
      style: TextStyle(
        color: Colors.orange,
        fontFamily: 'Fredoka',
        fontSize: 75.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSignUpForm(
    BuildContext context,
    
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          const Text(
            'Create An Account',
            style: TextStyle(
              color: Color(0xFF443636),
              fontFamily: 'Fredoka',
              fontSize: 30.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          SignUpForm(),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }


  Widget _buildLoginOption(BuildContext context) {
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
            'Have an account? ',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
          GestureDetector(
            onTap: () {
              newRoute(context, LoginPage());
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
    );
  }
}
