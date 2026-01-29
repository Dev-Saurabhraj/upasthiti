// student_edit_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../Constants/edit_profile_constant.dart';
import '../bloc/Edit_Profile_bloc/edit_profile_bloc.dart';
import '../bloc/Edit_Profile_bloc/edit_profile_event.dart';
import '../bloc/Edit_Profile_bloc/edit_profile_state.dart';
import '../profile_firebase_service/edit_profile_firebase_service.dart';

class EditProfilePage extends StatelessWidget {
  final String uniqueId;

  const EditProfilePage({Key? key, required this.uniqueId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentEditBloc(
        studentRepository: StudentRepository(),
      )..add(LoadStudentEvent(uniqueId)),
      child: StudentEditView(uniqueId: uniqueId),
    );
  }
}

class StudentEditView extends StatefulWidget {
  final String uniqueId;

  const StudentEditView({Key? key, required this.uniqueId}) : super(key: key);

  @override
  State<StudentEditView> createState() => _StudentEditViewState();
}

class _StudentEditViewState extends State<StudentEditView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _classNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _generatedIdController = TextEditingController();
  final _classIdController = TextEditingController();

  bool _isActive = true;
  String _role = 'student';
  DateTime? _selectedDate;
  String? _selectedClass;
  List<ClassModel> _classes = [];
  bool _isLoadingClasses = true;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _classNameController.dispose();
    _dateOfBirthController.dispose();
    _generatedIdController.dispose();
    _classIdController.dispose();
    super.dispose();
  }

  Future<void> _loadClasses() async {
    try {
      final classes = await context.read<StudentEditBloc>().studentRepository.getClasses();
      setState(() {
        // Remove duplicates based on className
        _classes = classes.cast<ClassModel>()
            .fold<List<ClassModel>>([], (uniqueClasses, classModel) {
          if (!uniqueClasses.any((cls) => cls.className == classModel.className)) {
            uniqueClasses.add(classModel);
          }
          return uniqueClasses;
        });
        _isLoadingClasses = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingClasses = false;
      });
      print('Error loading classes: $e');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load classes: $e'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  void _populateFormFields(StudentModel student) {
    _nameController.text = student.name;
    _emailController.text = student.email;
    _phoneController.text = student.phoneNo;
    _classNameController.text = student.className;
    _generatedIdController.text = student.generatedId;
    _classIdController.text = student.classId;
    _role = student.role;
    _isActive = student.isActive;

    // Check if the student's class exists in the available classes
    final classExists = _classes.any((cls) => cls.className == student.className);

    if (classExists) {
      _selectedClass = student.className;
    } else {
      // Add the missing class to the dropdown temporarily
      _classes.add(ClassModel(
        className: student.className,
        classId: student.classId,
      ));
      _selectedClass = student.className;

      // Show a warning to the user
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Class "${student.className}" was added to the list as it was missing'),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      });
    }

    if (student.dateOfBirth != null) {
      try {
        _selectedDate = DateTime.parse(student.dateOfBirth!);
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
  }
  void _onClassChanged(String? className) {
    if (className != null) {
      setState(() {
        _selectedClass = className;
        _classNameController.text = className;


        final selectedClassModel = _classes.firstWhere(
              (cls) => cls.className == className,
          orElse: () => ClassModel(className: className, classId: ''),
        );
        _classIdController.text = selectedClassModel.documentId!;
      });
    }
  }

  void _onUpdatePressed() {

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No student data loaded. Please try refreshing the page.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student email not loaded. Please refresh and try again.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {

      context.read<StudentEditBloc>().add(
        UpdateStudentEvent(
          uniqueId: widget.uniqueId,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNo: _phoneController.text.trim(),
          className: _classNameController.text.trim(),
          classId: _classIdController.text.trim(),
          dateOfBirth: _selectedDate?.toIso8601String(),
          role: _role,
          isActive: _isActive,
        ),
      );
    } else {
      print('❌ Form validation failed');
    }
  }


  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF22c55e),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        title: const Text(
          'Edit Student',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF22c55e),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF22c55e), Color(0xFF16a34a)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: BlocConsumer<StudentEditBloc, StudentEditState>(
        listener: (context, state) {
          if (!mounted) return;

          if (state is StudentEditLoaded) {
            _populateFormFields(state.student);
          } else if (state is StudentEditSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFF22c55e),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
            GoRouter.of(context).go('/student_manager_home_page');
          } else if (state is StudentEditFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red[600],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is StudentEditLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22c55e)),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 20),
                  _buildFormCard(),
                  const SizedBox(height: 24),
                  _buildUpdateButton(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF22c55e), Color(0xFF16a34a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22c55e).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.person_outline,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          const Text(
            'Student Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Unique ID: ${widget.uniqueId}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF22c55e).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter student name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _phoneController,
            label: 'Phone Number',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter phone number';
              }
              if (value.length < 10) {
                return 'Phone number must be at least 10 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildClassDropdown(),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _classIdController,
            label: 'Class ID',
            icon: Icons.tag,
            enabled: false,
          ),
          const SizedBox(height: 20),
          _buildDateField(),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _generatedIdController,
            label: 'Generated ID',
            icon: Icons.badge,
            enabled: false,
          ),
          const SizedBox(height: 20),
          _buildRoleDropdown(),
          const SizedBox(height: 20),
          _buildActiveSwitch(),
        ],
      ),
    );
  }

  Widget _buildClassDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedClass,
      onChanged: _onClassChanged,
      decoration: InputDecoration(
        labelText: 'Class',
        prefixIcon: const Icon(Icons.class_, color: Color(0xFF22c55e)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF22c55e), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: _isLoadingClasses
          ? [
        const DropdownMenuItem(
          value: null,
          child: Text('Loading classes...'),
        )
      ]
          : _classes
          .map((classModel) => classModel.className)
          .toSet() // Remove duplicates
          .map((className) {
        return DropdownMenuItem(
          value: className,
          child: Text(className),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please select a class';
        }
        return null;
      },
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF22c55e)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF22c55e), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
      ),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dateOfBirthController,
      readOnly: true,
      onTap: _selectDate,
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF22c55e)),
        suffixIcon: const Icon(Icons.arrow_drop_down, color: Color(0xFF22c55e)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF22c55e), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please select date of birth';
        }
        return null;
      },
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      value: _role,
      onChanged: (value) => setState(() => _role = value!),
      decoration: InputDecoration(
        labelText: 'Role',
        prefixIcon: const Icon(Icons.work, color: Color(0xFF22c55e)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF22c55e), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: ['student', 'teacher', 'admin'].map((role) {
        return DropdownMenuItem(
          value: role,
          child: Text(role.toUpperCase()),
        );
      }).toList(),
    );
  }

  Widget _buildActiveSwitch() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.toggle_on, color: Color(0xFF22c55e)),
              SizedBox(width: 12),
              Text(
                'Active Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Switch(
            value: _isActive,
            onChanged: (value) => setState(() => _isActive = value),
            activeColor: const Color(0xFF22c55e),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(StudentEditState state) {
    final isUpdating = state is StudentEditUpdating;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF22c55e), Color(0xFF16a34a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22c55e).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isUpdating ? null : _onUpdatePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isUpdating
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
        )
            : const Text(
          'Update Student',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

