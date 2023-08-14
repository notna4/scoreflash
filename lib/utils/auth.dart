import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  static SnackBar customSnackBar(String message) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  static Future<User?> loginInWithEmailAndPassword(
      {Key? key,
      required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("User not found.");
        ScaffoldMessenger.of(context).showSnackBar(
            Auth.customSnackBar("User not found. Please create an account."));
      } else if (e.code == "wrong-password") {
        print("Wrong password.");
        ScaffoldMessenger.of(context)
            .showSnackBar(Auth.customSnackBar("Wrong password."));
      }
    }
    return user;
  }

  static Future<User?> registerWithMailAndPassword({
    Key? key,
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = await FirebaseAuth.instance;

    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;

      await user!.updateDisplayName(name);
      user.reload();

      user = auth.currentUser;
    } on FirebaseException catch (e) {
      if (e.code == "weak-password") {
        print("Weak password.");
        ScaffoldMessenger.of(context)
            .showSnackBar(Auth.customSnackBar("Weak password."));
      } else if (e.code == "email-already-in-use") {
        print("Email already in use.");
        ScaffoldMessenger.of(context)
            .showSnackBar(Auth.customSnackBar("Email already in use."));
      }
    }
    return user;
  }
}
