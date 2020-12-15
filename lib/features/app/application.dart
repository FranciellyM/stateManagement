import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:state_management/domain/usercase/authentication_use_cases.dart';
import 'package:state_management/features/app/bloc/session_bloc.dart';
import 'package:state_management/features/app/bloc/session_event.dart';
import 'package:state_management/features/app/bloc/session_state.dart';
import 'package:state_management/features/app/session_status.dart';
import 'package:state_management/features/home/home_screen.dart';
import 'package:state_management/features/singin/signin_screen.dart';
import 'package:state_management/features/splash/splash_screen.dart';

class Application extends StatefulWidget {
  const Application({Key key, @required this.authenticationUseCases});

  final AuthenticationUseCases authenticationUseCases;

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  SessionBloc sessionBloc;

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  void initState() {
    sessionBloc =
        SessionBloc(authenticationUseCases: widget.authenticationUseCases);
    sessionBloc.add(StartSession());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sessionBloc,
      child: MaterialApp(
        theme: appTheme,
        navigatorKey: _navigatorKey,
        builder: (context, child) {
          return BlocListener<SessionBloc, SessionState>(
            listener: (context, state) {
              switch (state.status) {
                case SessionStatus.authenticated:
                  _navigator.pushAndRemoveUntil<void>(
                    HomeScreen.route(),
                    (route) => false,
                  );
                  break;
                case SessionStatus.unauthenticated:
                  _navigator.pushAndRemoveUntil<void>(
                    SignInScreen.route(widget.authenticationUseCases),
                    (route) => false,
                  );
                  break;
                default:
                  break;
              }
            },
            child: child,
          );
        },
        onGenerateRoute: (_) => SplashScreen.route(),
      ),
    );
  }

  ThemeData get appTheme => ThemeData( textTheme: GoogleFonts.openSansTextTheme(),
  primaryColorDark: const Color(0xFF7579e7),
  primaryColorLight: const Color(0xFFb9fffc),
  primaryColor: const Color(0xFF9ab3f5),
  accentColor:  const Color(0xFF7579e7),
  errorColor: Colors.red,
  scaffoldBackgroundColor: Colors.white,
  inputDecorationTheme: InputDecorationTheme(
  border: OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  ),

        ),
      );
}
