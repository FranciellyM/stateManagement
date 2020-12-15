import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:state_management/domain/usercase/authentication_use_cases.dart';
import 'package:state_management/features/app/bloc/session_bloc.dart';
import 'package:state_management/features/app/bloc/session_event.dart';
import 'package:state_management/features/signup/signup_screen.dart';
import 'package:state_management/features/singin/bloc/signin_event.dart';
import 'package:state_management/features/singin/bloc/signin_state.dart';

import 'bloc/signin_bloc.dart';

class SignInForm extends StatefulWidget {
  SignInForm({Key key, @required AuthenticationUseCases authenticationUseCases})
      : assert(authenticationUseCases != null),
        _authenticationUseCases = authenticationUseCases,
        super(key: key);

  final AuthenticationUseCases _authenticationUseCases;

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  @override
  Widget build(BuildContext context) => BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Login Failure'), Icon(Icons.error)],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          } else if (state.status.isSubmissionSuccess) {
            context
                .read<SessionBloc>()
                .add(SessionUserChanged(localUserVO: state.localUserVO));
          }
        },
        child: Container(
          alignment: Alignment.center,
          child: Stack(
            children: [_formArea(), _iconArea()],
          ),
        ),
      );

  _formArea() => Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Card(
          elevation: 2.0,
          color: Colors.white,
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _EmailInput(),
                _PasswordInput(),
                _SignInButton(),
                _GoogleSignInButton(),
                _SignUpButton(
                    authenticationUseCases: widget._authenticationUseCases)
              ],
            ),
          ),
        ),
      );

  _iconArea() => Container(
        height: MediaQuery.of(context).size.height * 0.1,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.all_inclusive,
          color: Colors.white,
          size: 48,
        ),
      );
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<SignInBloc, SignInState>(
        buildWhen: (previous, current) => previous.emailVO != current.emailVO,
        builder: (context, state) {
          return TextField(
            key: const Key('signInForm_emailInput_textField'),
            onChanged: (username) =>
                context.read<SignInBloc>().add(EmailChanged(email: username)),
            decoration: InputDecoration(
              labelText: 'E-mail',
              errorText: state.emailVO.invalid ? 'Invalid e-mail' : null,
            ),
          );
        },
      );
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<SignInBloc, SignInState>(
        buildWhen: (previous, current) =>
            previous.passwordVO != current.passwordVO,
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.only(top: 16.0),
            child: TextField(
              key: const Key('signInForm_passwordInput_textField'),
              onChanged: (password) => context
                  .read<SignInBloc>()
                  .add(PasswordChanged(password: password)),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: state.passwordVO.invalid ? 'Invalid password' : null,
              ),
            ),
          );
        },
      );
}

class _SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(top: 16.0),
          child: state.status.isSubmissionInProgress
              ? Container(
                  width: 30,
                  height: 30,
                  child: const CircularProgressIndicator())
              : ButtonTheme(
                  minWidth: 200.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: theme.primaryColorDark)),
                  buttonColor: theme.primaryColorDark,
                  disabledColor: theme.primaryColor,
                  child: RaisedButton(
                    key: const Key('signInForm_continue_raisedButton'),
                    child: const Text('Login',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    onPressed: state.status.isValidated
                        ? () {
                            context
                                .read<SignInBloc>()
                                .add(const SignInWithCredentials());
                          }
                        : null,
                  ),
                ),
        );
      },
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: ButtonTheme(
        minWidth: 200.0,
        child: RaisedButton.icon(
          key: const Key('signInForm__googleLogin_raisedButton'),
          label: const Text(
            'Sign in with Google',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
          color: theme.errorColor,
          onPressed: () => context.read<SignInBloc>().add(SignInWithGoogle()),
        ),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  _SignUpButton({@required AuthenticationUseCases authenticationUseCases})
      : assert(authenticationUseCases != null),
        _authenticationUseCases = authenticationUseCases;

  final AuthenticationUseCases _authenticationUseCases;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: FlatButton(
        key: const Key('loginForm_createAccount_flatButton'),
        child: Text(
          'Create Account',
          style: TextStyle(color: theme.primaryColorDark),
        ),
        onPressed: () => Navigator.of(context)
            .push<void>(SignUpScreen.route(_authenticationUseCases)),
      ),
    );
  }
}
