import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Bloc/adminPanel_addUser/adduser_bloc.dart';
import '../Bloc/adminPanel_addUser/adduser_event.dart';
import '../Bloc/adminPanel_addUser/adduser_state.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();


  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _uniqueIdController = TextEditingController();
  final _aadhaarNoController = TextEditingController(); // New field

  final _subjectController = TextEditingController();


  final _fatherNameController = TextEditingController();
  final _fatherPhoneNoController = TextEditingController();
  final _fatherOccupationController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _motherPhoneNoController = TextEditingController();
  final _motherOccupationController = TextEditingController();

  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _landmarkController = TextEditingController();


  String role = 'student';
  String className = '';
  DateTime? dateOfBirth;
  String gender = 'Male';

  final List<String> classList = [
    'Nursery', 'KG1', 'KG2', 'Class 1st', 'Class 2nd', 'Class 3rd', 'Class 4th', 'Class 5th',
    'Class 6th', 'Class 7th', 'Class 8th', 'Class 9th', 'Class 10th',
    'Class 11th', 'Class 12th',
  ];

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> countryList = ['India', 'USA', 'Canada', 'UK', 'Australia'];
  final List<String> stateList = ['Uttar Pradesh', 'Maharashtra', 'Delhi', 'Karnataka'];

  String selectedCountry = 'India';
  String selectedState = 'Uttar Pradesh';


  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _uniqueIdController.dispose();
    _aadhaarNoController.dispose();

    _fatherNameController.dispose();
    _fatherPhoneNoController.dispose();
    _fatherOccupationController.dispose();
    _motherNameController.dispose();
    _motherPhoneNoController.dispose();
    _motherOccupationController.dispose();

    _streetController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _landmarkController.dispose();

    super.dispose();
  }

  String _generateUniqueId() {
    final now = DateTime.now();
    final prefix = role == 'student' ? 'ST' : 'TR';
    return '$prefix${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecond.toString().padLeft(3, '0')}';
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _subjectController.clear();
    _uniqueIdController.clear();
    _aadhaarNoController.clear();

    _fatherNameController.clear();
    _fatherPhoneNoController.clear();
    _fatherOccupationController.clear();
    _motherNameController.clear();
    _motherPhoneNoController.clear();
    _motherOccupationController.clear();

    _streetController.clear();
    _cityController.clear();
    _postalCodeController.clear();
    _landmarkController.clear();

    setState(() {
      role = 'student';
      className = '';
      dateOfBirth = null;
      gender = 'Male';
      selectedCountry = 'India';
      selectedState = 'Uttar Pradesh';
    });
  }

  Future<bool?> _showConfirmationDialog() {
    final generatedId = _generateUniqueId();
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_add,
                  color: Color(0xFF2E7D32),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Confirm User Details',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 400, // Fixed width for desktop dialog
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Please confirm the following details:',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildConfirmationRow('Role', role.toUpperCase()),
                  _buildConfirmationRow('Name', '${_firstNameController.text} ${_lastNameController.text}'),
                  _buildConfirmationRow('Email', _emailController.text),
                  _buildConfirmationRow('Phone', _phoneController.text),
                  _buildConfirmationRow('Aadhaar No.', _aadhaarNoController.text),
                  _buildConfirmationRow('Gender', gender),
                  _buildConfirmationRow(
                    role == 'student' ? 'Class' : 'Subject/Dept.',
                    role == 'student' ? className : _subjectController.text,
                  ),
                  _buildConfirmationRow(
                    'Date of Birth',
                    dateOfBirth != null
                        ? '${dateOfBirth!.day.toString().padLeft(2, '0')}/${dateOfBirth!.month.toString().padLeft(2, '0')}/${dateOfBirth!.year}'
                        : 'Not selected',
                  ),
                  _buildConfirmationRow('Generated ID', generatedId),
                  const Divider(height: 24),
                  Text(
                    'Parent/Guardian Information:',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF2E7D32)),
                  ),
                  _buildConfirmationRow('Father\'s Name', _fatherNameController.text),
                  _buildConfirmationRow('Father\'s Phone', _fatherPhoneNoController.text),
                  _buildConfirmationRow('Father\'s Occupation', _fatherOccupationController.text),
                  _buildConfirmationRow('Mother\'s Name', _motherNameController.text),
                  _buildConfirmationRow('Mother\'s Phone', _motherPhoneNoController.text),
                  _buildConfirmationRow('Mother\'s Occupation', _motherOccupationController.text),
                  const Divider(height: 24),
                  Text(
                    'Residential Address:',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF2E7D32)),
                  ),
                  _buildConfirmationRow('Street', _streetController.text),
                  _buildConfirmationRow('Landmark', _landmarkController.text),
                  _buildConfirmationRow('City', _cityController.text),
                  _buildConfirmationRow('State', selectedState),
                  _buildConfirmationRow('Country', selectedCountry),
                  _buildConfirmationRow('Postal Code', _postalCodeController.text),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Confirm & Add',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConfirmationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Wider label for confirmation dialog
            child: Text(
              '$label:',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2E7D32),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'N/A' : value, // Show N/A for empty values
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Class',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: className.isEmpty ? null : className,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.school_outlined,
                color: Color(0xFF4CAF50),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF4CAF50),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              hintText: 'Select Class',
              hintStyle: GoogleFonts.inter(
                color: Colors.grey[600],
              ),
            ),
            items: classList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                className = newValue ?? '';
              });
            },
            validator: (value) => value == null || value.isEmpty ? 'Please select a class' : null,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // New _buildDropdownField for generic dropdowns (Gender, Country, State)
  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String? Function(String?) validator,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF4CAF50),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF4CAF50),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              hintText: hintText,
              hintStyle: GoogleFonts.inter(
                color: Colors.grey[600],
              ),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    // Determine screen width for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900; // Define your desktop breakpoint

    return BlocProvider(
      create: (_) => AddUserBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FDF8),
        appBar: AppBar(
          title: Text(
            'Add New School User', // More specific title
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF2E7D32),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF8FDF8),
                Color(0xFFE8F5E8),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 40.0 : 20.0), // More padding for desktop
            child: BlocConsumer<AddUserBloc, AddUserState>(
              listener: (context, state) {
                if (state is AddUserSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'User added successfully!',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      backgroundColor: const Color(0xFF4CAF50),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                  _resetForm();
                } else if (state is AddUserFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Error: ${state.error}',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: const Color(0xFFE53935),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2E7D32).withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Icon(
                                  Icons.person_add,
                                  size: 40,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Create New User',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2E7D32),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Fill in the details below to add a new user to the system.',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Form Card Sections
                        Container(
                          padding: EdgeInsets.all(isDesktop ? 32 : 24), // More padding for desktop
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2E7D32).withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Role Selection
                              Text(
                                'User Role',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2E7D32),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                                  ),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: role,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      role == 'student' ? Icons.school : Icons.person,
                                      color: const Color(0xFF4CAF50),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'student',
                                      child: Text('Student'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'teacher',
                                      child: Text('Teacher'),
                                    ),
                                  ],
                                  onChanged: (value) => setState(() {
                                    role = value!;
                                    if (role == 'teacher') {
                                      className = ''; // Clear class for teachers
                                    } else {
                                      _subjectController.clear(); // Clear subject for students
                                    }
                                  }),
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // --- Personal Information Section ---
                              _buildSectionTitle('Personal Information'),
                              const SizedBox(height: 20),
                              if (isDesktop)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildTextField(
                                        label: 'First Name',
                                        icon: Icons.person_outline,
                                        controller: _firstNameController,
                                        validator: (value) => value!.isEmpty ? 'Enter first name' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildTextField(
                                        label: 'Last Name',
                                        icon: Icons.person_outline,
                                        controller: _lastNameController,
                                        validator: (value) => value!.isEmpty ? 'Enter last name' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildDropdownField(
                                        label: 'Gender',
                                        icon: Icons.transgender,
                                        value: gender,
                                        items: genderOptions,
                                        onChanged: (newValue) {
                                          setState(() {
                                            gender = newValue!;
                                          });
                                        },
                                        validator: (value) => value == null ? 'Select gender' : null,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildTextField(
                                      label: 'First Name',
                                      icon: Icons.person_outline,
                                      controller: _firstNameController,
                                      validator: (value) => value!.isEmpty ? 'Enter first name' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      label: 'Last Name',
                                      icon: Icons.person_outline,
                                      controller: _lastNameController,
                                      validator: (value) => value!.isEmpty ? 'Enter last name' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDropdownField(
                                      label: 'Gender',
                                      icon: Icons.transgender,
                                      value: gender,
                                      items: genderOptions,
                                      onChanged: (newValue) {
                                        setState(() {
                                          gender = newValue!;
                                        });
                                      },
                                      validator: (value) => value == null ? 'Select gender' : null,
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 16),
                              if (isDesktop)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildTextField(
                                        label: 'Email Address',
                                        icon: Icons.email_outlined,
                                        controller: _emailController,
                                        validator: (value) {
                                          if (value!.isEmpty) return 'Enter email';
                                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                            return 'Enter a valid email';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildTextField(
                                        label: 'Phone Number',
                                        icon: Icons.phone_outlined,
                                        controller: _phoneController,
                                        validator: (value) => value!.isEmpty ? 'Enter phone number' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildDateField(
                                        label: 'Date of Birth',
                                        icon: Icons.calendar_today_outlined,
                                        selectedDate: dateOfBirth,
                                        onDateSelected: (date) {
                                          setState(() {
                                            dateOfBirth = date;
                                          });
                                        },
                                        validator: (value) => value == null ? 'Select date of birth' : null,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildTextField(
                                      label: 'Email Address',
                                      icon: Icons.email_outlined,
                                      controller: _emailController,
                                      validator: (value) {
                                        if (value!.isEmpty) return 'Enter email';
                                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                          return 'Enter a valid email';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      label: 'Phone Number',
                                      icon: Icons.phone_outlined,
                                      controller: _phoneController,
                                      validator: (value) => value!.isEmpty ? 'Enter phone number' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDateField(
                                      label: 'Date of Birth',
                                      icon: Icons.calendar_today_outlined,
                                      selectedDate: dateOfBirth,
                                      onDateSelected: (date) {
                                        setState(() {
                                          dateOfBirth = date;
                                        });
                                      },
                                      validator: (value) => value == null ? 'Select date of birth' : null,
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 16),
                              if (isDesktop)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildTextField(
                                        label: role == 'student' ? 'Student ID (Unique)' : 'Teacher ID (Unique)',
                                        icon: Icons.badge_outlined,
                                        controller: _uniqueIdController,
                                        validator: (value) => value!.isEmpty ? 'Enter unique ID' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildTextField(
                                        label: 'Aadhaar Number',
                                        icon: Icons.perm_identity,
                                        controller: _aadhaarNoController,
                                        validator: (value) => value!.isEmpty ? 'Enter Aadhaar number' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: role == 'student'
                                          ? _buildClassDropdown()
                                          : _buildTextField(
                                        label: 'Subject/Department',
                                        icon: Icons.book_outlined,
                                        controller: _subjectController,
                                        validator: (value) => value!.isEmpty ? 'Enter subject/department' : null,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildTextField(
                                      label: role == 'student' ? 'Student ID (Unique)' : 'Teacher ID (Unique)',
                                      icon: Icons.badge_outlined,
                                      controller: _uniqueIdController,
                                      validator: (value) => value!.isEmpty ? 'Enter unique ID' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      label: 'Aadhaar Number',
                                      icon: Icons.perm_identity,
                                      controller: _aadhaarNoController,
                                      validator: (value) => value!.isEmpty ? 'Enter Aadhaar number' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    role == 'student'
                                        ? _buildClassDropdown()
                                        : _buildTextField(
                                      label: 'Subject/Department',
                                      icon: Icons.book_outlined,
                                      controller: _subjectController,
                                      validator: (value) => value!.isEmpty ? 'Enter subject/department' : null,
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 32),

                              // --- Parent/Guardian Information Section ---
                              _buildSectionTitle('Parent/Guardian Information'),
                              const SizedBox(height: 20),
                              if (isDesktop)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildTextField(
                                        label: 'Father\'s Full Name',
                                        icon: Icons.people_outline,
                                        controller: _fatherNameController,
                                        validator: (value) => value!.isEmpty ? 'Enter father\'s name' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildTextField(
                                        label: 'Father\'s Phone Number',
                                        icon: Icons.phone_android,
                                        controller: _fatherPhoneNoController,
                                        validator: (value) => value!.isEmpty ? 'Enter father\'s phone' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildTextField(
                                        label: 'Father\'s Occupation',
                                        icon: Icons.work_outline,
                                        controller: _fatherOccupationController,
                                        validator: (value) => value!.isEmpty ? 'Enter father\'s occupation' : null,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildTextField(
                                      label: 'Father\'s Full Name',
                                      icon: Icons.people_outline,
                                      controller: _fatherNameController,
                                      validator: (value) => value!.isEmpty ? 'Enter father\'s name' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      label: 'Father\'s Phone Number',
                                      icon: Icons.phone_android,
                                      controller: _fatherPhoneNoController,
                                      validator: (value) => value!.isEmpty ? 'Enter father\'s phone' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      label: 'Father\'s Occupation',
                                      icon: Icons.work_outline,
                                      controller: _fatherOccupationController,
                                      validator: (value) => value!.isEmpty ? 'Enter father\'s occupation' : null,
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 16),
                              if (isDesktop)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildTextField(
                                        label: 'Mother\'s Full Name',
                                        icon: Icons.people_outline,
                                        controller: _motherNameController,
                                        validator: (value) => value!.isEmpty ? 'Enter mother\'s name' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildTextField(
                                        label: 'Mother\'s Phone Number',
                                        icon: Icons.phone_android,
                                        controller: _motherPhoneNoController,
                                        validator: (value) => value!.isEmpty ? 'Enter mother\'s phone' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildTextField(
                                        label: 'Mother\'s Occupation',
                                        icon: Icons.work_outline,
                                        controller: _motherOccupationController,
                                        validator: (value) => value!.isEmpty ? 'Enter mother\'s occupation' : null,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildTextField(
                                      label: 'Mother\'s Full Name',
                                      icon: Icons.people_outline,
                                      controller: _motherNameController,
                                      validator: (value) => value!.isEmpty ? 'Enter mother\'s name' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      label: 'Mother\'s Phone Number',
                                      icon: Icons.phone_android,
                                      controller: _motherPhoneNoController,
                                      validator: (value) => value!.isEmpty ? 'Enter mother\'s phone' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      label: 'Mother\'s Occupation',
                                      icon: Icons.work_outline,
                                      controller: _motherOccupationController,
                                      validator: (value) => value!.isEmpty ? 'Enter mother\'s occupation' : null,
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 32),

                              // --- Address Information Section ---
                              _buildSectionTitle('Residential Address'),
                              const SizedBox(height: 20),
                              if (isDesktop)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildTextField(
                                        label: 'Street Address',
                                        icon: Icons.location_on_outlined,
                                        controller: _streetController,
                                        validator: (value) => value!.isEmpty ? 'Enter street address' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildTextField(
                                        label: 'Landmark (Optional)',
                                        icon: Icons.signpost,
                                        controller: _landmarkController,
                                        validator: (value) => null, // Optional field
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildTextField(
                                        label: 'City',
                                        icon: Icons.location_city_outlined,
                                        controller: _cityController,
                                        validator: (value) => value!.isEmpty ? 'Enter city' : null,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildTextField(
                                      label: 'Street Address',
                                      icon: Icons.location_on_outlined,
                                      controller: _streetController,
                                      validator: (value) => value!.isEmpty ? 'Enter street address' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      label: 'Landmark (Optional)',
                                      icon: Icons.signpost,
                                      controller: _landmarkController,
                                      validator: (value) => null, // Optional field
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      label: 'City',
                                      icon: Icons.location_city_outlined,
                                      controller: _cityController,
                                      validator: (value) => value!.isEmpty ? 'Enter city' : null,
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 16),
                              if (isDesktop)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildDropdownField(
                                        label: 'Country',
                                        icon: Icons.public_outlined,
                                        value: selectedCountry,
                                        items: countryList,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedCountry = newValue!;
                                          });
                                        },
                                        validator: (value) => value == null ? 'Select country' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildDropdownField(
                                        label: 'State',
                                        icon: Icons.map_outlined,
                                        value: selectedState,
                                        items: stateList,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedState = newValue!;
                                          });
                                        },
                                        validator: (value) => value == null ? 'Select state' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildTextField(
                                        label: 'Postal Code',
                                        icon: Icons.local_post_office_outlined,
                                        controller: _postalCodeController,
                                        validator: (value) => value!.isEmpty ? 'Enter postal code' : null,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _buildDropdownField(
                                      label: 'Country',
                                      icon: Icons.public_outlined,
                                      value: selectedCountry,
                                      items: countryList,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedCountry = newValue!;
                                        });
                                      },
                                      validator: (value) => value == null ? 'Select country' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDropdownField(
                                      label: 'State',
                                      icon: Icons.map_outlined,
                                      value: selectedState,
                                      items: stateList,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedState = newValue!;
                                        });
                                      },
                                      validator: (value) => value == null ? 'Select state' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      label: 'Postal Code',
                                      icon: Icons.local_post_office_outlined,
                                      controller: _postalCodeController,
                                      validator: (value) => value!.isEmpty ? 'Enter postal code' : null,
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 32),

                              // Submit Button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: state is AddUserLoading
                                      ? null
                                      : () async {
                                    if (_formKey.currentState!.validate()) {
                                      final confirmed = await _showConfirmationDialog();
                                      if (confirmed == true) {
                                        context.read<AddUserBloc>().add(
                                          SubmitUserEvent(
                                            firstName: _firstNameController.text,
                                            lastName: _lastNameController.text,
                                            email: _emailController.text,
                                            phoneNo: _phoneController.text,
                                            className: role == 'student'
                                                ? className
                                                : _subjectController.text,
                                            uniqueId: _uniqueIdController.text,
                                            role: role,
                                            generatedId: _generateUniqueId(),
                                            dateOfBirth: dateOfBirth,
                                            fatherName: _fatherNameController.text,
                                            motherName: _motherNameController.text,
                                            fatherPhoneNo: _fatherPhoneNoController.text,
                                            motherPhoneNo: _motherPhoneNoController.text,
                                            fatherOccupation: _fatherOccupationController.text,
                                            motherOccupation: _motherOccupationController.text,
                                            street: _streetController.text,
                                            city: _cityController.text,
                                            postalcode: _postalCodeController.text,
                                            state: selectedState, // Use selected state
                                            country: selectedCountry, // Use selected country
                                            gender: gender,
                                            landmark: _landmarkController.text,
                                            aadhaarNo: _aadhaarNoController.text,
                                            name: '${_firstNameController.text} ${_lastNameController.text}', // Reconstruct name for the event
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4CAF50),
                                    foregroundColor: Colors.white,
                                    elevation: 4,
                                    shadowColor: const Color(0xFF4CAF50).withOpacity(0.4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: state is AddUserLoading
                                      ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                      : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.add_circle_outline),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Add User',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.grey.shade300, thickness: 1, height: 20),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 8),
        Divider(color: Colors.grey.shade300, thickness: 1, height: 20),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType, // Apply keyboard type
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF4CAF50),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF4CAF50),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required IconData icon,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
    required String? Function(DateTime?) validator, // Added validator for date
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now().subtract(const Duration(days: 6570)), // Default to 18 years ago
                firstDate: DateTime(1950),
                lastDate: DateTime.now().subtract(const Duration(days: 18 * 365)), // Students typically under 18, set max reasonable DOB
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF4CAF50),
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.black,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                onDateSelected(picked);
              }
            },
            child: FormField<DateTime>(
              validator: (val) => validator(selectedDate),
              builder: (FormFieldState<DateTime> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      icon,
                      color: const Color(0xFF4CAF50),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: const Color(0xFF4CAF50).withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: const Color(0xFF4CAF50).withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF4CAF50),
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    errorText: state.errorText, // Display validation error
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate != null
                              ? '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}'
                              : 'Select Date',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: selectedDate != null ? Colors.black87 : Colors.grey[600],
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}