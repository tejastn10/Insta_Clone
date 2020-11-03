import 'package:Insta_Clone/services/auth.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Instagram",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Billabong',
            fontSize: 35.0,
          ),
        ),
      ),
      body: Center(
        child: FlatButton(
          child: Text(
            "Logout",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.black,
          onPressed: Auth.logout,
        ),
      ),
    );
  }
}
