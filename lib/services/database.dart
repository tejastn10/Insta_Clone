import 'package:Insta_Clone/models/post.dart';
import 'package:Insta_Clone/models/user.dart';
import 'package:Insta_Clone/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static void updateUser(User user) {
    usersRef.doc(user.id).update({
      "name": user.name,
      "bio": user.bio,
      "profileImageURL": user.profileImageURL,
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) {
    Future<QuerySnapshot> users =
        usersRef.where("name", isGreaterThanOrEqualTo: name).get();

    return users;
  }

  static void createPost(Post post) {
    postsRef.doc(post.authorId).collection("usersPosts").add({
      "imageUrl": post.imageUrl,
      "caption": post.caption,
      "likes": post.likes,
      "authorId": post.authorId,
      "timestamp": post.timestamp,
    });
  }
}
