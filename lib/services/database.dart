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

  static void followUser({String currentUserId, String userId}) {
    followingRef
        .doc(currentUserId)
        .collection("userFollowing")
        .doc(userId)
        .set({});

    followersRef
        .doc(userId)
        .collection("userFollowers")
        .doc(currentUserId)
        .set({});
  }

  static void unfollowUser({String currentUserId, String userId}) {
    followingRef
        .doc(currentUserId)
        .collection("userFollowing")
        .doc(userId)
        .get()
        .then((doc) => {
              if (doc.exists) {doc.reference.delete()}
            });

    followersRef
        .doc(userId)
        .collection("userFollowers")
        .doc(currentUserId)
        .get()
        .then((doc) => {
              if (doc.exists) {doc.reference.delete()}
            });
  }

  static Future<bool> isFollowingUser(
      {String currentUserId, String userId}) async {
    DocumentSnapshot followingDoc = await followersRef
        .doc(userId)
        .collection("userFollowers")
        .doc(currentUserId)
        .get();

    return followingDoc.exists;
  }

  static Future<int> numFollowers(String userId) async {
    QuerySnapshot followerSnapshot =
        await followersRef.doc(userId).collection("userFollowers").get();

    return followerSnapshot.docs.length;
  }

  static Future<int> numFollowing(String userId) async {
    QuerySnapshot followingSnapshot =
        await followingRef.doc(userId).collection("userFollowing").get();

    return followingSnapshot.docs.length;
  }
}
