import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:state_management/features/app/bloc/session_state.dart';
import 'package:state_management/features/vo/local_user_vo.dart';

class MockLocalUserVO extends Mock implements LocalUserVO {}

void main() {
  group('SessionState', () {
    group('SessionState.unknown', () {
      test('supports value comparisons', () {
        expect(
          SessionState.unknown(),
          SessionState.unknown(),
        );
      });
    });

    group('SessionState.authenticated', () {
      test('supports value comparisons', () {
        final localUserVO = MockLocalUserVO();
        expect(
          SessionState.authenticated(localUserVO),
          SessionState.authenticated(localUserVO),
        );
      });
    });

    group('SessionState.unauthenticated', () {
      test('supports value comparisons', () {
        expect(
          SessionState.unauthenticated(),
          SessionState.unauthenticated(),
        );
      });
    });
  });
}
