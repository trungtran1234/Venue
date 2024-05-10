import 'package:app/services/secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      SecureStorage().writeSecureData('email', email);
      SecureStorage().writeSecureData('password', password);
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
      SecureStorage().writeSecureData('email', email);
      SecureStorage().writeSecureData('password', password);
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signInWithBiometrics(BuildContext context) async {
    bool canCheckBiometrics = await LocalAuthentication().canCheckBiometrics;

    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics =
          await LocalAuthentication().getAvailableBiometrics();

      if (availableBiometrics.contains(BiometricType.fingerprint) ||
          availableBiometrics.contains(BiometricType.face)) {
        try {
          bool isAuthenticated = await LocalAuthentication().authenticate(
              localizedReason: 'Authenticate to access the User Authenication');
          if (isAuthenticated) {
            final UserCredential userCredential =
                await _auth.signInWithEmailAndPassword(
              email: SecureStorage().readSecureData('email').toString(),
              password: SecureStorage().readSecureData('password').toString(),
            );
            return userCredential.user;
          }
        } catch (e) {
          rethrow;
        }
      }
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
