import 'package:Insta_Clone/screens/auth/login.dart';
import 'package:Insta_Clone/screens/feed.dart';
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
        });

        Navigator.pushReplacementNamed(context, Feed.id);
      }
    } catch (e) {
      print(e);
    }
  }

  static void login(String email, String password) async {
    _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static void logout(BuildContext context) {
    _auth.signOut();
    Navigator.pushReplacementNamed(context, Login.id);
  }
}
