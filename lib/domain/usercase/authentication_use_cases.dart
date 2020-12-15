import 'package:state_management/domain/entities/local_user.dart';
import 'package:state_management/domain/repository/authentication_repository.dart';

class AuthenticationUseCases {
  final AuthenticationRepository _repository;

  static AuthenticationUseCases get instance {
    return AuthenticationUseCases._();
  }

  AuthenticationUseCases._() : _repository = AuthenticationRepository.instance;

  Future<LocalUser> signInWithGoogle() async {
    await _repository.signInWithGoogle();
    return currentUser;
  }

  Future<LocalUser> signInWithCredentials(String email, String password) async {
    await _repository.signInWithCredentials(email, password);
    return LocalUser.fromFirebaseUser(_repository.currentUser);
  }

  Future<void> signOut() async {
    await _repository.signOut();
  }

  Future<LocalUser> signUp({String email, String password}) async {
    await _repository.signUp(email, password);
    await _repository.signInWithCredentials(email, password);
    return currentUser;
  }

  LocalUser get currentUser =>
      LocalUser.fromFirebaseUser(_repository.currentUser);

  bool get hasSession => _repository.isSignedIn;
}
