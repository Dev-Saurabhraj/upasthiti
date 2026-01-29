abstract class AddUserEvent {}

class SubmitUserEvent extends AddUserEvent {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNo;
  final String? className;
  final String uniqueId;
  final String generatedId;
  final String name;
  final String role;
  final DateTime? dateOfBirth;
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

  SubmitUserEvent(
     {
       required this.generatedId,
       required this.name,
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNo,
    this.className,
    required this.uniqueId,
    required this.role,
    this.dateOfBirth,
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
  });
}

class CreateClassesEvent extends AddUserEvent {
  CreateClassesEvent();
}
