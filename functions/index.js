import { firestore as functions } from "firebase-functions";
import { initializeApp, firestore as admin } from "firebase-admin";

initializeApp();

exports.onFollowUser = functions
  .document("/followers/{userId}/userFollowers/{followerId}")
  .onCreate(async (_, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    const followedUserPostRef = admin()
      .collection("posts")
      .doc(userId)
      .collection("userPosts");
    const userFeedRef = admin()
      .collection("feeds")
      .doc(followerId)
      .collection("userFeed");

    const followedUserPostsSnapshot = await followedUserPostRef.get();
    followedUserPostsSnapshot.forEach((doc) => {
      if (doc.exists) {
        userFeedRef.doc(doc.id).set(doc.data());
      }
    });
  });

exports.onUnfollowUser = functions
  .document("/followers/{userId}/userFollowers/{followerId}")
  .onDelete(async (_, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    const userFeedRef = admin()
      .collection("feeds")
      .doc(followerId)
      .collection("userFeed")
      .where("authorId", "==", userId);

    const userPostsSnapshot = await userFeedRef.get();
    userPostsSnapshot.forEach((doc) => {
      if (doc.exists) {
        doc.ref.delete();
      }
    });
  });

exports.onUploadPost = functions
  .document("/posts/{userId}/userPosts/{postId}")
  .onCreate(async (snapshot, context) => {
    const userId = context.params.userId;
    const postId = context.params.postId;

    const userFollowersRef = admin()
      .collection("followers")
      .doc(userId)
      .collection("userFollowers");

    const userFollowersSnapshot = await userFollowersRef.get();
    userFollowersSnapshot.forEach((doc) => {
      admin()
        .collection("feeds")
        .doc(doc.id)
        .collection("userFeed")
        .doc(postId)
        .set(snapshot.data());
    });
  });

// TODO: Deploy Functions by enabling Billing
