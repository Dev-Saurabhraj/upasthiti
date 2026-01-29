import 'package:equatable/equatable.dart';

abstract class StudentEditEvent extends Equatable {
  const StudentEditEvent();

  @override
  List<Object?> get props => [];
}

class LoadStudentEvent extends StudentEditEvent {
  final String uniqueId;

  const LoadStudentEvent(this.uniqueId);

  @override
  List<Object?> get props => [uniqueId];
}

class LoadClassesEvent extends StudentEditEvent{}

class UpdateStudentEvent extends StudentEditEvent {
  final String name;
  final String email;
  final String phoneNo;
  final String className;
  final String classId;
  final String? dateOfBirth;
  final String role;
  final bool isActive;
  final String uniqueId;

  const UpdateStudentEvent({
    required this.uniqueId,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.className,
    required this.classId,
    this.dateOfBirth,
    required this.role,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    phoneNo,
    className,
    classId,
    dateOfBirth,
    role,
    isActive,
  ];
}
