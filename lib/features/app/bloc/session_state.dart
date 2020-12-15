
import 'package:equatable/equatable.dart';
import 'package:state_management/features/app/session_status.dart';
import 'package:state_management/features/vo/local_user_vo.dart';

class SessionState extends Equatable {

  const SessionState._({
    this.status = SessionStatus.unknown,
    this.localUserVO = LocalUserVO.empty ,
  });

  const SessionState.unknown() : this._();

  const SessionState.authenticated(LocalUserVO localUserVO)
      : this._(status: SessionStatus.authenticated, localUserVO: localUserVO);

  const SessionState.unauthenticated()
      : this._(status: SessionStatus.unauthenticated);

  final SessionStatus status;
  final LocalUserVO localUserVO;

  @override
  List<Object> get props => [status, localUserVO];
}