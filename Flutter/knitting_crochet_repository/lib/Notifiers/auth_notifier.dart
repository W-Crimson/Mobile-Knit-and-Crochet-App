import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthNotifier with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> signUpWithEmail(String email, String password) async {
  _setLoading(true);

  try {
    // The key difference: use createUserWithEmailAndPassword
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Note: If you need to save user data (like name, profile image)
    // to Firestore, you would do it here using the new user's UID:
    // await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).set({
    //   'email': email,
    //   'createdAt': FieldValue.serverTimestamp(),
    // });

  } on FirebaseAuthException catch (e) {
    String message = 'An error occurred during sign-up.';
    if (e.code == 'email-already-in-use') {
      message = 'This email is already registered.';
    } else if (e.code == 'weak-password') {
      message = 'The password is too weak.';
    }
    _setLoading(false);
    throw message;
  } catch (e) {
    _setLoading(false);
    throw 'An unexpected error occurred.';
  }

  _setLoading(false);
}

  Future<void> signInWithEmail(String email, String password) async {
    _setLoading(true);

    try {
      // 1. Call the Firebase sign-in method
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Success is handled automatically by FirebaseAuth's StreamBuilder
      // which should be listening for User changes in your main app file.

    } on FirebaseAuthException catch (e) {
      // 2. Handle specific Firebase errors (e.g., wrong password)
      String message = 'An error occurred. Please check your credentials.';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      }
      _setLoading(false);
      // 3. Throw the error so the UI can catch and display it
      throw message; 
    } catch (e) {
      // Handle generic errors
      _setLoading(false);
      throw 'An unexpected error occurred.';
    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}