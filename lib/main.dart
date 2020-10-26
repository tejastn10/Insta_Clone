import 'package:Insta_Clone/screens/auth/login.dart';
import 'package:Insta_Clone/screens/auth/signup.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      debugShowCheckedModeBanner: false,
      home: Login(),
      routes: {
        Login.id: (context) => Login(),
        SignUp.id: (context) => SignUp(),
      },
    );
  }
}
