import 'package:flutter_test/flutter_test.dart';
import 'package:state_management/features/app/bloc/session_event.dart';

void main() {
  group('AuthenticationEvent', () {
    group('LoggedOut', () {
      test('supports value comparisons', () {
        expect(
          SessionLogoutRequested(),
          SessionLogoutRequested(),
        );
      });
    });

    group('SessionUserChanged', () {
      test('supports value comparisons', () {
        expect(
          SessionUserChanged(localUserVO: null),
          SessionUserChanged(localUserVO: null),
        );
      });
    });
  });
}
