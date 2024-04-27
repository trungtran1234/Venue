import 'package:flutter/material.dart';
import 'package:app/pages/map.dart'; 
import 'package:cloud_functions/cloud_functions.dart';

class TwoFactorAuthPage extends StatefulWidget {
  const TwoFactorAuthPage({Key? key}) : super(key: key);

  @override
  _TwoFactorAuthPageState createState() => _TwoFactorAuthPageState();
}

class _TwoFactorAuthPageState extends State<TwoFactorAuthPage> {
  final TextEditingController _twoFactorAuthController = TextEditingController();

  @override
  void dispose() {
    _twoFactorAuthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2-Step Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Enter the code sent to your email'),
            TextField(
              controller: _twoFactorAuthController,
              decoration: const InputDecoration(
                labelText: '2FA Code',
              ),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _verify2FACode,
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }

  void _verify2FACode() async {
    // Call the Cloud Function to verify the 2FA code
    // Replace 'verify2FACode' with your function's actual name if it's different
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('verify2FACode');
      final results = await callable.call(
        <String, dynamic>{
          'code': _twoFactorAuthController.text,
        },
      );
      // Check the results here to see if the code was correct
      // If correct, navigate to the home screen
      bool isCodeValid = results.data['isValid']; // Assuming the Cloud Function returns this
      if (isCodeValid) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MapPage()),
          (Route<dynamic> route) => false,
        );
      } else {
        // Handle the case where the code is not valid
        // Show an error message or toast to the user
      }
    } on FirebaseFunctionsException catch (e) {
      // Handle error here (e.g., show an error message)
    }
  }
}