import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_management/features/app/bloc/session_bloc.dart';
import 'package:state_management/features/app/bloc/session_event.dart';
import 'package:state_management/features/signup/bloc/signup_bloc.dart';
import 'package:state_management/features/signup/bloc/signup_event.dart';
import 'package:state_management/features/signup/bloc/signup_state.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) => BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Registration Failure'), Icon(Icons.error)],
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
                _ConfirmPasswordInput(),
                _SignUpButton(),
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
          Icons.person_add_alt_1,
          color: Colors.white,
          size: 48,
        ),
      );
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<SignUpBloc, SignUpState>(
        buildWhen: (previous, current) => previous.emailVO != current.emailVO,
        builder: (context, state) {
          return TextField(
            key: const Key('signUpForm_emailInput_textField'),
            onChanged: (username) =>
                context.read<SignUpBloc>().add(EmailChanged(email: username)),
            decoration: InputDecoration(
              labelText: 'E-mail',
              errorText: state.emailVO.invalid ? 'Invalid email' : null,
            ),
          );
        },
      );
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<SignUpBloc, SignUpState>(
        buildWhen: (previous, current) =>
            previous.passwordVO != current.passwordVO,
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.only(top: 16.0),
            child: TextField(
              key: const Key('signUpForm_passwordInput_textField'),
              onChanged: (password) => context
                  .read<SignUpBloc>()
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

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.passwordVO != current.passwordVO ||
          previous.confirmPasswordVO != current.confirmPasswordVO,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(top: 16.0),
          child: TextField(
            key: const Key('signUpForm_confirmedPasswordInput_textField'),
            onChanged: (confirmPassword) => context
                .read<SignUpBloc>()
                .add(ConfirmPasswordChanged(confirmPassword: confirmPassword)),
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm password',
              helperText: '',
              errorText:
                  state.confirmPasswordVO.invalid ? 'Passwords do not match' : null,
            ),
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(top: 16.0),
          child: state.status.isSubmissionInProgress
              ? const CircularProgressIndicator()
              : RaisedButton(
                  key: const Key('signUpForm_continue_raisedButton'),
                  child: const Text('Sign Up'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: theme.primaryColorDark)),
                  color: theme.primaryColorDark,
                  textColor: Colors.white,
                  onPressed: state.status.isValidated
                      ? () {
                          context.read<SignUpBloc>().add(const Submitted());
                        }
                      : null,
                ),
        );
      },
    );
  }
}
