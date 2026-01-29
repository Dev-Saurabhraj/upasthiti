// student_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Constants/edit_profile_constant.dart';

class StudentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<StudentModel> getStudentByUniqueId(String uniqueId) async {
    print(uniqueId);
    try {
      final querySnapshot = await _firestore
          .collection('students')
          .where('uniqueId', isEqualTo: uniqueId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return StudentModel.fromMap(doc.data(), doc.id);
      } else {
        throw Exception('Student not found with unique ID: $uniqueId');
      }
    } catch (e) {
      throw Exception('Error loading student: $e');
    }
  }

  Future<void> updateStudent(StudentModel student) async {
    try {
      if (student.documentId == null) {
        throw Exception('Document ID is required for update');
      }

      final updateData = student.toMap();
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('students')
          .doc(student.documentId!)
          .update(updateData);
    } catch (e) {
      throw Exception('Error updating student: $e');
    }
  }

  Future<List<ClassModel>> getClasses() async {

    try {
      final querySnapshot = await _firestore
          .collection('classes')
          .orderBy('name')
          .get();
      return querySnapshot.docs
          .map((doc) => ClassModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error loading classes: $e');
    }
  }
}

// ClassModel for handling class data
class ClassModel {
  final String className;
  final String classId;
  final String? documentId;

  ClassModel({
    required this.className,
    required this.classId,
    this.documentId,
  });

  factory ClassModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ClassModel(
      className: map['name'] ?? '',
      classId: map['classId'] ?? '',
      documentId: documentId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': className,
      'classId': classId,
    };
  }
}