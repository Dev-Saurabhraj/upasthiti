import 'package:campusbuzz/Manage_students/Presentation/manage_page.dart';
import 'package:flutter/material.dart';
import '../../Drawer/drawer_content.dart';

class StudentManagerHomePage extends StatefulWidget {
  const StudentManagerHomePage({super.key});

  @override
  State<StudentManagerHomePage> createState() => _StudentManagerHomePageState();
}

class _StudentManagerHomePageState extends State<StudentManagerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.grey.shade300,
          child: Container(
            height: 200,
            width: 200,
            child: ManagementPage(),
          ),
        ),
      ),
    );
  }
}
