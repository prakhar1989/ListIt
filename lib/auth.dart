import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> signIn() async {
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    debugPrint("Signed in with temporary account. ${userCredential.user}");
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "operation-not-allowed":
        debugPrint("Anonymous auth hasn't been enabled for this project.");
        break;
      default:
        debugPrint("Unknown error.");
    }
  }
}