import 'package:Insta_Clone/models/post.dart';
import 'package:Insta_Clone/models/user.dart';
import 'package:Insta_Clone/models/user_data.dart';
import 'package:Insta_Clone/screens/extras/edit_profile.dart';
import 'package:Insta_Clone/services/database.dart';
import 'package:Insta_Clone/utilities/constants.dart';
import 'package:Insta_Clone/widgets/post_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final String userId, currentUserID;

  Profile({this.userId, this.currentUserID});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isFollowing = false;
  int _followerCount = 0;
  int _followingCount = 0;
  List<Post> _posts = [];
  int _displayPosts = 0;
  User _profileUser;

  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowing();
    _setupFollowers();
    _setupPosts();
    _setupProfileUser();
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await Database.isFollowingUser(
      currentUserId: widget.currentUserID,
      userId: widget.userId,
    );

    setState(() {
      _isFollowing = isFollowingUser;
    });
  }

  _setupFollowers() async {
    int userFollowercount = await Database.numFollowers(widget.userId);
    setState(() {
      _followerCount = userFollowercount;
    });
  }

  _setupFollowing() async {
    int userFollowingCount = await Database.numFollowing(widget.userId);
    setState(() {
      _followingCount = userFollowingCount;
    });
  }

  _setupPosts() async {
    List<Post> posts = await Database.getUserPosts(widget.userId);
    setState(() {
      _posts = posts;
    });
  }

  _setupProfileUser() async {
    User profileUser = await Database.getUserWithId(widget.userId);
    setState(() {
      _profileUser = profileUser;
    });
  }

  _followOrUnfollow() {
    if (_isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  _unfollowUser() {
    Database.unfollowUser(
      currentUserId: widget.currentUserID,
      userId: widget.userId,
    );
    setState(() {
      _isFollowing = false;
      _followerCount--;
    });
  }

  _followUser() {
    Database.followUser(
      currentUserId: widget.currentUserID,
      userId: widget.userId,
    );
    setState(() {
      _isFollowing = true;
      _followerCount++;
    });
  }

  _displayButton(User user) {
    return user.id == Provider.of<UserData>(context).currentUserId
        ? Container(
            width: 200.0,
            child: FlatButton(
              color: Colors.blue,
              child: Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfile(
                    user: user,
                  ),
                ),
              ),
            ),
          )
        : Container(
            width: 200.0,
            child: FlatButton(
              color: _isFollowing ? Colors.grey[200] : Colors.blue,
              textColor: _isFollowing ? Colors.black : Colors.white,
              child: Text(
                _isFollowing ? "Unfollow" : "Follow",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              onPressed: _followOrUnfollow,
            ),
          );
  }

  _buildProfileInfo(User user) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.grey,
                backgroundImage: user.profileImageURL.isEmpty
                    ? AssetImage('assets/images/default_user_image.jpg')
                    : CachedNetworkImageProvider(user.profileImageURL),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              _posts.length.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "posts",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              _followingCount.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "following",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              _followerCount.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "followers",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        )
                      ],
                    ),
                    _displayButton(user),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                height: 80.0,
                child: Text(
                  user.bio,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Divider()
            ],
          ),
        )
      ],
    );
  }

  _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.grid_on),
          onPressed: () => setState(() {
            _displayPosts = 0;
          }),
          iconSize: 30.0,
          color: _displayPosts == 0
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
        ),
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () => setState(() {
            _displayPosts = 1;
          }),
          iconSize: 30.0,
          color: _displayPosts == 1
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
        ),
      ],
    );
  }

  _buildTilePost(Post post) {
    return GridTile(
      child: Image(
        image: CachedNetworkImageProvider(post.imageUrl),
        fit: BoxFit.cover,
      ),
    );
  }

  _buildDisplayPosts() {
    if (_displayPosts == 0) {
      // * Grid
      List<GridTile> tiles = [];
      _posts.forEach((post) {
        tiles.add(_buildTilePost(post));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      );
    } else {
      // *Column
      List<PostView> postViews = [];
      _posts.forEach((post) {
        postViews.add(PostView(
          currentUserId: widget.currentUserID,
          post: post,
          author: _profileUser,
        ));
      });
      return Column(
        children: postViews,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: FutureBuilder(
        future: usersRef.doc(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          User user = User.fromDoc(snapshot.data);

          return ListView(
            children: [
              _buildProfileInfo(user),
              _buildToggleButtons(),
              Divider(),
              _buildDisplayPosts(),
            ],
          );
        },
      ),
    );
  }
}
