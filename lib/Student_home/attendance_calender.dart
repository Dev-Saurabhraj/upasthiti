import 'package:campusbuzz/Student_home/Attendence_fetch_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceCalender extends StatefulWidget {
  final String generatedId;
  final String role;

  AttendanceCalender({super.key, required this.generatedId, required this.role});

  @override
  State<AttendanceCalender> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<AttendanceCalender>
    with AutomaticKeepAliveClientMixin {
  late Future<Map<String, bool>> _myFuture;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    print('creating future');
    _myFuture = AttendanceFetchServices.getStudentAttendanceHistory(widget.generatedId);
  }

  @override
  bool get wantKeepAlive => true;
  Widget _buildLegend() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem('Present', Colors.green, Icons.check_circle_outline),
          _buildLegendItem('Absent', Colors.red, Icons.highlight_off),
          _buildLegendItem('No Data', Colors.grey, Icons.help_outline),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Attendance',
          style: GoogleFonts.nunito(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        leading: widget.role == 'student'
            ? Container()
            : IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),
              ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<Map<String, bool>>(
              future: _myFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading attendance data...',
                            style: GoogleFonts.nunito(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Error loading attendance data',
                            style: GoogleFonts.nunito(color: Colors.red[700]),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final attendanceData = snapshot.data ?? {};

                return Column(
                  children: [
                    _buildLegend(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TableCalendar<dynamic>(
                            firstDay: DateTime(2025, 1, 1),
                            lastDay: DateTime.now(),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            calendarStyle: CalendarStyle(
                              outsideDaysVisible: false,
                              weekendTextStyle: GoogleFonts.nunito(
                                color: Colors.red[400],
                                fontWeight: FontWeight.w600,
                              ),
                              holidayTextStyle: GoogleFonts.nunito(
                                color: Colors.red[400],
                                fontWeight: FontWeight.w600,
                              ),
                              defaultTextStyle: GoogleFonts.nunito(
                                fontWeight: FontWeight.w500,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Color(0xFF667eea),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF667eea).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),

                              todayDecoration: BoxDecoration(
                                color: Color(0xFF764ba2).withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                              markerDecoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextStyle: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              leftChevronIcon: Icon(
                                Icons.chevron_left_rounded,
                                color: Color(0xFF667eea),
                                size: 35,
                              ),
                              rightChevronIcon: Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFF667eea),
                                size: 35,
                              ),
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: GoogleFonts.nunito(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                              weekendStyle: GoogleFonts.nunito(
                                fontWeight: FontWeight.w600,
                                color: Colors.red[400],
                              ),
                            ),
                            calendarBuilders: CalendarBuilders(
                              markerBuilder: (context, date, events) {
                                final dateString = DateFormat('yyyy-MM-dd').format(date);
                                final status = attendanceData[dateString];

                                return Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(status),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _getStatusBorderColor(status),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 18,),
                                        Icon(
                                          _getStatusIcon(status),
                                          color: _getStatusIconColor(status),
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                ),
                    SizedBox(height: 20),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(bool? status) {
    if (status == true) return Colors.green.withOpacity(0.1);
    if (status == false) return Colors.red.withOpacity(0.1);
    return Colors.grey.withOpacity(0.1);
  }

  Color _getStatusBorderColor(bool? status) {
    if (status == true) return Colors.green.withOpacity(0.3);
    if (status == false) return Colors.red.withOpacity(0.3);
    return Colors.grey.withOpacity(0.3);
  }

  IconData _getStatusIcon(bool? status) {
    if (status == true) return Icons.check;
    if (status == false) return Icons.close;
    return Icons.help_outline;
  }

  Color _getStatusIconColor(bool? status) {
    if (status == true) return Colors.green;
    if (status == false) return Colors.red;
    return Colors.grey;
  }
}