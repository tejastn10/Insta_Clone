import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class Auth {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static void signUpUser(
      BuildContext context, String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User signedinUser = userCredential.user;
      if (signedinUser != null) {
        _firestore.collection('/users').doc(signedinUser.uid).set({
          'name': name,
          'email': email,
          'profileImageURL': '',
          'bio': '',
        });

        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  static void login(String email, String password) async {
    try {
      _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print(e);
    }
  }

  static void logout() {
    _auth.signOut();
  }
}
