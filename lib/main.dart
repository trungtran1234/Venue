import 'package:app/pages/map.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database/firebase_options.dart';
import 'pages/login.dart';
import 'package:app/services/preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  await Firebase.initializeApp();
  
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
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        colorScheme: const ColorScheme.highContrastDark(),
        useMaterial3: true,
      ),
      home: const AuthStateChecker(),
      routes: {
        '/map': (context) => const MapPage(),
      }
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final User? user = snapshot.data;
        if (user != null) {
          return const MapPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
