import 'package:state_management/domain/entities/local_user.dart';

class LocalUserVO {
  const LocalUserVO._(this.displayName, this.email, this.photoUrl);

  final String displayName;
  final String email;
  final String photoUrl;

  factory LocalUserVO.fromUser(LocalUser localUser) =>
      LocalUserVO._(localUser.displayName, localUser.email, localUser.photoUrl);

  static const empty = LocalUserVO._( '', '', '');
}