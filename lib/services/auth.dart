import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        var userData = {
          'uid': userCredential.user!.uid,
          'email': email,
          'username': '',
          'firstName': '',
          'lastName': '',
          'friends': 0,
          'posts': 0,
          'bio': ''
          // 'profilePicturePath': User.defaultProfilePicturePath,
        };
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userData);
      }
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

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
      rethrow;
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final List<String> methods =
          await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      rethrow;
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
      rethrow;
    }
  }
}
