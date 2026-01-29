import 'package:campusbuzz/presentation/add_user_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ManagementPage extends StatefulWidget {
  const ManagementPage({super.key});

  @override
  _ManagementPageState createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  Future<void> _deleteUser(String uniqueId, String role) async {
    try {
      String collection =
          role.toLowerCase() == 'student' ? 'students' : 'teachers';

      final querySnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where('uniqueId', isEqualTo: uniqueId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('User deleted successfully',
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.all(16),
          ),
        );

        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12),
                Text('User not found',
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                  child: Text('Error deleting user: $e',
                      style: TextStyle(fontWeight: FontWeight.w500))),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  void _showDeleteConfirmationDialog(
      String uniqueId, String role, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(Icons.warning, color: Colors.red.shade600, size: 24),
              ),
              SizedBox(width: 12),
              Text('Confirm Delete',
                  style: TextStyle(
                      color: Colors.red.shade700, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'Are you sure you want to delete $name? This action cannot be undone.',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child:
                  Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteUser(uniqueId, role);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child:
                  Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          SizedBox(height: 10),
          _buildTabBar(),
          SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStudentsTab(isDesktop),
                _buildTeachersTab(isDesktop),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimation.value,
            child: FloatingActionButton.extended(
              onPressed: () {
                GoRouter.of(context).push('/add_user_page');
              },
              backgroundColor: Colors.green.shade600,
              icon: Icon(Icons.person_add, color: Colors.white, size: 20),
              label: Text(
                'Add New',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              elevation: 12,
              heroTag: "addUser",
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        indicatorAnimation: TabIndicatorAnimation.linear,
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade600, Colors.green.shade400],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.green.shade600,
        labelStyle:
            GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle:
            GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school_outlined, size: 20),
                SizedBox(width: 8),
                Text('Students'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, size: 20),
                SizedBox(width: 8),
                Text('Teachers'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsTab(bool isDesktop) {
    Future<List<Map<String, dynamic>>> fetchStudents() async {
      final studentsCollection =
          FirebaseFirestore.instance.collection('students');
      final studentsSnapshot = await studentsCollection.get();
      final studentsList =
          studentsSnapshot.docs.map((doc) => doc.data()).toList();

      if (_searchQuery.isNotEmpty) {
        return studentsList
            .where((student) =>
                student['name']
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                (student['email'] ?? '')
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                (student['className'] ?? '')
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
            .toList();
      }

      return studentsList;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSearchBar(),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: fetchStudents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingState();
                } else if (snapshot.hasError) {
                  return _buildErrorState(snapshot.error.toString());
                }

                final students = snapshot.data as List<Map<String, dynamic>>;

                if (students.isEmpty) {
                  return _buildEmptyState('No students found');
                }

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      curve: Curves.easeOutBack,
                      child: _buildPersonCard(students[index], true, isDesktop),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeachersTab(bool isDesktop) {
    Future<List<Map<String, dynamic>>> fetchTeachers() async {
      final teachersCollection =
          FirebaseFirestore.instance.collection('teachers');
      final teachersSnapshot = await teachersCollection.get();
      final teachersList =
          teachersSnapshot.docs.map((doc) => doc.data()).toList();

      if (_searchQuery.isNotEmpty) {
        return teachersList
            .where((teacher) =>
                teacher['name']
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                (teacher['email'] ?? '')
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                (teacher['subject'] ?? '')
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
            .toList();
      }

      return teachersList;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSearchBar(),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: fetchTeachers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingState();
                } else if (snapshot.hasError) {
                  return _buildErrorState(snapshot.error.toString());
                }

                final teachers = snapshot.data as List<Map<String, dynamic>>;

                if (teachers.isEmpty) {
                  return _buildEmptyState('No teachers found');
                }

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: teachers.length,
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      curve: Curves.easeOutBack,
                      child:
                          _buildPersonCard(teachers[index], false, isDesktop),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: GoogleFonts.poppins(fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Search by name, email, or class...',
          hintStyle:
              GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon:
              Icon(Icons.search, color: Colors.green.shade600, size: 24),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey.shade500),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : Icon(Icons.tune, color: Colors.green.shade600, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildPersonCard(
      Map<String, dynamic> person, bool isStudent, bool isDesktop) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 16 : 12, vertical: isDesktop ? 12 : 8),
            child: Row(
              children: [
                Hero(
                  tag: person['uniqueId'] ?? '',
                  child: Container(
                    width: isDesktop ? 40 : 36,
                    height: isDesktop ? 40 : 36,
                    decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        person['name'][0].toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: isDesktop ? 16 : 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        person['name'],
                        style: GoogleFonts.poppins(
                          fontSize: isDesktop ? 15 : 14,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        person['email'] ?? 'Not available',
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isStudent
                        ? person['className'] ?? 'No info'
                        : person['subject'] ?? 'No info',
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (isDesktop)
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: person['isActive'] == true
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: person['isActive'] == true
                            ? Colors.green.shade200
                            : Colors.red.shade200,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      person['isActive'] == true ? 'Active' : 'Inactive',
                      style: GoogleFonts.poppins(
                        color: person['isActive'] == true
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                SizedBox(width: 4),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: PopupMenuButton(
                    icon: Icon(Icons.more_vert,
                        color: Colors.grey.shade600, size: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    offset: Offset(0, 30),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            GoRouter.of(context).goNamed('pre_profile',
                                queryParameters: {
                                  'uid': person['generatedId'],
                                  'role': person['role']
                                });
                          },
                          child: Row(
                            children: [
                              Icon(Icons.visibility,
                                  color: Colors.blue.shade600, size: 16),
                              SizedBox(width: 8),
                              Text('View Profile',
                                  style: GoogleFonts.poppins(fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            GoRouter.of(context).goNamed('edit_profile',
                                queryParameters: {
                                  'uniqueId': person['uniqueId']
                                });
                          },
                          child: Row(
                            children: [
                              Icon(Icons.edit,
                                  color: Colors.orange.shade600, size: 16),
                              SizedBox(width: 8),
                              Text('Edit',
                                  style: GoogleFonts.poppins(fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            _showDeleteConfirmationDialog(
                              person['uniqueId'],
                              person['role'],
                              person['name'],
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.delete,
                                  color: Colors.red.shade600, size: 16),
                              SizedBox(width: 8),
                              Text('Delete',
                                  style: GoogleFonts.poppins(fontSize: 13)),
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
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Loading data...',
            style: GoogleFonts.poppins(
              color: Colors.green.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child:
                Icon(Icons.error_outline, color: Colors.red.shade600, size: 48),
          ),
          SizedBox(height: 20),
          Text(
            'Something went wrong',
            style: GoogleFonts.poppins(
              color: Colors.red.shade600,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please try again later',
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade200, Colors.grey.shade100],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.people_outline,
                color: Colors.grey.shade600, size: 48),
          ),
          SizedBox(height: 20),
          Text(
            message,
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search',
            style: GoogleFonts.poppins(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
