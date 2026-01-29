// edit_profile_state.dart
import '../../Constants/edit_profile_constant.dart';
import '../../Edit_profile/edit_profile.dart';
import '../../profile_firebase_service/edit_profile_firebase_service.dart';

abstract class StudentEditState {}

class StudentEditInitial extends StudentEditState {}

class StudentEditLoading extends StudentEditState {}

class StudentEditLoaded extends StudentEditState {
  final StudentModel student;
  StudentEditLoaded(this.student);
}

class StudentEditUpdating extends StudentEditState {}

class StudentEditSuccess extends StudentEditState {
  final String message;
  StudentEditSuccess(this.message);
}

class StudentEditFailure extends StudentEditState {
  final String error;
  StudentEditFailure(this.error);
}

class ClassesLoading extends StudentEditState {}

class ClassesLoaded extends StudentEditState {
  final List<ClassModel> classes;
  ClassesLoaded(this.classes);
}

class ClassesLoadFailure extends StudentEditState {
  final String error;
  ClassesLoadFailure(this.error);
}