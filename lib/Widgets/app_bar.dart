import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalAppBar extends StatelessWidget{
final String title;
final bool isDesktop;
  const PersonalAppBar({super.key, required this.title, required this.isDesktop});
  @override
  Widget build(BuildContext context) {


    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: isDesktop? 20: 10,
          ),
          TextButton(
            onPressed: () => GoRouter.of(context).go('/student_manager_home_page'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(5),
                 )),
            ),
            child: isDesktop? Row(
              children: [
                Icon(
                  Icons.menu,
                  color: Colors.black54,
                ),
                SizedBox(width: 5,),
                Text(
                  'Menu',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(color: Colors.black54)),
                ),
              ],
            ): Icon(
              Icons.menu,
              color: Colors.black54,
            ),
          ),
          SizedBox(width: 15,),
          Text( title ,
              style: GoogleFonts.nunito(
                  textStyle: TextStyle(
                      fontSize: isDesktop? 30: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold))),
          Spacer(),
          isDesktop?  TextButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(5),
                    )),
              ),
              child: Icon(
                Icons.message_outlined,
                color: Colors.black54,
              )): Container(),
          SizedBox(
            width: 10,
          ),
          TextButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(5),
                    )),
              ),
              child: Icon(
                Icons.notification_important_outlined,
                color: Colors.black54,
              )),
          SizedBox(
            width: isDesktop? 20: 10,
          ),
        ],
      ),
    );
  }
}
