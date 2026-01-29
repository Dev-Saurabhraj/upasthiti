import 'package:campusbuzz/Authentication/Authentication_firebase_service/services.dart';
import 'package:campusbuzz/Bloc/auth/auth_bloc.dart';
import 'package:campusbuzz/Bloc/auth/auth_event.dart';
import 'package:campusbuzz/Bloc/auth/auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Signin extends StatefulWidget {
  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late String errorTextE = '';
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    bool isDesktop = false;
    if(width> 600) {
      isDesktop = true;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                BlocBuilder<SignInBloc, SignInState>(builder: (context, state) {
              if (state is SignInErrorState) {
                return Text(
                  state.errorMessage,
                  style: TextStyle(color: Colors.red),
                );
              } else {
                return Container();
              }
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (val) {
                BlocProvider.of<SignInBloc>(context).add(SignInTextChangedEvent(
                    emailController.text, passwordController.text));
              },
              controller: emailController,
              obscureText: false,
              cursorColor: Color.fromARGB(255, 16, 140, 184),
              style: GoogleFonts.poppins(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Email',
                errorText: errorTextE,
                hintStyle:
                    GoogleFonts.poppins(fontSize: 15, color: Colors.grey),
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
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (val) {
                BlocProvider.of<SignInBloc>(context).add(SignInTextChangedEvent(
                    emailController.text, passwordController.text));
              },
              controller: passwordController,
              obscureText: true,
              cursorColor: Color.fromARGB(255, 16, 140, 184),
              style: GoogleFonts.poppins(fontSize: 15),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle:
                    GoogleFonts.poppins(fontSize: 15, color: Colors.grey),
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
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                InkWell(
                    onTap: () {
                      _auth.sendPasswordResetEmail(
                          email: _auth.currentUser!.uid.toString());
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.green,
                        showCloseIcon: true,
                        closeIconColor: Colors.green,
                        content: Text('Password Reset Link Sent'),
                      ));
                    },
                    child: Text(
                      'Forgot Password ?',
                      style: GoogleFonts.poppins(
                        color: Colors.teal.shade800,
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.all(20),
              child: BlocBuilder<SignInBloc, SignInState>(
                builder: (context, state) {
                  if (state is SignInLoadingState) {
                    return Center(child: CircularProgressIndicator());

                  }

                  return MaterialButton(
                    onPressed: () async {
                      if (state is SignInValidState) {
                        BlocProvider.of<SignInBloc>(context).add(
                            SignInSubmittedEvent(
                                emailController.text, passwordController.text));
                      }
                      final email = emailController.text.trim();
                      final password = passwordController.text;

                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email, password: password);

                        final studentSnap = await FirebaseFirestore.instance
                            .collection('students')
                            .where('email', isEqualTo: email)
                            .limit(1)
                            .get();

                        if (studentSnap.docs.isNotEmpty) {
                          var data = studentSnap.docs.first.data();
                          String generatedId = data['generatedId'];
                          String role = data['role'];
                          String username = data['name'];
                          if (isDesktop == true) {
                            GoRouter.of(context)
                                .push('/persistent_ui?generatedId=$generatedId&role=$role');
                            return;
                          }

                          GoRouter.of(context)
                              .push('/admin_dashboard?generatedId=$generatedId&role=$role&username=$username');
                          return;
                        }

                        final teacherSnap = await FirebaseFirestore.instance
                            .collection('teachers')
                            .where('email', isEqualTo: email)
                            .limit(1)
                            .get();

                        if (teacherSnap.docs.isNotEmpty) {
                          var data = teacherSnap.docs.first.data();
                          String generatedId = data['generatedId'];
                          String role = data['role'];

                          if (isDesktop == true ){

                            GoRouter.of(context)
                                .push('/persistent_ui?generatedId=$generatedId&role=$role');
                            return;
                          }

                          GoRouter.of(context)
                              .push('/admin_dashboard?generatedId=$generatedId&role=$role');
                          return;
                        }

                        setState(() {
                          errorTextE = 'Contact Administration';
                        });
                      } catch (e) {
                        setState(() {
                          errorTextE = 'Invalid credentials.';

                        });
                      }
                    },
                    elevation: 2,
                    height: 50,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: (state is SignInValidState)
                        ? Color.fromARGB(255, 16, 140, 184)
                        : Colors.grey,
                    child: Text(
                      "LogIn",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                },
              )),
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
                  "Or LogIn with ",
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
