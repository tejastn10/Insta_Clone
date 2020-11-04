import 'package:Insta_Clone/models/user_data.dart';
import 'package:Insta_Clone/screens/auth/login.dart';
import 'package:Insta_Clone/screens/auth/signup.dart';
import 'package:Insta_Clone/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget _getScreenId() {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
          return Home();
        } else {
          return Login();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MaterialApp(
        theme: ThemeData(
          primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
                color: Colors.black,
              ),
        ),
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        home: _getScreenId(),
        routes: {
          Login.id: (context) => Login(),
          SignUp.id: (context) => SignUp(),
          Home.id: (context) => Home(),
        },
      ),
    );
  }
}
