import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../Firebase_service/firebase_service.dart';
abstract class AttendanceEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class LoadDashboardData extends AttendanceEvent {}

class SelectClass extends AttendanceEvent {
  final String className;

  SelectClass(this.className);

  @override
  List<Object> get props => [className];
}

class UpdateAttendance extends AttendanceEvent {
  final String studentId;
  final bool isPresent;

  UpdateAttendance(this.studentId, this.isPresent);

  @override
  List<Object> get props => [studentId, isPresent];
}

class FilterAttendance extends AttendanceEvent {
  final DateTime date;

  FilterAttendance(this.date);

  @override
  List<Object> get props => [date];
}

class InitializeSampleData extends AttendanceEvent {}

// States
abstract class AttendanceState extends Equatable {
  @override
  List<Object> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<ClassData> classes;
  final List<StudentAttendance> students;
  final AttendanceStats stats;
  final String selectedClass;
  final DateTime selectedDate;

  AttendanceLoaded({
    required this.classes,
    required this.students,
    required this.stats,
    required this.selectedClass,
    required this.selectedDate,
  });

  @override
  List<Object> get props =>
      [classes, students, stats, selectedClass, selectedDate];

  AttendanceLoaded copyWith({
    List<ClassData>? classes,
    List<StudentAttendance>? students,
    AttendanceStats? stats,
    String? selectedClass,
    DateTime? selectedDate,
  }) {
    return AttendanceLoaded(
      classes: classes ?? this.classes,
      students: students ?? this.students,
      stats: stats ?? this.stats,
      selectedClass: selectedClass ?? this.selectedClass,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

class AttendanceError extends AttendanceState {
  final String message;

  AttendanceError(this.message);

  @override
  List<Object> get props => [message];
}

// Updated Models
class ClassData {
  final String id;
  final String name;
  final int totalStudents;
  final int presentCount;

  ClassData({
    required this.id,
    required this.name,
    required this.totalStudents,
    required this.presentCount,
  });

  ClassData copyWith({
    String? id,
    String? name,
    int? totalStudents,
    int? presentCount,
  }) {
    return ClassData(
      id: id ?? this.id,
      name: name ?? this.name,
      totalStudents: totalStudents ?? this.totalStudents,
      presentCount: presentCount ?? this.presentCount,
    );
  }
}

class StudentAttendance {
  final String id;
  final String name;
  final String rollNumber;
  final bool isPresent;
  final String profileImage;
  final String classId;

  StudentAttendance({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.isPresent,
    required this.profileImage,
    required this.classId,
  });

  StudentAttendance copyWith({
    String? id,
    String? name,
    String? rollNumber,
    bool? isPresent,
    String? profileImage,
    String? classId,
  }) {
    return StudentAttendance(
      id: id ?? this.id,
      name: name ?? this.name,
      rollNumber: rollNumber ?? this.rollNumber,
      isPresent: isPresent ?? this.isPresent,
      profileImage: profileImage ?? this.profileImage,
      classId: classId ?? this.classId,
    );
  }
}

class AttendanceStats {
  final int totalStudents;
  final int presentToday;
  final int absentToday;
  final double attendanceRate;

  AttendanceStats({
    required this.totalStudents,
    required this.presentToday,
    required this.absentToday,
    required this.attendanceRate,
  });
}

// Updated BLoC with Firebase integration
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceService _attendanceService;

  AttendanceBloc(this._attendanceService) : super(AttendanceInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<SelectClass>(_onSelectClass);
    on<UpdateAttendance>(_onUpdateAttendance);
    on<FilterAttendance>(_onFilterAttendance);
    on<InitializeSampleData>(_onInitializeSampleData);
  }

  Future<void> _onLoadDashboardData(LoadDashboardData event,
      Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());

    try {
      final classes = await _attendanceService.getClasses();

      if (classes.isEmpty) {
        emit(AttendanceError('No classes found. Please add classes first.'));
        return;
      }

      final selectedClass = classes.first.id;
      final selectedDate = DateTime.now();

      final students = await _attendanceService.getAttendanceByDateAndClass(
          selectedClass,
          selectedDate
      );

      final stats = await _attendanceService.getAttendanceStats(
          selectedClass,
          selectedDate
      );

      // Update class present count
      final updatedClasses = classes.map((classData) {
        if (classData.id == selectedClass) {
          return classData.copyWith(presentCount: stats.presentToday);
        }
        return classData;
      }).toList();

      emit(AttendanceLoaded(
        classes: updatedClasses,
        students: students,
        stats: stats,
        selectedClass: selectedClass,
        selectedDate: selectedDate,
      ));
    } catch (e) {
      emit(AttendanceError('Failed to load dashboard data: ${e.toString()}'));
    }
  }

  Future<void> _onSelectClass(SelectClass event,
      Emitter<AttendanceState> emit) async {
    if (state is AttendanceLoaded) {
      final currentState = state as AttendanceLoaded;
      emit(AttendanceLoading());

      try {
        final students = await _attendanceService.getAttendanceByDateAndClass(
            event.className,
            currentState.selectedDate
        );

        final stats = await _attendanceService.getAttendanceStats(
            event.className,
            currentState.selectedDate
        );


        final updatedClasses = currentState.classes.map((classData) {
          if (classData.id == event.className) {
            return classData.copyWith(presentCount: stats.presentToday);
          }
          return classData;
        }).toList();

        emit(currentState.copyWith(
          selectedClass: event.className,
          students: students,
          stats: stats,
          classes: updatedClasses,
        ));
      } catch (e) {
        emit(AttendanceError('Failed to load class data: ${e.toString()}'));
      }
    }
  }

  Future<void> _onUpdateAttendance(UpdateAttendance event,
      Emitter<AttendanceState> emit) async {
    if (state is AttendanceLoaded) {
      final currentState = state as AttendanceLoaded;

      try {
        // Update in Firebase
        await _attendanceService.updateStudentAttendance(
          event.studentId,
          currentState.selectedClass,
          currentState.selectedDate,
          event.isPresent,
        );

        // Update local state
        final updatedStudents = currentState.students.map((student) {
          if (student.id == event.studentId) {
            return student.copyWith(isPresent: event.isPresent);
          }
          return student;
        }).toList();

        final stats = await _attendanceService.getAttendanceStats(
            currentState.selectedClass,
            currentState.selectedDate
        );

        // Update class present count
        final updatedClasses = currentState.classes.map((classData) {
          if (classData.id == currentState.selectedClass) {
            return classData.copyWith(presentCount: stats.presentToday);
          }
          return classData;
        }).toList();

        emit(currentState.copyWith(
          students: updatedStudents,
          stats: stats,
          classes: updatedClasses,
        ));
      } catch (e) {
        emit(AttendanceError('Failed to update attendance: ${e.toString()}'));
      }
    }
  }

  Future<void> _onFilterAttendance(FilterAttendance event,
      Emitter<AttendanceState> emit) async {
    if (state is AttendanceLoaded) {
      final currentState = state as AttendanceLoaded;
      emit(AttendanceLoading());

      try {
        final students = await _attendanceService.getAttendanceByDateAndClass(
            currentState.selectedClass,
            event.date
        );

        final stats = await _attendanceService.getAttendanceStats(
            currentState.selectedClass,
            event.date
        );

        // Update class present count for the selected date
        final updatedClasses = currentState.classes.map((classData) {
          if (classData.id == currentState.selectedClass) {
            return classData.copyWith(presentCount: stats.presentToday);
          }
          return classData;
        }).toList();

        emit(currentState.copyWith(
          selectedDate: event.date,
          students: students,
          stats: stats,
          classes: updatedClasses,
        ));
      } catch (e) {
        emit(AttendanceError('Failed to filter attendance: ${e.toString()}'));
      }
    }
  }

  Future<void> _onInitializeSampleData(InitializeSampleData event,
      Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());

    try {
      await _attendanceService.initializeSampleData();
      // Reload dashboard after initialization
      add(LoadDashboardData());
    } catch (e) {
      emit(
          AttendanceError('Failed to initialize sample data: ${e.toString()}'));
    }
  }
}