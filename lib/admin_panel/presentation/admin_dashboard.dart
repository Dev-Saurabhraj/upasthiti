import 'package:campusbuzz/Drawer/drawer_content.dart';
import 'package:campusbuzz/Student_home/Student_home.dart';
import 'package:campusbuzz/Student_home/student_pageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admin_bloc.dart';
import '../widgets/class_selector.dart';
import '../widgets/date_picker.dart';
import '../widgets/stats_card.dart';
import '../widgets/student_list.dart';

class AdminDashboard extends StatelessWidget {
  final String generateId;
  final String role;
  final String username;

  const AdminDashboard(
      {super.key,
      required this.generateId,
      required this.role,
      required this.username});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return role == 'student'
        ? StudentPageview(
            generatedId: generateId, role: role, username: username)
        : Scaffold(
            drawer: Drawer(
              child: DrawerContent(
                generatedId: generateId,
                userRole: role,
              ),
            ),
            backgroundColor: Color(0xFFF8F9FA),
            appBar: ( width > 600)
                ? null
                : _buildAppBar(context),
            body: BlocBuilder<AttendanceBloc, AttendanceState>(
              builder: (context, state) {
                if (state is AttendanceLoading) {
                  return _buildLoadingState();
                } else if (state is AttendanceLoaded) {
                  return _buildLoadedState(context, state);
                } else if (state is AttendanceError) {
                  return _buildErrorState(context, state.message);
                }
                return _buildInitialState(context);
              },
            ),
          );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double boxSize = width < 600
        ? 20
        : width < 1024
            ? 24
            : 28;
    double valueFontSize = width < 600
        ? 20
        : width < 1024
            ? 24
            : 26;
    double titleFontSize = width < 600
        ? 12
        : width < 1024
            ? 13
            : 14;
    return AppBar(
      elevation: 0,
      toolbarHeight: 80,
      title: Row(
        children: [
          InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.school, color: Colors.white, size: boxSize),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Attendance Manager',
                style: TextStyle(
                  fontSize: valueFontSize / 1.2,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Attendance Management System',
                style: TextStyle(
                  fontSize: titleFontSize,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF4CAF50)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF2E7D32).withOpacity(0.3),
              blurRadius: 5,
              offset: Offset(0, 8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8F9FA),
            Color(0xFFE3F2FD),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Loading dashboard...',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, AttendanceLoaded state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1000;
        final isTablet = constraints.maxWidth > 600;

        if (isDesktop) {
          return _buildDesktopLayout(context, state);
        } else if (isTablet) {
          return _buildTabletLayout(context, state);
        } else {
          return _buildMobileLayout(context, state);
        }
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AttendanceLoaded state) {
    return Row(
      children: [
        // Enhanced Sidebar
        SingleChildScrollView(
          child: Container(
            width: 320,
            decoration: BoxDecoration(
              // i have changed this color temp
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 5,
                  offset: Offset(4, 0),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 5,
                  offset: Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2E7D32).withOpacity(0.05),
                        Color(0xFF4CAF50).withOpacity(0.02),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      DatePickerWidget(
                        selectedDate: state.selectedDate,
                        onDateChanged: (date) {
                          context
                              .read<AttendanceBloc>()
                              .add(FilterAttendance(date));
                        },
                      ),
                      SizedBox(height: 24),
                      ClassSelector(
                        classes: state.classes,
                        selectedClass: state.selectedClass,
                        onClassSelected: (classId) {
                          context
                              .read<AttendanceBloc>()
                              .add(SelectClass(classId));
                        },
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 5,
                              offset: Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2E7D32).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.analytics,
                                    color: Color(0xFF2E7D32),
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Quick Stats',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E2E2E),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            _buildQuickStatCard(
                              'Total Classes',
                              state.classes.length.toString(),
                              Icons.class_,
                              Color(0xFF2196F3),
                            ),
                            SizedBox(height: 12),
                            _buildQuickStatCard(
                              'Present Today',
                              state.stats.presentToday.toString(),
                              Icons.check_circle,
                              Color(0xFF4CAF50),
                            ),
                            SizedBox(height: 12),
                            _buildQuickStatCard(
                              'Absent Today',
                              state.stats.absentToday.toString(),
                              Icons.cancel,
                              Color(0xFFF44336),
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
        ),
        // Main Content
        Expanded(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                _buildStatsRow(state.stats),
                SizedBox(height: 32),
                Expanded(
                  child: StudentList(
                    students: state.students,
                    onAttendanceChanged: (studentId, isPresent) {
                      context.read<AttendanceBloc>().add(
                            UpdateAttendance(studentId, isPresent),
                          );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, AttendanceLoaded state) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DatePickerWidget(
                  selectedDate: state.selectedDate,
                  onDateChanged: (date) {
                    context.read<AttendanceBloc>().add(FilterAttendance(date));
                  },
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: ClassSelector(
                  classes: state.classes,
                  selectedClass: state.selectedClass,
                  onClassSelected: (classId) {
                    context.read<AttendanceBloc>().add(SelectClass(classId));
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          _buildStatsRow(state.stats),
          SizedBox(height: 24),
          Expanded(
            child: StudentList(
              students: state.students,
              onAttendanceChanged: (studentId, isPresent) {
                context.read<AttendanceBloc>().add(
                      UpdateAttendance(studentId, isPresent),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AttendanceLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DatePickerWidget(
            selectedDate: state.selectedDate,
            onDateChanged: (date) {
              context.read<AttendanceBloc>().add(FilterAttendance(date));
            },
          ),
          const SizedBox(height: 20),
          ClassSelector(
            classes: state.classes,
            selectedClass: state.selectedClass,
            onClassSelected: (classId) {
              context.read<AttendanceBloc>().add(SelectClass(classId));
            },
          ),
          const SizedBox(height: 20),
          _buildStatsGrid(state.stats, context),
          const SizedBox(height: 20),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: StudentList(
              students: state.students,
              onAttendanceChanged: (studentId, isPresent) {
                context.read<AttendanceBloc>().add(
                      UpdateAttendance(studentId, isPresent),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(AttendanceStats stats) {
    return Row(
      children: [
        Expanded(
          child: StatsCard(
            title: 'Total Students',
            value: stats.totalStudents.toString(),
            icon: Icons.people,
            color: Color(0xFF2196F3),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: StatsCard(
            title: 'Present Today',
            value: stats.presentToday.toString(),
            icon: Icons.check_circle,
            color: Color(0xFF4CAF50),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: StatsCard(
            title: 'Absent Today',
            value: stats.absentToday.toString(),
            icon: Icons.cancel,
            color: Color(0xFFF44336),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: StatsCard(
            title: 'Attendance Rate',
            value: '${stats.attendanceRate.toStringAsFixed(1)}%',
            icon: Icons.analytics,
            color: Color(0xFF9C27B0),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(AttendanceStats stats, context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        StatsCard(
          title: 'Total Students',
          value: stats.totalStudents.toString(),
          icon: Icons.people,
          color: Color(0xFF2196F3),
        ),
        StatsCard(
          title: 'Present Today',
          value: stats.presentToday.toString(),
          icon: Icons.check_circle,
          color: Color(0xFF4CAF50),
        ),
        StatsCard(
          title: 'Absent Today',
          value: stats.absentToday.toString(),
          icon: Icons.cancel,
          color: Color(0xFFF44336),
        ),
        StatsCard(
          title: 'Attendance Rate',
          value: '${stats.attendanceRate.toStringAsFixed(1)}%',
          icon: Icons.analytics,
          color: Color(0xFF9C27B0),
        ),
      ],
    );
  }

  Widget _buildQuickStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E2E2E),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8F9FA),
            Color(0xFFFFEBEE),
          ],
        ),
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red[400],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              if (message.contains('No classes found'))
                ElevatedButton(
                  onPressed: () {
                    context.read<AttendanceBloc>().add(InitializeSampleData());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E7D32),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Initialize Sample Data',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8F9FA),
            Color(0xFFE8F5E8),
          ],
        ),
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF2E7D32).withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.school,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Welcome to EduTrack Admin',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Your comprehensive attendance management solution',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF2E7D32).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Ready to get started',
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
