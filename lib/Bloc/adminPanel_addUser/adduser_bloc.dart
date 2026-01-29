import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adduser_event.dart';
import 'adduser_state.dart';

class AddUserBloc extends Bloc<AddUserEvent, AddUserState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AddUserBloc() : super(AddUserInitial()) {
    on<SubmitUserEvent>(onSubmitUser);
    on<CreateClassesEvent>(onCreateClasses);
  }


  Future<void> onCreateClasses(
      CreateClassesEvent event,
      Emitter<AddUserState> emit,
      ) async {
    emit(AddUserLoading());

    try {
      final classes = [
        {'name': 'Class 1st', 'totalStudents': 8},
        {'name': 'Class 2nd', 'totalStudents': 8},
        {'name': 'Class 3rd', 'totalStudents': 8},
        {'name': 'Class 4th', 'totalStudents': 8},
        {'name': 'Class 5th', 'totalStudents': 8},
        {'name': 'Class 6th', 'totalStudents': 8},
        {'name': 'Class 7th', 'totalStudents': 8},
        {'name': 'Class 8th', 'totalStudents': 8},
        {'name': 'Class 9th', 'totalStudents': 8},
        {'name': 'Class 10th', 'totalStudents': 8},
        {'name': 'Class 11th', 'totalStudents': 8},
        {'name': 'Class 12th', 'totalStudents': 8},
        {'name': 'Class Nursery', 'totalStudents': 8},
        {'name': 'Class KG1', 'totalStudents': 8},
        {'name': 'Class KG2', 'totalStudents': 8},
      ];


      List<String> classIds = [];
      final classesCollection = firestore.collection('classes');

      for (var classData in classes) {

        classData['createdAt'] = FieldValue.serverTimestamp();
        classData['updatedAt'] = FieldValue.serverTimestamp();
        classData['currentStudents'] = 0;
        classData['isActive'] = true;

        final docRef = await classesCollection.add(classData);
        classIds.add(docRef.id);
      }

      emit(ClassesCreatedSuccess(
        message: 'Classes created successfully!',
        classIds: classIds,
      ));
    } catch (e) {
      emit(AddUserFailure(error: 'Failed to create classes: ${e.toString()}'));
    }
  }

  Future<void> onSubmitUser(
      SubmitUserEvent event,
      Emitter<AddUserState> emit,
      ) async {
    emit(AddUserLoading());

    try {

      final emailQuery = await firestore
          .collection(event.role == 'teacher' ? 'teachers' : 'students')
          .where('email', isEqualTo: event.email)
          .get();

      final uniqueIdQuery = await firestore
          .collection(event.role == 'teacher' ? 'teachers' : 'students')
          .where('uniqueId', isEqualTo: event.uniqueId)
          .get();

      if (emailQuery.docs.isNotEmpty) {
        emit(AddUserFailure(error: 'User with this email already exists'));
        return;
      }

      if (uniqueIdQuery.docs.isNotEmpty) {
        emit(AddUserFailure(error: 'User with this ID already exists'));
        return;
      }

      String? classDocId;

      if ( event.role == 'student' && event.className != null ) {
        final classQuery = await firestore
            .collection('classes')
            .where('name', isEqualTo: event.className)
            .get();

        if (classQuery.docs.isEmpty) {
          emit(AddUserFailure(error: 'Class "${event.className}" does not exist'));
          return;
        }

        classDocId = classQuery.docs.first.id;
        final classData = classQuery.docs.first.data();
        final currentStudents = classData['currentStudents'] ?? 0;
        final totalStudents = classData['totalStudents'] ?? 0;

        if (currentStudents >= totalStudents) {
          emit(AddUserFailure(error: 'Class "${event.className}" is full'));
          return;
        }
      }


      final userData = {
        'name': event.name,
        'firstName': event.firstName,
        'lastName': event.lastName,
        'email': event.email,
        'phoneNo': event.phoneNo,
        'className': event.className,
        'classId': classDocId,
        'uniqueId': event.uniqueId,
        'role': event.role,
        'generatedId': event.generatedId,
        'dateOfBirth': event.dateOfBirth?.toIso8601String(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'fatherName': event.fatherName,
        'motherName': event.motherName,
        'motherPhoneNo':event.motherPhoneNo,
        'fatherPhoneNo':event.fatherPhoneNo,
        'motherOccupation': event.motherOccupation,
        'fatherOccupation':event.fatherOccupation,
        'aadhaarNo': event.aadhaarNo,
        'city': event.city,
        'state': event.state,
        'street': event.street,
        'country': event.country,
        'postalcode': event.postalcode,
        'landmark': event.landmark,
        'gender': event.gender,

      };


      final collection = event.role == 'teacher' ? 'teachers' : 'students';
      final docRef = await firestore.collection(collection).add(userData);


      if (event.role == 'student' && classDocId != null) {
        await firestore.collection('classes').doc(classDocId).update({
          'currentStudents': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      emit(AddUserSuccess(
        message: '${event.role.toUpperCase()} added successfully!',
        userId: docRef.id,
      ));
    } catch (e) {
      emit(AddUserFailure(error: 'Failed to add user: ${e.toString()}'));
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableClasses() async {
    try {
      final querySnapshot = await firestore
          .collection('classes')
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch classes: ${e.toString()}');
    }
  }
}