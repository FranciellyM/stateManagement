import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import 'package:state_management/domain/usercase/authentication_use_cases.dart';
import 'package:state_management/features/singin/bloc/signin_event.dart';
import 'package:state_management/features/singin/bloc/signin_state.dart';
import 'package:state_management/features/vo/email_vo.dart';
import 'package:state_management/features/vo/local_user_vo.dart';
import 'package:state_management/features/vo/password_vo.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({@required AuthenticationUseCases authenticationUseCases})
      : assert(authenticationUseCases != null),
        _authenticationUseCases = authenticationUseCases,
        super(const SignInState());

  final AuthenticationUseCases _authenticationUseCases;

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is EmailChanged) {
      yield _mapEmailChangedToState(state, event.email);
    } else if (event is PasswordChanged) {
      yield _mapPasswordChangedToState(state, event.password);
    } else if (event is SignInWithGoogle) {
      yield* _mapSignInWithGoogleToState();
    } else if (event is SignInWithCredentials) {
      yield* _mapSignInWithCredentialsToState(state);
    }
  }

  SignInState _mapEmailChangedToState(SignInState state, String email) {
    final emailVO = EmailVO.dirty(email);
    return state.copyWith(emailVO: emailVO, status: Formz.validate([state.passwordVO, emailVO]));
  }

  SignInState _mapPasswordChangedToState(SignInState state, String password) {
    final passwordVO = PasswordVO.dirty(password);
    return state.copyWith(passwordVO: passwordVO, status: Formz.validate([state.emailVO, passwordVO]));
  }

  Stream<SignInState> _mapSignInWithGoogleToState() async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      LocalUserVO localUserVO = LocalUserVO.fromUser(
          await _authenticationUseCases.signInWithGoogle());
      yield state.copyWith(status: FormzStatus.submissionSuccess, localUserVO: localUserVO);
    } catch (_) {
      yield state.copyWith(status: FormzStatus.submissionFailure);
    }
  }

  Stream<SignInState> _mapSignInWithCredentialsToState(SignInState state) async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      LocalUserVO localUserVO = LocalUserVO.fromUser(
          await _authenticationUseCases.signInWithCredentials(state.emailVO.value, state.passwordVO.value));
      yield state.copyWith(status: FormzStatus.submissionSuccess, localUserVO: localUserVO);
    } catch (_) {
      yield state.copyWith(status: FormzStatus.submissionFailure);
    }
  }
}
