import 'package:Insta_Clone/models/activity.dart';
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
    postsRef.doc(post.authorId).collection("userPosts").add({
      "imageUrl": post.imageUrl,
      "caption": post.caption,
      "likeCount": post.likeCount,
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

  static Future<List<Post>> getFeedPosts(String userId) async {
    QuerySnapshot feedSnapshot = await feedsRef
        .doc(userId)
        .collection("userFeed")
        .orderBy("timestamp", descending: true)
        .get();

    List<Post> posts =
        feedSnapshot.docs.map((doc) => Post.fromDoc(doc)).toList();

    return posts;
  }

  static Future<List<Post>> getUserPosts(String userId) async {
    QuerySnapshot userPostSnapshot = await postsRef
        .doc(userId)
        .collection("userPosts")
        .orderBy("timestamp", descending: true)
        .get();

    List<Post> posts =
        userPostSnapshot.docs.map((doc) => Post.fromDoc(doc)).toList();

    return posts;
  }

  static Future<User> getUserWithId(String userId) async {
    DocumentSnapshot userDocSnapshot = await usersRef.doc(userId).get();

    if (userDocSnapshot.exists) {
      return User.fromDoc(userDocSnapshot);
    }

    return User();
  }

  static void likePost({String currentUserId, Post post}) {
    DocumentReference postRef =
        postsRef.doc(post.authorId).collection("userPosts").doc(post.id);

    postRef.get().then((doc) {
      int likeCount = doc.data()["likeCount"];
      postRef.update({"likeCount": likeCount + 1});
      likesRef.doc(post.id).collection("postLikes").doc(currentUserId).set({});
    });

    addActivityitem(currentUserId: currentUserId, post: post, comment: null);
  }

  static void unlikePost({String currentUserId, Post post}) {
    DocumentReference postRef =
        postsRef.doc(post.authorId).collection("userPosts").doc(post.id);

    postRef.get().then((doc) {
      int likeCount = doc.data()["likeCount"];
      postRef.update({"likeCount": likeCount - 1});
      likesRef
          .doc(post.id)
          .collection("postLikes")
          .doc(currentUserId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    });
  }

  static Future<bool> didLikePost({String currentUserId, Post post}) async {
    DocumentSnapshot userDoc = await likesRef
        .doc(post.id)
        .collection("postLikes")
        .doc(currentUserId)
        .get();

    return userDoc.exists;
  }

  static void commentOnPost({String currentUserID, Post post, String comment}) {
    commentsRef.doc(post.id).collection("postComments").add({
      "content": comment,
      "authorId": currentUserID,
      "timestamp": Timestamp.fromDate(DateTime.now()),
    });
    addActivityitem(currentUserId: currentUserID, post: post, comment: comment);
  }

  static void addActivityitem(
      {String currentUserId, Post post, String comment}) {
    if (currentUserId != post.authorId) {
      activitiesRef.doc(post.authorId).collection("useractivities").add({
        "fromUserId": currentUserId,
        "postId": post.id,
        "postImageUrl": post.imageUrl,
        "comment": comment,
        "timestamp": Timestamp.fromDate(DateTime.now()),
      });
    }
  }

  static Future<List<Activity>> getActivities(String userId) async {
    QuerySnapshot userActivitiesSnapshot = await activitiesRef
        .doc(userId)
        .collection("userActivities")
        .orderBy("timestamp", descending: true)
        .get();
    List<Activity> activity = userActivitiesSnapshot.docs
        .map((doc) => Activity.fromDoc(doc))
        .toList();

    return activity;
  }

  static Future<Post> getUserPost(String userId, String postId) async {
    DocumentSnapshot postDocSnapshot =
        await postsRef.doc(userId).collection("userPosts").doc(postId).get();
    return Post.fromDoc(postDocSnapshot);
  }
}
