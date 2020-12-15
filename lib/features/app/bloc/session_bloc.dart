import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:state_management/domain/usercase/authentication_use_cases.dart';
import 'package:state_management/features/app/bloc/session_event.dart';
import 'package:state_management/features/app/bloc/session_state.dart';
import 'package:state_management/features/vo/local_user_vo.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc({@required AuthenticationUseCases authenticationUseCases})
      : assert(authenticationUseCases != null),
        _authenticationUseCases = authenticationUseCases,
        super(SessionState.unknown());

  final AuthenticationUseCases _authenticationUseCases;

  @override
  Stream<SessionState> mapEventToState(SessionEvent event) async* {
    if (event is SessionUserChanged) {
      yield _mapAuthenticationUserChangedToState(event);
    } else if(event is SessionLogoutRequested) {
      yield* _mapSessionLogoutRequestedToState();
    } else {
      yield const SessionState.unauthenticated();
    }
  }

  SessionState _mapAuthenticationUserChangedToState(SessionUserChanged event) {
    return event.localUserVO != LocalUserVO.empty
        ? SessionState.authenticated(event.localUserVO)
        : const SessionState.unauthenticated();
  }

  Stream<SessionState> _mapSessionLogoutRequestedToState() async* {
    await _authenticationUseCases.signOut();
    yield const SessionState.unauthenticated();
  }
}
