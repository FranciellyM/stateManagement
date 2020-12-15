import 'package:firebase_auth/firebase_auth.dart';

class LocalUser {
  LocalUser._(this.displayName, this.email, this.photoUrl, this.uid);

  final String displayName;
  final String email;
  final String photoUrl;
  final String uid;

  factory LocalUser.fromFirebaseUser(User user) =>
      LocalUser._(user.displayName, user.email, user.photoURL, user.uid);
}
