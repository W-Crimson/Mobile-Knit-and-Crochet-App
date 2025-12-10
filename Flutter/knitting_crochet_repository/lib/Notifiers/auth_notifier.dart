import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthNotifier with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // ⭐ SIGN UP METHOD
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      // 1. Create the user in FirebaseAuth
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // 2. Save user record in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

    } on FirebaseAuthException catch (e) {
      _setLoading(false);

      if (e.code == 'email-already-in-use') {
        throw 'This email is already registered.';
      } else if (e.code == 'weak-password') {
        throw 'Password is too weak.';
      } else {
        throw e.message ?? 'An error occurred during sign-up.';
      }
    } catch (e) {
      _setLoading(false);
      throw 'Unexpected error. Please try again.';
    }

    _setLoading(false);
  }

  // ⭐ LOGIN METHOD
  Future<void> signInWithEmail(String email, String password) async {
    _setLoading(true);

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

    } on FirebaseAuthException catch (e) {
      _setLoading(false);

      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided.';
      } else {
        throw e.message ?? 'Authentication error';
      }
    } catch (e) {
      _setLoading(false);
      throw 'Unexpected error. Please try again.';
    }

    _setLoading(false);
  }


  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}