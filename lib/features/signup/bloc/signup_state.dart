import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:state_management/features/vo/confirm_password_vo.dart';
import 'package:state_management/features/vo/email_vo.dart';
import 'package:state_management/features/vo/local_user_vo.dart';
import 'package:state_management/features/vo/password_vo.dart';

class SignUpState extends Equatable {
  const SignUpState(
      {this.status = FormzStatus.pure,
      this.localUserVO = LocalUserVO.empty,
      this.emailVO = const EmailVO.pure(),
      this.passwordVO = const PasswordVO.pure(),
      this.confirmPasswordVO = const ConfirmPasswordVO.pure()});

  final LocalUserVO localUserVO;
  final EmailVO emailVO;
  final PasswordVO passwordVO;
  final ConfirmPasswordVO confirmPasswordVO;
  final FormzStatus status;

  SignUpState copyWith({
    FormzStatus status,
    LocalUserVO localUserVO,
    EmailVO emailVO,
    PasswordVO passwordVO,
    ConfirmPasswordVO confirmPasswordVO,
  }) {
    return SignUpState(
        status: status ?? this.status,
        localUserVO: localUserVO ?? this.localUserVO,
        emailVO: emailVO ?? this.emailVO,
        passwordVO: passwordVO ?? this.passwordVO,
        confirmPasswordVO: confirmPasswordVO ?? this.confirmPasswordVO);
  }

  @override
  List<Object> get props =>
      [status, localUserVO, emailVO, passwordVO, confirmPasswordVO];
}
