import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNo;
  final String? className;
  final String uniqueId;
  final String role;
  final String generatedId;
  final String dateOfBirth;
  final String fatherName;
  final String motherName;
  final String fatherPhoneNo;
  final String motherPhoneNo;
  final String fatherOccupation;
  final String motherOccupation;
  final String street;
  final String city;
  final String postalcode;
  final String state;
  final String country;
  final String gender;
  final String landmark;
  final String aadhaarNo;
  final bool isActive;
  final String profileImageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User(
    param0, {
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.motherName,
    required this.fatherPhoneNo,
    required this.motherPhoneNo,
    required this.fatherOccupation,
    required this.motherOccupation,
    required this.street,
    required this.city,
    required this.postalcode,
    required this.state,
    required this.country,
    required this.gender,
    required this.landmark,
    required this.aadhaarNo,
    required this.generatedId,
    required this.phoneNo,
    required this.className,
    required this.dateOfBirth,
    required this.uniqueId,
    required this.role,
    required this.isActive,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'dateOfBirth': dateOfBirth,
      'uniqueId': uniqueId,
      'name': name,
      'email': email,
      'phone': phoneNo,
      'generatedId': generatedId,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'role': role,
      'isActive': isActive,
      'firstName': firstName,
      'lastName': lastName,
      'fatherName': fatherName,
      'motherName': motherName,
      'fatherPhoneNo': fatherPhoneNo,
      'motherPhoneNo': motherPhoneNo,
      'fatherOccupation': fatherOccupation,
      'motherOccupation': motherOccupation,
      'street': street,
      'city': city,
      'postalcode': postalcode,
      'state': state,
      'country': country,
      'gender': gender,
      'landmark': landmark,
      'aadhaarNo': aadhaarNo,
      'classId': className,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['uniqueId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      phoneNo: map['phoneNo'] ?? '',
      className: map['className'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      uniqueId: map['uniqueId'] ?? '',
      role: map['role'] ?? '',
      isActive: map['isActive'] ?? false,
      generatedId: map['generatedId'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      fatherName: map['fatherName'] ?? '',
      motherName: map['motherName'] ?? '',
      fatherPhoneNo: map['fatherPhoneNo'] ?? '',
      motherPhoneNo: map['motherPhoneNo'] ?? '',
      fatherOccupation: map['fatherOccupation'] ?? '',
      motherOccupation: map['motherOccupation'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      postalcode: map['postalcode'] ?? '',
      state: map['state'] ?? '',
      country: map['country'] ?? '',
      gender: map['gender'] ?? '',
      landmark: map['landmark'] ?? '',
      aadhaarNo: map['aadhaarNo'] ?? '',
    );
  }

  User copyWith({
    String? name,
    String? email,
    String? phoneNo,
    String? className,
    String? dateOfBirth,
    String? uniqueId,
    String? role,
    bool? isActive,
    String? generatedId,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? firstName,
    String? lastName,
    String? fatherName,
    String? motherName,
    String? fatherPhoneNo,
    String? motherPhoneNo,
    String? fatherOccupation,
    String? motherOccupation,
    String? street,
    String? country,
    String? postalcode,
    String? landmark,
    String? gender,
    String? state,
    String? city,
    String? aadhaarNo,
    String? classId,


  }) {
    return User(
      generatedId ?? this.generatedId,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      className: className ?? this.className,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      uniqueId: uniqueId ?? this.uniqueId,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      firstName: firstName ?? this.firstName,
      lastName: lastName?? this.lastName,
      fatherName: fatherName?? this.fatherName,
      motherName: motherName?? this.motherName,
      fatherPhoneNo: fatherPhoneNo?? this.fatherPhoneNo,
      motherPhoneNo: motherPhoneNo?? this.motherPhoneNo,
      fatherOccupation: fatherOccupation?? this.fatherOccupation,
      motherOccupation: motherOccupation?? this.motherOccupation,
      street: street?? this.street,
      city: city?? this.city,
      postalcode: postalcode?? this.postalcode,
      state: state?? this.state,
      country: country?? this.country,
      gender: gender?? this.gender,
      landmark: landmark?? this.landmark,
      aadhaarNo: aadhaarNo?? this.aadhaarNo,
      generatedId: generatedId?? this.generatedId,
    );
  }
}
