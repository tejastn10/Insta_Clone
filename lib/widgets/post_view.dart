import 'package:Insta_Clone/models/post.dart';
import 'package:Insta_Clone/models/user.dart';
import 'package:Insta_Clone/screens/pages/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostView extends StatelessWidget {
  final String currentUserId;
  final Post post;
  final User author;

  PostView({this.author, this.currentUserId, this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Profile(
                currentUserID: currentUserId,
                userId: post.authorId,
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: author.profileImageURL.isEmpty
                      ? AssetImage("assets/images/default_user_image.jpg")
                      : CachedNetworkImageProvider(author.profileImageURL),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  author.name,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                post.imageUrl,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    iconSize: 30.0,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.comment_outlined),
                    iconSize: 30.0,
                    onPressed: () {},
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: Text(
                  "0 likes",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: 12.0,
                      right: 6.0,
                    ),
                    child: Text(
                      author.name,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      post.caption,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 12.0,
              )
            ],
          ),
        )
      ],
    );
  }
}
