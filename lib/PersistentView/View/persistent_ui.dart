import 'package:campusbuzz/HelpAndSupport/presentation/help_and_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../HelpAndSupport/bloc/help_and_support_bloc.dart';
import '../../Manage_students/Presentation/manage_page.dart';
import '../../Notices/Bloc/notice_bloc.dart';
import '../../Notices/Bloc/notice_event.dart';
import '../../Notices/noticePage/notice_page.dart';
import '../../Profile_presentations/bloc/profile_bloc/profile_bloc.dart';
import '../../Profile_presentations/profile_firebase_service/profile_firebase_service.dart';
import '../../Profile_presentations/profile_presentation.dart';
import '../../admin_panel/Firebase_service/firebase_service.dart';
import '../../admin_panel/bloc/admin_bloc.dart';
import '../../admin_panel/presentation/admin_dashboard.dart';
import '../Bloc/persistent_bloc.dart';
import '../Bloc/persistent_event.dart';
import '../Bloc/persistent_state.dart';

class PersistentUi extends StatefulWidget {
  final String generatedId;
  final String role;
  const PersistentUi({super.key, required this.generatedId, required this.role});

  @override
  createState() => PersistentUiState();
}

class PersistentUiState extends State<PersistentUi> {
  @override
  Widget build(BuildContext context) {
    List<NavigationBar> pages = [
      NavigationBar(
          Icons.dashboard_rounded,
          "Dashboard",
          BlocProvider(
            create: (context) =>
            AttendanceBloc(AttendanceService())..add(LoadDashboardData()),
            child: AdminDashboard(
              generateId: widget.generatedId,
              role: widget.role,
              username: 'saurabh',
            ),
          )),
      NavigationBar(
          Icons.campaign_rounded,
          "Announcements",
          BlocProvider(
            create: (_) => NoticeBloc(firestore: FirebaseFirestore.instance)
              ..add(FetchNotices()),
            child: NoticePage(userId: widget.generatedId, role: widget.role),
          )),
      NavigationBar(
          Icons.person_rounded,
          "Profile",
          BlocProvider(
            create: (context) => ProfileBloc(UserRepository()),
            child: ProfilePage(generatedId: widget.generatedId, userRole: widget.role),
          )),
      NavigationBar(
          Icons.group_rounded, "Manage Students", ManagementPage()),

      NavigationBar(Icons.help_outline_rounded, "Help & Support", HelpAndSupport()),
    ];

    return BlocBuilder<PersistentBloc, PersistentState>(
        builder: (BuildContext context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(2, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.green.shade400, Colors.green.shade600],
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 24,
                                  color: Colors.green.shade600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Saurabh',
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  Text(
                                    widget.role.toUpperCase(),
                                    style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: 1,
                        color: Colors.grey.shade200,
                      ),

                      const SizedBox(height: 8),

                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: pages.length,
                          itemBuilder: (BuildContext context, int index) {
                            final isSelected = (index == state.selectedIndex);

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              child: Material(
                                borderRadius: BorderRadius.circular(12),
                                color: isSelected
                                    ? Colors.green.shade50
                                    : Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    context.read<PersistentBloc>().add(
                                      PersistentEvent(index),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.green.shade100
                                                : Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            pages[index].icon,
                                            size: 20,
                                            color: isSelected
                                                ? Colors.green.shade700
                                                : Colors.grey.shade600,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Text(
                                            pages[index].label,
                                            style: GoogleFonts.nunito(
                                              fontSize: 15,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? Colors.green.shade700
                                                  : Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          Container(
                                            width: 4,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade600,
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              height: 1,
                              color: Colors.grey.shade200,
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () {
                                FirebaseAuth.instance.signOut();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    showCloseIcon: true,
                                    closeIconColor: Colors.white,
                                    content: Text('LogOut Successfully'),
                                    duration: Duration(seconds: 3),
                                    elevation: 4,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                                GoRouter.of(context).pushNamed('login');
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.logout_rounded,
                                    size: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Logout',
                                    style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade100,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  pages[state.selectedIndex].icon,
                                  size: 24,
                                  color: Colors.green.shade600,
                                ),
                              ),
                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pages[state.selectedIndex].label,
                                      style: GoogleFonts.nunito(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      pages[state.selectedIndex].label,
                                      style: GoogleFonts.nunito(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: pages[state.selectedIndex].child,
                        ),
                      ],
                    )),
              ],
            ),
          );
        });
  }
}

class NavigationBar {
  final IconData icon;
  final String label;
  final Widget child;

  NavigationBar(this.icon, this.label, this.child);
}