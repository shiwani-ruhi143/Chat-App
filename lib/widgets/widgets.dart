import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

var textInputDecoration = InputDecoration(
  labelStyle: TextStyle(
      color: Color.fromARGB(255, 148, 143, 143), fontWeight: FontWeight.w400),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFee7b64), width: 2.w)),
  // labelText: text,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFee7b64), width: 2.w)),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFee7b64), width: 2.w)),
);

void nextScreenReplace(context, page) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => page));
}

void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: TextStyle(fontSize: 20.sp),
    ),
    backgroundColor: color,
    duration: Duration(seconds: 5),
    action: SnackBarAction(
      label: "Ok",
      onPressed: () {},
      textColor: Colors.white,
    ),
  ));
}
