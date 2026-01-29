import 'package:flutter/material.dart';

import '../bloc/admin_bloc.dart';


class ClassSelector extends StatelessWidget {
  final List<ClassData> classes;
  final String selectedClass;
  final Function(String) onClassSelected;

  const ClassSelector({
    super.key,
    required this.classes,
    required this.selectedClass,
    required this.onClassSelected,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
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
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.class_,
                    color: Color(0xFF2E7D32),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Select Class',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E2E2E),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF2E7D32).withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFFF8F9FA),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: SingleChildScrollView(
                      child: DropdownButton<String>(
                        value: selectedClass,
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF2E7D32),
                        ),
                        items: classes.map((ClassData classData) {
                          return DropdownMenuItem<String>(
                            value: classData.id,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2E7D32).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.school,
                                    color: Color(0xFF2E7D32),
                                    size: 16,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        classData.name,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2E2E2E),
                                        ),
                                      ),
                                      Text(
                                        '${classData.presentCount}/${classData.totalStudents} present',
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getAttendanceColor(classData.presentCount, classData.totalStudents).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${((classData.presentCount / classData.totalStudents) * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _getAttendanceColor(classData.presentCount, classData.totalStudents),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            onClassSelected(newValue);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              (width>600)? _buildClassGrid(): Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassGrid() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final classData = classes[index];
        final isSelected = classData.id == selectedClass;
        final attendanceRate = (classData.presentCount / classData.totalStudents) * 100;

        return GestureDetector(
          onTap: () => onClassSelected(classData.id),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF2E7D32).withOpacity(0.1) : Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Color(0xFF2E7D32) : Colors.grey.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          classData.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: isSelected ? Color(0xFF2E7D32) : Color(0xFF2E2E2E),
                          ),
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getAttendanceColor(classData.presentCount, classData.totalStudents),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getAttendanceColor(int present, int total) {
    final rate = (present / total) * 100;
    if (rate >= 90) return Color(0xFF4CAF50);
    if (rate >= 75) return Color(0xFFFF9800);
    return Color(0xFFF44336);
  }
}