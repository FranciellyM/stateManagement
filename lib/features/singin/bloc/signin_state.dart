import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:state_management/features/vo/email_vo.dart';
import 'package:state_management/features/vo/local_user_vo.dart';
import 'package:state_management/features/vo/password_vo.dart';

class SignInState extends Equatable {
  const SignInState(
      {this.status = FormzStatus.pure,
      this.localUserVO = LocalUserVO.empty,
      this.emailVO = const EmailVO.pure(),
      this.passwordVO = const PasswordVO.pure()});

  final LocalUserVO localUserVO;
  final EmailVO emailVO;
  final PasswordVO passwordVO;
  final FormzStatus status;

  SignInState copyWith({
    FormzStatus status,
    LocalUserVO localUserVO,
    EmailVO emailVO,
    PasswordVO passwordVO,
  }) {
    return SignInState(
      status: status ?? this.status,
      localUserVO: localUserVO ?? this.localUserVO,
      emailVO: emailVO ?? this.emailVO,
      passwordVO: passwordVO ?? this.passwordVO,
    );
  }

  @override
  List<Object> get props => [status, localUserVO, emailVO, passwordVO];
}
