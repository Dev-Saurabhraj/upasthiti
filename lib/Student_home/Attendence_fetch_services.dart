import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceFetchServices{

  static Future<Map<String, bool>> getStudentAttendanceHistory(String generatedId) async {
    final studentSnapshot = await FirebaseFirestore.instance.collection('students').where('generatedId', isEqualTo: generatedId).get();
    final String studentId = studentSnapshot.docs.first.id;
    final snapshot = await FirebaseFirestore.instance
        .collection('attendance')
        .get();

    Map<String, bool> attendanceByDate = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final studentsMap = data['students'] as Map<String, dynamic>? ?? {};
      final date = data['date'] as String;
      if(studentsMap.isNotEmpty && !studentsMap.containsKey(studentId)){
        attendanceByDate[date] = false;
      }
      if (studentsMap.containsKey(studentId)) {
        attendanceByDate[date] = studentsMap[studentId] as bool;
      }
    }
    return attendanceByDate;
  }

  static Map<String, int> calculateYearlyAttendanceSummary(Map<String, bool> attendanceData) {
    final start = DateTime(2025, 4, 1); // 1 April
    final end = DateTime(2026, 3, 31);

    int totalPresent = 0;
    int totalAbsent = 0;
    int totalDays = 0;

    attendanceData.forEach((dateStr, isPresent) {
      final date = DateTime.parse(dateStr);
      if (date.isAfter(start.subtract(const Duration(days: 1))) && date.isBefore(end.add(const Duration(days: 1)))) {
        totalDays++;
        if (isPresent) {
          totalPresent++;
        } else {
          totalAbsent++;
        }
      }
    });

    return {
      "present": totalPresent,
      "absent": totalAbsent,
      "total": totalDays,
    };
  }



}