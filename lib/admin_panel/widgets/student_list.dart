
import 'package:flutter/material.dart';
import '../bloc/admin_bloc.dart';

class StudentList extends StatelessWidget {
  final List<StudentAttendance> students;
  final Function(String, bool) onAttendanceChanged;

  const StudentList({
    super.key,
    required this.students,
    required this.onAttendanceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader( context ),
          Expanded(
            child: students.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return _buildStudentItem(students[index], index, context);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader( BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double iconSize = width < 600 ? 20 : width < 1024 ? 24 : 28;
    double valueFontSize = width < 600 ? 20 : width < 1024 ? 24 : 26;
    double titleFontSize = width < 600 ? 12 : width < 1024 ? 13 : 14;
    double padding = width < 600 ? 14 : 20;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.people,
            color: Color(0xFF2E7D32),
            size: iconSize,
          ),
          SizedBox(width: 12),
          Text(
            'Student Attendance',
            style: TextStyle(
              fontSize: valueFontSize/1.1,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${students.length} Students',
              style: TextStyle(
                color: Color(0xFF2E7D32),
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No Students Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Select a class to view students',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentItem(StudentAttendance student, int index, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: student.isPresent ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: student.isPresent
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            _buildAvatar(student, index, context),
            SizedBox(width: 16),
            Expanded(
              child: _buildStudentInfo(student, context),
            ),
            SizedBox(width: 16),
            _buildAttendanceToggle(student),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(StudentAttendance student, int index, BuildContext context) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    final width = MediaQuery.of(context).size.width;
    double boxSize = width < 600 ? 20 : width < 1024 ? 24 : 28;
    double titleFontSize = width < 600 ? 12 : width < 1024 ? 13 : 14;
    double padding = width < 600 ? 14 : 20;

    return Container(
      width: boxSize*1.8,
      height: boxSize*1.8,
      decoration: BoxDecoration(
        color: colors[index % colors.length].withOpacity(0.1),
        borderRadius: BorderRadius.circular(padding/1.5),
        border: Border.all(
          color: colors[index % colors.length].withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          student.name[0].toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize*1.3,
            color: colors[index % colors.length],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentInfo(StudentAttendance student, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double titleFontSize = width < 600 ? 12 : width < 1024 ? 13 : 14;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          student.name,
          style: TextStyle(
            fontSize: titleFontSize*1.2,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E2E2E),
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Roll: ${student.rollNumber}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: student.isPresent
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    student.isPresent ? Icons.check_circle : Icons.cancel,
                    size: 12,
                    color:
                        student.isPresent ? Colors.green[700] : Colors.red[700],
                  ),
                  SizedBox(width: 4),
                  Text(
                    student.isPresent ? 'Present' : 'Absent',
                    style: TextStyle(
                      fontSize: titleFontSize/1.6,
                      color: student.isPresent
                          ? Colors.green[700]
                          : Colors.red[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttendanceToggle(StudentAttendance student) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => onAttendanceChanged(student.id, true),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: student.isPresent ? Colors.green : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              boxShadow: student.isPresent
                  ? [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              Icons.check,
              color: student.isPresent ? Colors.white : Colors.grey[600],
              size: 18,
            ),
          ),
        ),
        SizedBox(width: 8),
        GestureDetector(
          onTap: () => onAttendanceChanged(student.id, false),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: !student.isPresent ? Colors.red : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              boxShadow: !student.isPresent
                  ? [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              Icons.close,
              color: !student.isPresent ? Colors.white : Colors.grey[600],
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
