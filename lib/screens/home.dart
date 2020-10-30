import 'package:Insta_Clone/screens/pages/activity.dart';
import 'package:Insta_Clone/screens/pages/create_post.dart';
import 'package:Insta_Clone/screens/pages/feed.dart';
import 'package:Insta_Clone/screens/pages/profile.dart';
import 'package:Insta_Clone/screens/pages/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static final String id = "home";

  final String userId;

  Home({this.userId});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTab = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

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
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Feed(),
          Search(),
          CreatePost(),
          Activity(),
          Profile(
            userId: widget.userId,
          ),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentTab,
        onTap: (int index) {
          setState(() {
            _currentTab = index;
          });
          _pageController.animateToPage(index,
              duration: Duration(microseconds: 200), curve: Curves.easeIn);
        },
        activeColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 32.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
              size: 32.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              size: 32.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 32.0,
            ),
          ),
        ],
      ),
    );
  }
}
