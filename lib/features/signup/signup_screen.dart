import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_management/domain/usercase/authentication_use_cases.dart';
import 'package:state_management/features/signup/bloc/signup_bloc.dart';
import 'package:state_management/features/signup/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  static Route route(AuthenticationUseCases authenticationUseCases) {
    return MaterialPageRoute<void>(
        builder: (_) =>
            SignUpScreen(authenticationUseCases: authenticationUseCases));
  }

  SignUpScreen({Key key, @required this.authenticationUseCases});

  final AuthenticationUseCases authenticationUseCases;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocProvider(
          create: (_) =>
              SignUpBloc(authenticationUseCases: authenticationUseCases),
          child: SignUpForm(),
        ),
      );
}
