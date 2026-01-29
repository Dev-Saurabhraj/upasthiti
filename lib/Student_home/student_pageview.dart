import 'package:campusbuzz/Notices/Bloc/notice_bloc.dart';
import 'package:campusbuzz/Notices/noticePage/notice_page.dart';
import 'package:campusbuzz/Profile_presentations/profile_presentation.dart';
import 'package:campusbuzz/Student_home/Student_home.dart';
import 'package:campusbuzz/Student_home/attendance_calender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Profile_presentations/bloc/profile_bloc/profile_bloc.dart';
import '../Profile_presentations/profile_firebase_service/profile_firebase_service.dart';

class StudentPageview extends StatefulWidget {
  final String generatedId;
  final String role;
  final String username;

  const StudentPageview(
      {super.key, required this.generatedId, required this.role, required this.username});

  @override
  State<StudentPageview> createState() => _StudentPageviewState();
}

class _StudentPageviewState extends State<StudentPageview> {
  int _currentIndex = 0;
  final PageController _pageviewController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ProfileBloc>(
              create: (context) => ProfileBloc(UserRepository())),
          BlocProvider<NoticeBloc>(
              create: (context) =>
                  NoticeBloc(firestore: FirebaseFirestore.instance))
        ],
        child: PageView(
          controller: _pageviewController,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          children: [
            StudentHome(generatedId: widget.generatedId, role: widget.role, username: widget.username),
            AttendanceCalender(generatedId: widget.generatedId, role: widget.role),
            NoticePage(userId:widget.generatedId, role:widget.role),
            ProfilePage(generatedId: widget.generatedId, userRole: widget.role),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        iconSize: 25,
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageviewController.jumpToPage(index);
          setState(() => _currentIndex = index);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.class_outlined), label: 'Attendance'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Announcement'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}