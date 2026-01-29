import 'package:campusbuzz/Authentication/SignIn/signin.dart';
import 'package:campusbuzz/Authentication/Signup/signup.dart';
import 'package:campusbuzz/Bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart' hide Size;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity / 2,
              color: Colors.black,
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Upsthiti",
                      style: GoogleFonts.poppins(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      "Your Daily Presence.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: (width > 1200) ? width / 2.5 : width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorWeight: 3,
                          indicatorPadding: const EdgeInsets.all(3),
                          indicator: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2,
                                offset: Offset(1, 2),
                              )
                            ],
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          dividerColor: Colors.transparent,
                          labelColor: Colors.black,
                          labelStyle: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          tabs: const [
                            Tab(text: "LogIn"),
                            Tab(text: "SignUp"),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        // Disable TabView scrolling
                        children: [
                          BlocProvider(
                              create: (context) => SignInBloc(),
                              child: Signin()),
                          Signup(),
                        ],
                      ),
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
}
