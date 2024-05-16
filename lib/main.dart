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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
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
          return GradientScaffold(
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final User? user = snapshot.data;
        if (user != null) {
          return const MapPage();  // Make sure MapPage uses GradientScaffold if needed
        } else {
          return LoginPage();
        }
      },
    );
  }
}

class GradientScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final Widget? bottomNavigationBar;

  const GradientScaffold({
    Key? key, 
    required this.body, 
    this.appBar, 
    this.bottomNavigationBar
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF133068), Color(0xFF0B1425)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(child: body),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
