import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final List<String> methods =
          await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      throw e;
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      final List<String> methods =
          await _auth.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        // User with the email exists, fetch and return the user
        return await _auth
            .signInWithEmailAndPassword(
              email: email,
              password: '', // Password is not needed
            )
            .then((userCredential) => userCredential.user);
      }
      return null; // User with the email does not exist
    } catch (e) {
      throw e;
    }
  }
}
