import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:state_management/domain/usercase/authentication_use_cases.dart';
import 'package:state_management/features/app/bloc/session_bloc.dart';
import 'package:state_management/features/app/bloc/session_event.dart';
import 'package:state_management/features/app/bloc/session_state.dart';
import 'package:state_management/features/vo/local_user_vo.dart';

class MockAuthenticationUseCases extends Mock
    implements AuthenticationUseCases {}

class MockLocalUserVO extends Mock implements LocalUserVO {}

void main() {
  final mockLocalUserVO = MockLocalUserVO();
  AuthenticationUseCases mockAuthenticationUseCases;

  setUp(() {
    mockAuthenticationUseCases = MockAuthenticationUseCases();
  });

  group('SessionBloc', () {
    test('throws when mockAuthenticationUseCases is null', () {
      expect(
        () => SessionBloc(authenticationUseCases: null),
        throwsAssertionError,
      );
    });

    test('initial state is SessionState.unknown', () {
      final sessionBloc = SessionBloc(
        authenticationUseCases: mockAuthenticationUseCases,
      );
      expect(sessionBloc.state, const SessionState.unknown());
      sessionBloc.close();
    });

    group('SessionUserChanged', () {
      blocTest<SessionBloc, SessionState>(
        'emits [authenticated] when user is not null',
        build: () => SessionBloc(
          authenticationUseCases: mockAuthenticationUseCases,
        ),
        act: (bloc) =>
            bloc.add(SessionUserChanged(localUserVO: mockLocalUserVO)),
        expect: <SessionState>[
          SessionState.authenticated(mockLocalUserVO),
        ],
      );

      blocTest<SessionBloc, SessionState>(
        'emits [unauthenticated] when user is empty',
        build: () => SessionBloc(
          authenticationUseCases: mockAuthenticationUseCases,
        ),
        act: (bloc) => bloc.add(const SessionUserChanged(localUserVO: LocalUserVO.empty)),
        expect: const <SessionState>[
          SessionState.unauthenticated(),
        ],
      );
    });

    group('SessionLogoutRequested', () {
      blocTest<SessionBloc, SessionState>(
        'calls logOut on mockAuthenticationUseCases '
            'when SessionLogoutRequested is added',
        build: () => SessionBloc(
          authenticationUseCases: mockAuthenticationUseCases,
        ),
        act: (bloc) => bloc.add(SessionLogoutRequested()),
        verify: (_) {
          verify(mockAuthenticationUseCases.signOut()).called(1);
        },
        expect: const <SessionState>[
          SessionState.unauthenticated(),
        ],
      );
    });
  });
}
