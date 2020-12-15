import 'package:formz/formz.dart';

enum PasswordValidationError { empty }

class PasswordVO extends FormzInput<String, PasswordValidationError> {
  const PasswordVO.pure() : super.pure('');
  const PasswordVO.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError validator(String value) {
    return value?.isNotEmpty == true ? null : PasswordValidationError.empty;
  }
}