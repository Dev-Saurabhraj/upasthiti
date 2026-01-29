import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../bloc/admin_bloc.dart';


class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  CollectionReference get _attendanceCollection => _firestore.collection('attendance');
  CollectionReference get _studentsCollection => _firestore.collection('students');
  CollectionReference get _classesCollection => _firestore.collection('classes');


  Future<List<ClassData>> getClasses() async {
    try {
      final snapshot = await _classesCollection.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ClassData(
          id: doc.id,
          name: data['name'] ?? '',
          totalStudents: data['totalStudents'] ?? 0,
          presentCount: 0, // Will be calculated based on attendance
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch classes: $e');
    }
  }


  Future<List<StudentAttendance>> getStudentsByClass(String classId) async {
    try {
      final snapshot = await _studentsCollection
          .where('classId', isEqualTo: classId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return StudentAttendance(
          id: doc.id,
          name: data['name'] ?? '',
          rollNumber: data['rollNumber'] ?? '',
          isPresent: false,
          profileImage: data['profileImage'] ?? '',
          classId: data['classId'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  // Get attendance for specific date and class
  Future<List<StudentAttendance>> getAttendanceByDateAndClass(
      String classId,
      DateTime date
      ) async {
    try {
      final dateString = DateFormat('yyyy-MM-dd').format(date);
      final students = await getStudentsByClass(classId);

      // Get attendance records for the specific date and class
      final attendanceSnapshot = await _attendanceCollection
          .where('classId', isEqualTo: classId)
          .where('date', isEqualTo: dateString)
          .get();

      // Create a map of student attendance
      Map<String, bool> attendanceMap = {};
      for (var doc in attendanceSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final studentAttendances = data['students'] as Map<String, dynamic>? ?? {};
        attendanceMap.addAll(studentAttendances.map((key, value) => MapEntry(key, value as bool)));
      }


      return students.map((student) {
        return student.copyWith(
          isPresent: attendanceMap[student.id] ?? false,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch attendance: $e');
    }
  }

  // Update attendance for a student
  Future<void> updateStudentAttendance(
      String studentId,
      String classId,
      DateTime date,
      bool isPresent,
      ) async {
    try {
      final dateString = DateFormat('yyyy-MM-dd').format(date);
      final attendanceDocId = '${classId}_$dateString';

      await _attendanceCollection.doc(attendanceDocId).set({
        'classId': classId,
        'date': dateString,
        'students': {
          studentId: isPresent,
        },
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update attendance: $e');
    }
  }

  Future<AttendanceStats> getAttendanceStats(
      String classId,
      DateTime date
      ) async {
    try {
      final students = await getAttendanceByDateAndClass(classId, date);
      final total = students.length;
      final present = students.where((s) => s.isPresent).length;
      final absent = total - present;
      final rate = total > 0 ? (present / total) * 100 : 0.0;

      return AttendanceStats(
        totalStudents: total,
        presentToday: present,
        absentToday: absent,
        attendanceRate: rate,
      );
    } catch (e) {
      throw Exception('Failed to calculate stats: $e');
    }
  }

  // Initialize sample data (call this once to set up your database)
  Future<void> initializeSampleData() async {
    try {
      // Add sample classes
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
      for (var classData in classes) {
        final docRef = await _classesCollection.add(classData);
        classIds.add(docRef.id);
      }

      // Add sample students
      final studentNames = ['Priya Patel'
      ];

      int rollNumber = 1;
      for (String classId in classIds) {
        for (int i = 0; i < studentNames.length; i++) {
          await _studentsCollection.add({
            'name': studentNames[i],
            'rollNumber': rollNumber.toString().padLeft(3, '0'),
            'classId': classId,
            'profileImage': '',
          });
          rollNumber++;
        }
      }


      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      for (String classId in classIds) {
        final students = await getStudentsByClass(classId);
        Map<String, bool> attendanceData = {};

        for (var student in students) {

          attendanceData[student.id] = DateTime.now().millisecond % 2 == 0;
        }

        await _attendanceCollection.doc('${classId}_$today').set({
          'classId': classId,
          'date': today,
          'students': attendanceData,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Failed to initialize sample data: $e');
    }
  }
}


