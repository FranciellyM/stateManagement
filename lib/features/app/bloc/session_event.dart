import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:state_management/features/vo/local_user_vo.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object> get props => [];
}

class SessionUserChanged extends SessionEvent {
  const SessionUserChanged({ @required this.localUserVO });

  final LocalUserVO localUserVO;

  @override
  List<Object> get props => [localUserVO];
}

class SessionLogoutRequested extends SessionEvent {}

class StartSession extends SessionEvent {}