import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpFailure implements Exception {}

class LogInWithCredentialsFailure implements Exception {}

class LogInWithGoogleFailure implements Exception {}

class LogOutFailure implements Exception {}

class AuthenticationRepository {

  static AuthenticationRepository get instance {
    return AuthenticationRepository._();
  }

  AuthenticationRepository._()
      : _firebaseAuth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn.standard();

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
    } on Exception {
      throw LogInWithGoogleFailure();
    }
  }

  Future<void> signInWithCredentials(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw LogInWithCredentialsFailure();
    }
  }

  Future<void> signUp(String email, String password) async {
   try {
     await _firebaseAuth.createUserWithEmailAndPassword(
       email: email,
       password: password,
     );
   } on Exception {
     throw SignUpFailure();
   }
  }

  Future<void> signOut() async {
   try {
     Future.wait([
       _firebaseAuth.signOut(),
       _googleSignIn.signOut(),
     ]);
   } on Exception {
     throw LogOutFailure();
   }
  }

  bool get isSignedIn => _firebaseAuth.currentUser != null;

  User get currentUser => _firebaseAuth.currentUser;
}
