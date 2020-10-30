import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String profileImageURL;
  final String email;
  final String bio;

  User({
    this.id,
    this.name,
    this.profileImageURL,
    this.email,
    this.bio,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      name: doc["name"],
      profileImageURL: doc["profileImageURL"],
      email: doc["email"],
      bio: doc["bio"] ?? "",
    );
  }
}
