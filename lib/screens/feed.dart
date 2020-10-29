import 'package:Insta_Clone/services/auth.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  static final String id = "feed";

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child:
            FlatButton(onPressed: () => Auth.logout(), child: Text("Logout")),
      ),
    );
  }
}
