import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispensary/add_clinic.dart';
import 'package:dispensary/add_doctor_page.dart';
import 'package:dispensary/add_patient_page.dart';
import 'package:dispensary/admin_homepage.dart';
import 'package:dispensary/countries.dart';
import 'package:dispensary/doctor_page.dart';
import 'package:dispensary/doctors_list.dart';
import 'package:dispensary/homepage.dart';
import 'package:dispensary/internet_checker.dart';
import 'package:dispensary/login.dart';
import 'package:dispensary/patients_list.dart';
import 'package:dispensary/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'log_sign_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  bool isDoc = false;
  if(FirebaseAuth.instance.currentUser != null){
    final doc = await FirebaseFirestore.instance.collectionGroup("doctors").where("UID",isEqualTo: FirebaseAuth.instance.currentUser!.uid).limit(1).get();
    if(doc.docs.isNotEmpty){
      isDoc = true;
    }
  }
  runApp( MaterialApp(
    home: FirebaseAuth.instance.currentUser == null ?
    LogOrSignPage()
        : FirebaseAuth.instance.currentUser!.email == "ahmdmlndy19@gmail.com"
        ? AdminHomepage()
        : isDoc ?
    DoctorPage()
        : Homepage(),
    // home: FirebaseAuth.instance.currentUser == null
    //     ? LogOrSignPage()
    //     : FirebaseAuth.instance.currentUser!.email ==
    //     "ahmdmlndy19@gmail.com"
    //     ? AdminHomepage()
    //     : Countries(),
    // home: FirebaseAuth.instance.currentUser == null ? LogOrSignPage() : Homepage(),
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
      "countries" : (context) => Countries(),
      "adminHomepage" : (context)=> AdminHomepage(),
      "addPatientPage" : (context)=> AddPatientPage(),
      "addDoctorPage" : (context)=> AddDoctorPage(),
      "logOrSignPage" : (context) => LogOrSignPage(),
      "loginPage" : (context) => Login(),
      "signupPage" : (context) => SignUpPage(),
      "patientList" : (context) => PatientsList(),
      "doctorsList" : (context) => DoctorsList(),
      "homepage" : (context) => Homepage(),
      "addClinic" : (context) => AddClinic(),
      "doctorPage" : (context) => DoctorPage()
    },
  ));
}
