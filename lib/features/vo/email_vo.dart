import 'package:formz/formz.dart';

enum EmailValidationError { invalid }

class EmailVO extends FormzInput<String, EmailValidationError> {
  const EmailVO.pure() : super.pure('');
  const EmailVO.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailValidationError validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}