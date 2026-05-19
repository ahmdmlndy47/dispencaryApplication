import 'package:dispensary/add_doctor_page.dart';
import 'package:dispensary/add_patient_page.dart';
import 'package:dispensary/admin_homepage.dart';
import 'package:dispensary/homepage.dart';
import 'package:dispensary/login.dart';
import 'package:dispensary/signup.dart';
import 'package:flutter/material.dart';
import 'log_sign_page.dart';
void main() {
  runApp( MaterialApp(
    home: AdminHomepage(),
    theme: ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueAccent,
        titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      textTheme: TextTheme(
        titleMedium: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
        )
      )
    ),
    debugShowCheckedModeBanner: false,
    routes: {
      "homepage" : (context) => Homepage(),
      "adminHomepage" : (context)=> AdminHomepage(),
      "addPatientPage" : (context)=> AddPatientPage(),
      "addDoctorPage" : (context)=> AddDoctorPage(),
      "logOrSignPage" : (context) => LogOrSignPage(),
      "loginPage" : (context) => Login(),
      "signupPage" : (context) => SignUpPage(),
    },
  ));
}
