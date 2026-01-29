import 'package:campusbuzz/Profile_presentations/Edit_profile/edit_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/edit_profile_constant.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';
import '../../profile_firebase_service/edit_profile_firebase_service.dart';

class StudentEditBloc extends Bloc<StudentEditEvent, StudentEditState> {
  final StudentRepository studentRepository;
  StudentModel? _currentStudent; // Add this field

  StudentEditBloc({required this.studentRepository}) : super(StudentEditInitial()) {
    on<LoadStudentEvent>(_onLoadStudent);
    on<UpdateStudentEvent>(_onUpdateStudent);
  }

  void _onLoadStudent(LoadStudentEvent event, Emitter<StudentEditState> emit) async {
    try {
      emit(StudentEditLoading());
      final student = await studentRepository.getStudentByUniqueId(event.uniqueId);
      _currentStudent = student; // Store the student data
      emit(StudentEditLoaded(student));
    } catch (e) {
      emit(StudentEditFailure('Failed to load student: ${e.toString()}'));
    }
  }

  void _onUpdateStudent(UpdateStudentEvent event, Emitter<StudentEditState> emit) async {
    try {
      emit(StudentEditUpdating());

      if (_currentStudent == null) {
        emit(StudentEditFailure('No student data loaded'));
        return;
      }

      final updatedStudent = StudentModel(
        documentId: _currentStudent!.documentId,
        uniqueId: _currentStudent!.uniqueId,
        name: event.name,
        email: event.email,
        phoneNo: event.phoneNo,
        className: event.className,
        classId: event.classId,
        dateOfBirth: event.dateOfBirth,
        role: event.role,
        isActive: event.isActive,
        generatedId: _currentStudent!.generatedId,
      );

      await studentRepository.updateStudent(updatedStudent);
      _currentStudent = updatedStudent; // Update the stored data
      emit(StudentEditSuccess('Student updated successfully'));
    } catch (e) {
      emit(StudentEditFailure('Failed to update student: ${e.toString()}'));
    }
  }
}
