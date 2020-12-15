import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_management/domain/usercase/authentication_use_cases.dart';
import 'package:state_management/features/singin/bloc/signin_bloc.dart';
import 'package:state_management/features/singin/signin_form.dart';

class SignInScreen extends StatelessWidget {
  static Route route(AuthenticationUseCases authenticationUseCases) {
    return MaterialPageRoute<void>(
        builder: (_) =>
            SignInScreen(authenticationUseCases: authenticationUseCases));
  }

  SignInScreen({Key key, @required this.authenticationUseCases});

  final AuthenticationUseCases authenticationUseCases;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocProvider(
          create: (_) =>
              SignInBloc(authenticationUseCases: authenticationUseCases),
          child: SignInForm(authenticationUseCases: authenticationUseCases),
        ),
      );
}
