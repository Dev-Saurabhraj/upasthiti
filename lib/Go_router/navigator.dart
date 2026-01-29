import 'package:campusbuzz/HelpAndSupport/presentation/help_and_support.dart';
import 'package:campusbuzz/Manage_students/Presentation/student_manager_home_page.dart';
import 'package:campusbuzz/Notices/widget/notice_card.dart';
import 'package:campusbuzz/PersistentView/Bloc/persistent_bloc.dart';
import 'package:campusbuzz/PersistentView/View/persistent_ui.dart';
import 'package:campusbuzz/Profile_presentations/pre_profile.dart';
import 'package:campusbuzz/Student_home/attendance_calender.dart';
import 'package:campusbuzz/Student_home/student_pageview.dart';
import 'package:campusbuzz/admin_panel/presentation/admin_dashboard.dart';
import 'package:campusbuzz/presentation/add_user_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../Authentication/SingInUi/login.dart';
import '../Authentication/Signup/signup.dart';
import '../Notices/Bloc/notice_bloc.dart';
import '../Notices/Bloc/notice_event.dart';
import '../Notices/noticePage/add_notice_page.dart';
import '../Notices/noticePage/notice_page.dart';
import '../Profile_presentations/Edit_profile/edit_profile.dart';
import '../Profile_presentations/bloc/profile_bloc/profile_bloc.dart';
import '../Profile_presentations/profile_firebase_service/profile_firebase_service.dart';
import '../Profile_presentations/profile_presentation.dart';
import '../admin_panel/Firebase_service/firebase_service.dart';
import '../admin_panel/bloc/admin_bloc.dart';
import '../presentation/HomePage.dart';

GoRouter navigator = GoRouter(routes: [
  GoRoute(
    path: '/',
    name: 'HomePage',
    builder: (context, state) => const Homepage(),
  ),
  GoRoute(
    path: '/login',
    name: 'login',
    builder: (context, state) => Login(),
  ),
  GoRoute(
    path: '/signup',
    name: 'Signup',
    builder: (context, state) => Signup(),
  ),
  GoRoute(
    path: '/help_and_support',
    name: 'help_and_support',
    builder: (context, state) => HelpAndSupport(),
  ),
  GoRoute(
    path: '/add_user_page',
    name: 'add_user_page',
    builder: (context, state) => AddUserPage(),
  ),
  GoRoute(
    path: '/student_manager_home_page',
    name: 'student_manager_home_page',
    builder: (context, state) => StudentManagerHomePage(),
  ),
  GoRoute(
      path: '/attendance_calender',
      name: 'attendance_calender',
      builder: (context, state) {
        final generatedId = state.uri.queryParameters['generatedId'].toString();
        final role = state.uri.queryParameters['role'].toString();
        return AttendanceCalender(
          generatedId: generatedId,
          role: role,
        );
      }),
  GoRoute(
      path: '/student_pageview',
      name: 'student_pageview',
      builder: (context, state) {
        final generatedId = state.uri.queryParameters['generatedId'].toString();
        final role = state.uri.queryParameters['role'].toString();
        final username = state.uri.queryParameters['username'].toString();
        return StudentPageview(
          generatedId: generatedId,
          role: role,
          username: username,
        );
      }),
  GoRoute(
    path: '/admin_dashboard',
    name: 'admin_dashboard',
    builder: (context, state) => BlocProvider(
      create: (context) =>
          AttendanceBloc(AttendanceService())..add(LoadDashboardData()),
      child: AdminDashboard(
        generateId: state.uri.queryParameters['generatedId']!.toString(),
        role: state.uri.queryParameters['role']!.toString(),
        username: state.uri.queryParameters['username'].toString(),
      ),
    ),
  ),

  GoRoute(
    path: '/profile_presentation',
    name: 'profile_presentation',
    builder: (context, state) => BlocProvider(
      create: (context) => ProfileBloc(UserRepository()),
      child: ProfilePage(
          generatedId: state.uri.queryParameters['uid']!.toString(),
          userRole: state.uri.queryParameters['role']!.toString()),
    ),
  ),
  GoRoute(
    path: '/edit_profile',
    name: 'edit_profile',
    builder: (context, state) => EditProfilePage(
        uniqueId: state.uri.queryParameters['uniqueId'].toString()),
  ),
  GoRoute(
    path: '/notice_page',
    name: 'notice_page',
    builder: (context, state) {
      final userId = state.uri.queryParameters['userId'];
      final role = state.uri.queryParameters['role'];

      if (userId == null || role == null) {
        return const Scaffold(
          body: Center(
            child: Text("Missing user ID or role"),
          ),
        );
      }

      return BlocProvider(
        create: (_) => NoticeBloc(firestore: FirebaseFirestore.instance)
          ..add(FetchNotices()),
        child: NoticePage(userId: userId, role: role),
      );
    },
  ),
  GoRoute(
    path: '/add_notice',
    name: 'add_notice',
    builder: (context, state) {
      final adminId = state.uri.queryParameters['adminId'];
      if (adminId == null) {
        return const Scaffold(
          body: Center(child: Text('Missing admin ID')),
        );
      }

      return AddNoticePage(adminId: adminId);
    },
  ),
  GoRoute(
      path: '/notice_card',
      name: 'notice_card',
      builder: (context, state) {
        final title = state.uri.queryParameters['title'].toString();
        final description = state.uri.queryParameters['description'].toString();
        final date = state.uri.queryParameters['date'].toString();
        final view = state.uri.queryParameters['view'].toString();
        return NoticeCard(
          title: title,
          description: description,
          date: date,
          view: view,
        );
      }),
  GoRoute(
      path: '/persistent_ui',
      name: 'persistent_ui',
      builder: (context, state) {
        final generatedId = state.uri.queryParameters['generatedId'].toString();
        final role = state.uri.queryParameters['role'].toString();
        return BlocProvider(
          create: (context) => PersistentBloc(),
          child: PersistentUi(
            generatedId: generatedId,
            role: role,
          ),
        );
      }),
  GoRoute(path: '/pre_profile',
  name: 'pre_profile'
  ,builder: (context, state) {
        final generatedId=  state.uri.queryParameters['uid']!.toString();
        final userRole = state.uri.queryParameters['role']!.toString();
    return PreProfile(generatedId: generatedId, userRole: userRole);
  })
]);
