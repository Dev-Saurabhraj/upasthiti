import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bloc/profile_bloc/profile_bloc.dart';
import 'bloc/profile_bloc/profile_event.dart';
import 'bloc/profile_bloc/profile_state.dart';

class ProfilePage extends StatefulWidget {
  final String generatedId;
  final String userRole;

  const ProfilePage(
      {super.key, required this.generatedId, required this.userRole});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context
        .read<ProfileBloc>()
        .add(LoadProfile(widget.generatedId, widget.userRole));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 600;
print('profile presentation : ${widget.userRole}');
    print('profile presentation : ${widget.generatedId}');
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return _buildLoadingState();
          }
          if (state is ProfileError) {
            return _buildErrorState(state.message);
          }
          if (state is ProfileLoaded) {
            return _buildProfileContent(state, height, width, isDesktop);
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Loading profile...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context
                    .read<ProfileBloc>()
                    .add(LoadProfile(widget.generatedId, widget.userRole));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(
      ProfileLoaded state, double height, double width, bool isDesktop) {
    return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 10, left: 15, right: 15),
        child: Column(
          children: [
            _buildProfileHeader(state.user, height, width, isDesktop),
          ],
        ));
  }

  Widget _buildProfileHeader(
      dynamic user, double height, double width, bool isDesktop) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        _profileCard(context, user, height, width, isDesktop),
        SizedBox(
          height: 20,
        ),
        _personalInfoCard(
          context,
          user,
          height,
          width,
          isDesktop,
        ),
        SizedBox(
          height: 20,
        ),
        _academicDetails(context, user, height, width, isDesktop),
        SizedBox(
          height: 20,
        ),
        _parentsDetails(context, user, height, width, isDesktop),
        SizedBox(
          height: 20,
        ),
        _addressCard(context, user, height, width, isDesktop),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _profileCard(BuildContext context, dynamic user, double height,
      double width, bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: height / 40, right: isDesktop ? 30 : 20),
            child: CircleAvatar(
                radius: isDesktop ? 50 : 35,
                child: Icon(
                  Icons.person,
                  size: isDesktop ? 60 : 30,
                )),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isDesktop ? 31 : 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 9,
                ),
                Text(
                  user.role,
                  style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 9,
                ),
                Text(
                  user.gender ?? 'Not provided',
                  style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _personalInfoCard(BuildContext context, dynamic user, double height,
      double width, bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: height / 35, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Personal Information',
                  style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                          fontSize: height / 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700)),
                ),
                Spacer(),
                user.role == 'admin'
                    ? _editButton(context, () {})
                    : Container(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            isDesktop
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _decoratedTextCard(
                              context, 'First Name', user.firstName, isDesktop),
                          _decoratedTextCard(
                              context, 'Email Address', user.email, isDesktop),
                        ],
                      ),
                      Column(
                        children: [
                          _decoratedTextCard(
                              context, 'Last Name', user.lastName, isDesktop),
                          _decoratedTextCard(
                              context, 'Aadhaar No', user.aadhaarNo, isDesktop),
                        ],
                      ),
                      Column(
                        children: [
                          _decoratedTextCard(
                              context,
                              'Date of Birth',
                              _formatDate(_parseDate(user.dateOfBirth)),
                              isDesktop),
                          _decoratedTextCard(
                              context, 'Phone No', user.phoneNo, isDesktop),
                        ],
                      ),
                      SizedBox(
                        width: 150,
                      )
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _decoratedTextCard(
                              context, 'First Name', user.firstName, isDesktop),
                          _decoratedTextCard(
                              context, 'Email Address', user.email, isDesktop),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _decoratedTextCard(
                              context, 'Last Name', user.lastName, isDesktop),
                          _decoratedTextCard(
                              context, 'Aadhaar No', user.aadhaarNo, isDesktop),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _decoratedTextCard(
                              context,
                              'Date of Birth',
                              _formatDate(_parseDate(user.dateOfBirth)),
                              isDesktop),
                          _decoratedTextCard(
                              context, 'Phone No', user.phoneNo, isDesktop),
                        ],
                      ),
                      SizedBox(
                        width: 150,
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _addressCard(BuildContext context, dynamic user, double height,
      double width, bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: height / 35, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Address',
                  style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                          fontSize: height / 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700)),
                ),
                Spacer(),
                user.role == 'admin'
                    ? _editButton(context, () {})
                    : Container(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            isDesktop
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _decoratedTextCard(
                              context, 'Country', user.country, isDesktop),
                          _decoratedTextCard(
                              context, 'State', user.state, isDesktop),
                          _decoratedTextCard(
                              context, 'City', user.city, isDesktop),
                          SizedBox(
                            width: 100,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _decoratedTextCard(
                              context, 'Street', user.street, isDesktop),
                          _decoratedTextCard(
                              context, 'Landmark', user.landmark, isDesktop),
                          _decoratedTextCard(context, 'Postal Code',
                              user.postalcode, isDesktop),
                          SizedBox(
                            width: 100,
                          )
                        ],
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _decoratedTextCard(
                          context, 'Country', user.country, isDesktop),
                      _decoratedTextCard(
                          context, 'State', user.state, isDesktop),
                      _decoratedTextCard(context, 'City', user.city, isDesktop),
                      _decoratedTextCard(
                          context, 'Street', user.street, isDesktop),
                      _decoratedTextCard(
                          context, 'Landmark', user.landmark, isDesktop),
                      _decoratedTextCard(
                          context, 'Postal Code', user.postalcode, isDesktop),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _academicDetails(BuildContext context, dynamic user, double height,
      double width, bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: height / 35, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Academics Details',
                  style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                          fontSize: height / 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700)),
                ),
                Spacer(),
                user.role == 'admin'
                    ? _editButton(context, () {})
                    : Container(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            isDesktop
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _decoratedTextCard(
                          context, 'User Role', user.role, isDesktop),
                      _decoratedTextCard(
                          context, 'Class', user.className, isDesktop),
                      _decoratedTextCard(context, 'Admission Date',
                          _formatDate(_parseDate(user.createdAt)), isDesktop),
                      SizedBox(
                        width: 100,
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _decoratedTextCard(
                          context, 'User Role', user.role, isDesktop),
                      _decoratedTextCard(
                          context, 'Class', user.className, isDesktop),
                      _decoratedTextCard(context, 'Admission Date',
                          _formatDate(_parseDate(user.createdAt)), isDesktop),
                      SizedBox(
                        width: 100,
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _parentsDetails(BuildContext context, dynamic user, double height,
      double width, bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: height / 35, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Parents Details',
                  style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                          fontSize: height / 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700)),
                ),
                Spacer(),
                user.role == 'admin'
                    ? _editButton(context, () {})
                    : Container(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            isDesktop
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _decoratedTextCard(context, 'Mother\'s Name',
                              user.motherName, isDesktop),
                          _decoratedTextCard(context, 'Mother\'s Occupation',
                              user.motherOccupation, isDesktop),
                          _decoratedTextCard(context, 'Mother\'s Phone No',
                              user.motherPhoneNo, isDesktop),
                          SizedBox(
                            width: 100,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _decoratedTextCard(context, 'Father\'s Name',
                              user.fatherName, isDesktop),
                          _decoratedTextCard(context, 'Father\'s Occupation',
                              user.fatherOccupation, isDesktop),
                          _decoratedTextCard(context, 'Father\'s Phone No',
                              user.fatherPhoneNo, isDesktop),
                          SizedBox(
                            width: 100,
                          )
                        ],
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _decoratedTextCard(context, 'Mother\'s Name',
                          user.motherName, isDesktop),
                      _decoratedTextCard(context, 'Mother\'s Occupation',
                          user.motherOccupation, isDesktop),
                      _decoratedTextCard(context, 'Mother\'s Phone No',
                          user.motherPhoneNo, isDesktop),
                      _decoratedTextCard(context, 'Father\'s Name',
                          user.fatherName, isDesktop),
                      _decoratedTextCard(context, 'Father\'s Occupation',
                          user.fatherOccupation, isDesktop),
                      _decoratedTextCard(context, 'Father\'s Phone No',
                          user.fatherPhoneNo, isDesktop),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _decoratedTextCard(
      BuildContext context, String title, String subtitle, bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isDesktop ? 20 : 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(fontSize: 15, color: Colors.grey)),
          ),
          SizedBox(
            height: isDesktop ? 10 : 5,
          ),
          Text(
            subtitle.isNotEmpty ? subtitle : 'NA',
            style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(fontSize: 17, color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No profile data available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime _parseDate(dynamic date) {
    if (date is String) {
      return DateTime.parse(date);
    }
    return date as DateTime;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

Widget _editButton(BuildContext context, Function() onTap) {
  return Container(
    height: 35,
    width: 68,
    child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.orange),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ))),
        onPressed: onTap,
        child: Center(
          child: Row(
            children: [
              Text(
                'Edit',
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                  color: Colors.white,
                )),
              ),
              Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ],
          ),
        )),
  );
}
