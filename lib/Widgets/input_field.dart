import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DecoratedTextField extends StatelessWidget {

  final TextEditingController? inputController = TextEditingController();
  final Function(String)? function;
  final String? hintText;
  final IconData? icon;
  final bool? obscureText;
  DecoratedTextField(this.hintText, this.icon, this.obscureText, this.function, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
          left: 20,
        right: 20,
      ),
      child: TextField(
        onChanged: function,
        obscureText: obscureText!,
        cursorColor: Color.fromARGB(255, 16,140,184),
        style: GoogleFonts.poppins(fontSize: 15),
        textInputAction: TextInputAction.next,
        controller: inputController,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(fontSize: 15, color: Colors.grey),
          prefixIcon: Icon(icon, color: Color.fromARGB(255, 16,140,184),),
          fillColor: Colors.grey.shade200,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide.none,
          ),

        ),
      ),
    );
  }
}
