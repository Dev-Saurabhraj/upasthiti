import 'package:campusbuzz/Authentication/SingInUi/login.dart';
import 'package:campusbuzz/Bloc/internet/internet_bloc.dart';
import 'package:campusbuzz/Bloc/internet/internet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetState>(builder: (context, state) {
        return Login();
    }, listener: (context, state) {
      if (state is InternetLostState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Internet Lost'),
          backgroundColor: Colors.red,
        ));
      } else if (state is InternetGainedState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Internet Connected'),
          backgroundColor: Colors.green,
        ));
      }
    });
  }
}
