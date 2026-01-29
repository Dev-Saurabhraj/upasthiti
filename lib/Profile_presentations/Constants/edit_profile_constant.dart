
// student_model.dart
class StudentModel {
  final String? documentId;
  final String classId;
  final String className;
  final DateTime? createdAt;
  final String? dateOfBirth;
  final String email;
  final String generatedId;
  final bool isActive;
  final String name;
  final String phoneNo;
  final String role;
  final String uniqueId;
  final DateTime? updatedAt;

  StudentModel({
    this.documentId,
    required this.classId,
    required this.className,
    this.createdAt,
    this.dateOfBirth,
    required this.email,
    required this.generatedId,
    required this.isActive,
    required this.name,
    required this.phoneNo,
    required this.role,
    required this.uniqueId,
    this.updatedAt,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map, String docId) {
    return StudentModel(
      documentId: docId,
      classId: map['classId'] ?? '',
      className: map['className'] ?? '',
      createdAt: map['createdAt']?.toDate(),
      dateOfBirth: map['dateOfBirth'],
      email: map['email'] ?? '',
      generatedId: map['generatedId'] ?? '',
      isActive: map['isActive'] ?? true,
      name: map['name'] ?? '',
      phoneNo: map['phoneNo'] ?? '',
      role: map['role'] ?? 'student',
      uniqueId: map['uniqueId'] ?? '',
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'className': className,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'generatedId': generatedId,
      'isActive': isActive,
      'name': name,
      'phoneNo': phoneNo,
      'role': role,
      'uniqueId': uniqueId,
    };
  }

  StudentModel copyWith({
    String? documentId,
    String? classId,
    String? className,
    DateTime? createdAt,
    String? dateOfBirth,
    String? email,
    String? generatedId,
    bool? isActive,
    String? name,
    String? phoneNo,
    String? role,
    String? uniqueId,
    DateTime? updatedAt,
  }) {
    return StudentModel(
      documentId: documentId ?? this.documentId,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      createdAt: createdAt ?? this.createdAt,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      generatedId: generatedId ?? this.generatedId,
      isActive: isActive ?? this.isActive,
      name: name ?? this.name,
      phoneNo: phoneNo ?? this.phoneNo,
      role: role ?? this.role,
      uniqueId: uniqueId ?? this.uniqueId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

