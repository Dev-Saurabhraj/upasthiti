import 'package:campusbuzz/Profile_presentations/profile_firebase_service/profile_firebase_service.dart';
import 'package:campusbuzz/Profile_presentations/profile_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/profile_bloc/profile_bloc.dart';

class PreProfile extends StatefulWidget {
  final String userRole;
  final String generatedId;
  const PreProfile({super.key, required this.userRole, required this.generatedId});

  @override
  State<PreProfile> createState() => _PreProfileState();
}

class _PreProfileState extends State<PreProfile> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:  AppBar(
        leading: IconButton(onPressed:() {
        }, icon: Icon(Icons.arrow_back_ios_new_outlined, size: 25,)),
        title: Text('Profile Details', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.white,),
      body: BlocProvider(
        create: (context) => ProfileBloc(UserRepository()),
        child: ProfilePage(generatedId: widget.generatedId, userRole: widget.userRole),
      ),
    );
  }
}
