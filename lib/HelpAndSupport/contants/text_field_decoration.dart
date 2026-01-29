import 'package:flutter/material.dart';
// Decoration constant for textfield
 InputDecoration kDecoration = InputDecoration(
    prefixIcon:
    Icon(Icons.person_outline_outlined),

    prefixIconColor: Colors.grey.shade400,
    fillColor: Colors.white,
    filled: true,

    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.green,
        width: 2.0,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade400,
        width: 2.0,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade400,
        width: 2.0,
      ),
    ),
    hintText: 'Enter Your name',
    hintStyle: TextStyle(
      color: Colors.grey.shade400,
    ));