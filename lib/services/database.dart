import 'package:Insta_Clone/models/user.dart';
import 'package:Insta_Clone/utilities/constants.dart';

class Database {
  static void updateUser(User user) {
    usersRef.doc(user.id).update({
      "name": user.name,
      "bio": user.bio,
      "profileImageURL": user.profileImageURL,
    });
  }
}
