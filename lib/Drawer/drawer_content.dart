import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerContent extends StatefulWidget {
  final String generatedId ;
  final String userRole;
  const DrawerContent({super.key, required this.generatedId, required this.userRole});
  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent>{
  @override
  Widget build(BuildContext context){
    final String? user = widget.generatedId;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
            decoration: BoxDecoration(

              gradient: LinearGradient(
                  colors: [Colors.green.shade600, Colors.green.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              )

            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  foregroundColor: Colors.white,
                  radius: 35,
                    child: Icon(Icons.person,
                        size: 40, color: Colors.white)
                ),
                SizedBox(
                  height: 10,
                ),
                Text('user : $user', style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),),
              ],
            )),
        _builddrawerItem('Attendance', Icons.dashboard_customize, () {
          GoRouter.of(context)
              .push('/admin_dashboard?generatedId=${widget.generatedId}&role=${widget.userRole}');
        }, 0),

        _builddrawerItem('Announcements', Icons.announcement, () {
          final userId = FirebaseAuth.instance.currentUser!.uid;
          GoRouter.of(context)
              .push('/notice_page?userId=$userId&role=teacher');
        },1),
        _builddrawerItem('Profile', Icons.person, () {
          print(widget.userRole);
          print(widget.generatedId);
          GoRouter.of(context).push('/pre_profile?uid=${widget.generatedId}&role=${widget.userRole}');
        }, 2),

        _builddrawerItem('Help & Support', Icons.help, () {
          GoRouter.of(context).push('/help_and_support');
        }, 7),

        Container(
          height: 1,
          width: 300,
          color: Colors.grey.shade300,
        ),
        ListTile(
          tileColor: Colors.white,
          leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.red.shade100
                ,
                borderRadius: BorderRadius.circular(10),
              ),

              child: const Icon(Icons.logout, color: Colors.red,)),
          title: Text('LogOut',
              style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold)),
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
        ),
        Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(color: Colors.white))
      ],
    );
  }
}


Widget _builddrawerItem(String title, IconData icon, VoidCallback onTap, int no) {
  final Color randomColor = getRandomPastelColor( no , false);
  return ListTile(
    tileColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    leading: Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: randomColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: randomColor, size: 22),
    ),
    title: Text(
      title,
      style: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),
    onTap: onTap,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    hoverColor: randomColor.withOpacity(0.3),
  );
}



Color getRandomPastelColor(index, bool isIcon) {

  final List<Color> pastelColors = [

    isIcon? Colors.pink.shade100: Colors.pink.shade900,
    isIcon? Colors.blue.shade100: Colors.blue.shade900,
    isIcon? Colors.green.shade100: Colors.green.shade900,
    isIcon? Colors.orange.shade100: Colors.orange.shade900,
    isIcon? Colors.teal.shade100: Colors.teal.shade900,
    isIcon? Colors.amber.shade100: Colors.amber.shade900,
    isIcon? Colors.cyan.shade100: Colors.cyan.shade900,
    isIcon? Colors.purple.shade100: Colors.purple.shade900,
    isIcon? Colors.indigo.shade100: Colors.indigo.shade900,

  ];
  return pastelColors[index];
}
