import 'package:Insta_Clone/models/comment.dart';
import 'package:Insta_Clone/models/user.dart';
import 'package:Insta_Clone/models/user_data.dart';
import 'package:Insta_Clone/services/database.dart';
import 'package:Insta_Clone/utilities/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Comments extends StatefulWidget {
  final String postId;
  final int likeCount;

  Comments({this.postId, this.likeCount});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;

  _buildComment(Comment comment) {
    return FutureBuilder(
      future: Database.getUserWithId(comment.authorId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        User author = snapshot.data;
        return ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.grey,
            backgroundImage: author.profileImageURL.isEmpty
                ? AssetImage("assets/images/default_user_image.jpg")
                : CachedNetworkImageProvider(author.profileImageURL),
          ),
          title: Text(author.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.content,
              ),
              SizedBox(
                height: 6.0,
              ),
              Text(
                DateFormat.yMd().add_jm().format(comment.timestamp.toDate()),
              ),
            ],
          ),
        );
      },
    );
  }

  _buildCommentTF() {
    final currentUserId = Provider.of<UserData>(context).currentUserId;
    return IconTheme(
      data: IconThemeData(
        color: _isCommenting
            ? Theme.of(context).accentColor
            : Theme.of(context).disabledColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: TextField(
              controller: _commentController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (comment) => {
                setState(() {
                  _isCommenting = comment.length > 0;
                })
              },
              decoration: InputDecoration.collapsed(hintText: "Comment"),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 4.0,
            ),
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                if (_isCommenting) {
                  Database.commentOnPost(
                    currentUserID: currentUserId,
                    postId: widget.postId,
                    comment: _commentController.text,
                  );
                  _commentController.clear();
                  setState(() {
                    _isCommenting = false;
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Comments",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "${widget.likeCount} likes",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          StreamBuilder(
            stream: commentsRef
                .doc(widget.postId)
                .collection("postComments")
                .orderBy("timestamp", descending: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    Comment comment =
                        Comment.fromDoc(snapshot.data.documents[index]);
                    return _buildComment(comment);
                  },
                ),
              );
            },
          ),
          Divider(
            height: 1.0,
          ),
          _buildCommentTF(),
        ],
      ),
    );
  }
}
