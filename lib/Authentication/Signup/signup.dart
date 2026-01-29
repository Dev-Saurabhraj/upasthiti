import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late String errorTextE = '';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  late String? email = 'saurabh';
  late String? password = 'saurabh';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: emailController,
            obscureText: false,
            cursorColor: Color.fromARGB(255, 16, 140, 184),
            style: GoogleFonts.poppins(fontSize: 15),
            decoration: InputDecoration(
              errorText: errorTextE,
              hintText: 'Email',
              hintStyle: GoogleFonts.poppins(fontSize: 15, color: Colors.grey),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Color.fromARGB(255, 16, 140, 184),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(17),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: passController,
            obscureText: true,
            cursorColor: Color.fromARGB(255, 16, 140, 184),
            style: GoogleFonts.poppins(fontSize: 15),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: GoogleFonts.poppins(fontSize: 15, color: Colors.grey),
              prefixIcon: Icon(
                CupertinoIcons.lock,
                color: Color.fromARGB(255, 16, 140, 184),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(17),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          Row(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 5),
                child: Text(
                  'Forgot Password ? ',
                  style: TextStyle(
                    color: Colors.teal,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.all(20),
              child: MaterialButton(
                onPressed: () {
                  final email = emailController.text.trim();
                  final password = passController.text;
                  try {
                    final newUser = FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email, password: password);
                    if (newUser != null) {
                      GoRouter.of(context).go('/profile',);
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print(e.toString());
                    }
                  }
                },
                elevation: 2,
                height: 50,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Color.fromARGB(255, 16, 140, 184),
                child: Text(
                  "SignUp",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 1.5,
                  color: Colors.grey.shade300,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Or SignUp with",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Expanded(
                  child: Container(
                height: 1.5,
                color: Colors.grey.shade300,
              ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                MaterialButton(
                  height: 50,
                  minWidth: 150,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                          color: Colors.grey.shade300,
                          style: BorderStyle.solid)),
                  onPressed: () {},
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/google.png',
                            height: 30,
                          ),
                        ),
                        Text(
                          'Google',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Spacer(),
                MaterialButton(
                  height: 50,
                  minWidth: 150,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                          color: Colors.grey.shade300,
                          style: BorderStyle.solid)),
                  onPressed: () {},
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Icon(
                            Icons.facebook,
                            color: Colors.blue,
                            size: 35,
                          ),
                        ),
                        Text(
                          'Facebook',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
