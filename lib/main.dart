import 'package:app/pages/map.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database/firebase_options.dart';
import 'pages/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Venue',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Fredoka',
        scaffoldBackgroundColor: const Color(0xFF437AE5),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthStateChecker(),
    );
  }
}

class AuthStateChecker extends StatelessWidget {
  const AuthStateChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          // Check if user is logged in
          if (user != null) {
            // Navigate to the appropriate screen for logged-in users
            return const MapPage();
          } else {
            // Navigate to the login screen for logged-out users
            return LoginPage();
          }
        }
        // Return a loading indicator while waiting for the authentication state
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
