import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static CollectionReference get studentsCollection => _firestore.collection('students');
  static CollectionReference get teachersCollection => _firestore.collection('teachers');

  static Stream<QuerySnapshot> searchStudents(String searchTerm) {
    return studentsCollection
        .where('name', isGreaterThanOrEqualTo: searchTerm)
        .where('name', isLessThanOrEqualTo: searchTerm + '\uf8ff')
        .snapshots();
  }

  // Search teachers by name
  static Stream<QuerySnapshot> searchTeachers(String searchTerm) {
    return teachersCollection
        .where('name', isGreaterThanOrEqualTo: searchTerm)
        .where('name', isLessThanOrEqualTo: searchTerm + '\uf8ff')
        .snapshots();
  }

  // Get students by class
  static Stream<QuerySnapshot> getStudentsByClass(String className) {
    return studentsCollection
        .where('class', isEqualTo: className)
        .orderBy('name')
        .snapshots();
  }

  // Get teachers by subject
  static Stream<QuerySnapshot> getTeachersBySubject(String subject) {
    return teachersCollection
        .where('subject', isEqualTo: subject)
        .orderBy('name')
        .snapshots();
  }


  static Stream<QuerySnapshot> getActiveStudents() {
    return studentsCollection
        .where('status', isEqualTo: 'Active')
        .orderBy('name')
        .snapshots();
  }

  static Stream<QuerySnapshot> getActiveTeachers() {
    return teachersCollection
        .where('status', isEqualTo: 'Active')
        .orderBy('name')
        .snapshots();
  }
}