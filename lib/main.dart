import 'package:dispensary/admin_homepage.dart';
import 'package:dispensary/homepage.dart';
import 'package:dispensary/login.dart';
import 'package:dispensary/signup.dart';
import 'package:flutter/material.dart';
import 'log_sign_page.dart';
void main() {
  runApp( MaterialApp(
    home: LogOrSignPage(),
    debugShowCheckedModeBanner: false,
    routes: {
      "homepage" : (context) => Homepage(),
      "logOrSignPage" : (context) => LogOrSignPage(),
      "loginPage" : (context) => Login(),
      "signupPage" : (context) => SignUpPage(),
    },
  ));
}
