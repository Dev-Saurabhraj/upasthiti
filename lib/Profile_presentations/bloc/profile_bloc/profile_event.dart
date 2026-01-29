import '../../Constants/constant.dart';


abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final String userId;
  final String userRole;
  LoadProfile(this.userId, this.userRole);
}

class UpdateProfile extends ProfileEvent {
  final User user;
  UpdateProfile(this.user);
}
