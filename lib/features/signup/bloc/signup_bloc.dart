import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import 'package:state_management/domain/usercase/authentication_use_cases.dart';
import 'package:state_management/features/signup/bloc/signup_event.dart';
import 'package:state_management/features/signup/bloc/signup_state.dart';
import 'package:state_management/features/vo/confirm_password_vo.dart';
import 'package:state_management/features/vo/email_vo.dart';
import 'package:state_management/features/vo/local_user_vo.dart';
import 'package:state_management/features/vo/password_vo.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({@required AuthenticationUseCases authenticationUseCases})
      : assert(authenticationUseCases != null),
        _authenticationUseCases = authenticationUseCases,
        super(const SignUpState());

  final AuthenticationUseCases _authenticationUseCases;

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is EmailChanged) {
      yield _mapEmailChangedToState(state, event.email);
    } else if (event is PasswordChanged) {
      yield _mapPasswordChangedToState(state, event.password);
    } else if(event is ConfirmPasswordChanged) {
      yield _mapConfirmPasswordChangedToState(state, event.confirmPassword);
    }else if (event is Submitted) {
      yield* _mapFormSubmittedToState(state);
    }
  }

  SignUpState _mapEmailChangedToState(SignUpState state, String email) {
    final emailVO = EmailVO.dirty(email);
    return state.copyWith(
        emailVO: emailVO, status: Formz.validate([state.passwordVO, emailVO]));
  }

  SignUpState _mapPasswordChangedToState(SignUpState state, String password) {
    final passwordVO = PasswordVO.dirty(password);
    return state.copyWith(
        passwordVO: passwordVO,
        status: Formz.validate([state.emailVO, passwordVO]));
  }

  SignUpState _mapConfirmPasswordChangedToState(SignUpState state, String confirmPassword) {
    final confirmedPasswordVO = ConfirmPasswordVO.dirty(
      password: state.passwordVO.value,
      value: confirmPassword,
    );
    return state.copyWith(
        confirmPasswordVO: confirmedPasswordVO,
        status: Formz.validate([state.emailVO, state.passwordVO, confirmedPasswordVO]));
  }

  Stream<SignUpState> _mapFormSubmittedToState(SignUpState state) async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      LocalUserVO localUserVO = LocalUserVO.fromUser(
          await _authenticationUseCases.signUp(
              email: state.emailVO.value, password: state.passwordVO.value));
      yield state.copyWith(
          status: FormzStatus.submissionSuccess, localUserVO: localUserVO);
    } catch (_) {
      yield state.copyWith(status: FormzStatus.submissionFailure);
    }
  }
}
