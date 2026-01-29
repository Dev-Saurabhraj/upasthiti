import 'package:campusbuzz/Student_home/Attendence_fetch_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentHome extends StatefulWidget {
  final String generatedId;
  final String role;
  final String username;

  const StudentHome(
      {super.key,
      required this.generatedId,
      required this.role,
      required this.username});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome>
    with AutomaticKeepAliveClientMixin {
  late Future<Map<String, bool>> _attendanceFuture;

  @override
  void initState() {
    super.initState();
    _attendanceFuture =
        AttendanceFetchServices.getStudentAttendanceHistory(widget.generatedId);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final List<String> usernameParts = widget.username.split(' ');
    final String displayFirstName = usernameParts.isNotEmpty
        ? '${usernameParts[0][0].toUpperCase()}${usernameParts[0].substring(1)}'
        : '';
    final String displayLastName = usernameParts.length > 1
        ? '${usernameParts.last[0].toUpperCase()}${usernameParts.last.substring(1)}'
        : '';
    final String fullDisplayName = '$displayFirstName $displayLastName'.trim();

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade700,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        size: 40, color: Colors.blueAccent.shade700),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    fullDisplayName,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${widget.generatedId}',
                    style: GoogleFonts.nunito(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100
                      ,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Icon(Icons.home_outlined, color: Colors.orange.shade800,)),

              title: Text('Home', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100
                    ,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: const Icon(Icons.calendar_month_outlined, color: Colors.deepPurple,)),
              title: Text('Attendance Calendar',
                  style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                GoRouter.of(context).pushNamed('attendance_calender',
                    queryParameters: {
                      'generatedId': widget.generatedId,
                      'role': widget.role
                    });
              },
            ),
            const Divider(),
            ListTile(
              leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.shade100
                    ,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.logout_outlined, color: Colors.red,)),
              title: Text('Logout', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                GoRouter.of(context).go('/login');
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF2F5F9),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 12),
                Builder(
                  builder: (context) => IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(
                      Icons.menu_rounded,
                      size: 30,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Attendance',
                  style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                      fontSize:23,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blueAccent.withOpacity(0.15),
                  child: Text(
                    displayFirstName.isNotEmpty
                        ? displayFirstName[0].toUpperCase()
                        : '',
                    style: GoogleFonts.nunito(
                        color: Colors.blueAccent.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                const SizedBox(width: 20),

              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 1, left: 20, right: 20, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello,\n$displayFirstName!',
                            style: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                fontSize: 32,
                                color: Colors.blueGrey.shade800,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Student ID: ${widget.generatedId}',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: _attendanceFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: CircularProgressIndicator(
                                color: Colors.greenAccent.shade700,
                                strokeWidth: 3,
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Text(
                                'Error loading attendance: ${snapshot.error}',
                                style: GoogleFonts.nunito(
                                    color: Colors.red.shade600),
                              ),
                            ),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Text(
                                'No attendance data available yet.',
                                style: GoogleFonts.nunito(
                                    color: Colors.grey.shade600),
                              ),
                            ),
                          );
                        }

                        final summary = AttendanceFetchServices
                            .calculateYearlyAttendanceSummary(snapshot.data!);

                        final double attendancePercentage = summary["total"]! >
                                0
                            ? (summary["present"]! / summary["total"]! * 100)
                            : 0.0;

                        return Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff467bdf),
                                Color(0xff43dd67),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff78ea66).withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.analytics_outlined,
                                      color: Colors.white, size: 28),
                                  SizedBox(width: 12),
                                  Text(
                                    'Attendance Overview',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatCard(
                                      'Present',
                                      summary['present'].toString(),
                                      Colors.green,
                                      Icons.check_circle),
                                  _buildStatCard(
                                      'Absent',
                                      summary['absent'].toString(),
                                      Colors.red,
                                      Icons.cancel),
                                  _buildStatCard(
                                      'Percentage',
                                      '${attendancePercentage.toStringAsFixed(1)}%',
                                      attendancePercentage >= 75
                                          ? Colors.green
                                          : Colors.orange,
                                      Icons.percent),
                                ],
                              ),
                              SizedBox(height: 20),
                              Container(
                                height: 1,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Calculation based on start of academic year to till today.',
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "$count",
          style: GoogleFonts.inter(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}
