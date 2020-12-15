import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

enum ConfirmPasswordValidationError { empty }

class ConfirmPasswordVO
    extends FormzInput<String, ConfirmPasswordValidationError> {
  const ConfirmPasswordVO.pure({this.password = ''}) : super.pure('');

  const ConfirmPasswordVO.dirty({@required this.password, String value = ''})
      : super.dirty(value);

  final String password;

  @override
  ConfirmPasswordValidationError validator(String value) {
    return password == value ? null : ConfirmPasswordValidationError.empty;
  }
}
