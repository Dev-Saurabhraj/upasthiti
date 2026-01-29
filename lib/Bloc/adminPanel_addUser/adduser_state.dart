abstract class AddUserState {}

class AddUserInitial extends AddUserState {}

class AddUserLoading extends AddUserState {}

class AddUserSuccess extends AddUserState {
  final String message;
  final String userId;

  AddUserSuccess({
    required this.message,
    required this.userId,
  });
}

class AddUserFailure extends AddUserState {
  final String error;

  AddUserFailure({required this.error});
}

class ClassesCreatedSuccess extends AddUserState {
  final String message;
  final List<String> classIds;

  ClassesCreatedSuccess({
    required this.message,
    required this.classIds,
  });
}