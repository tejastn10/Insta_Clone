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
}
