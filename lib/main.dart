import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispensary/add_clinic.dart';
import 'package:dispensary/add_doctor_page.dart';
import 'package:dispensary/add_patient_page.dart';
import 'package:dispensary/add_record_page.dart';
import 'package:dispensary/admin_homepage.dart';
import 'package:dispensary/countries.dart';
import 'package:dispensary/doctor_page.dart';
import 'package:dispensary/doctors_list.dart';
import 'package:dispensary/homepage.dart';
import 'package:dispensary/internet_checker.dart';
import 'package:dispensary/login.dart';
import 'package:dispensary/patients_list.dart';
import 'package:dispensary/records_list_page.dart';
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


  runApp( MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //متغير للتأكد فيما اذا تم الانتهاء من التحقق من الuser
  bool isLoading = true;
  //متغير لمعرفة فيما إذا كان المستخدم طبيب ام لا
  bool isDoc = false;
  //متغير لمعرفة فيما إذا كان المستخدم آدمن ام لا
  bool isAdmin = false;
  //متغي لمعرفة فيما إذا كان المستخدم مسجل ام لا
  bool isSigned = false;
  // متغير لمنع تشغيل checkUser أكثر من مرة
  bool checkingUser = false;
  //تابع لتحديد حالة الuser
  Future<void> checkUser() async {
    // منع استدعاء التابع أكثر من مرة
    if (checkingUser) return;
    checkingUser = true;
    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) {
      checkingUser = false;
      return;
    }

    // المستخدم غير مسجل دخول
    if (user == null) {
      setState(() {
        isSigned = false;
        isAdmin = false;
        isDoc = false;
        isLoading = false;
      });
      checkingUser = false;
      return;
    }

    // المستخدم مسجل دخول
    setState(() {
      isSigned = true;
    });

    try {

      // التحقق هل هو طبيب
      final doc = await FirebaseFirestore.instance
          .collectionGroup("doctors")
          .where(
        "UID",
        isEqualTo: user.uid,
      )
          .limit(1)
          .get();

      if (!mounted) {
        checkingUser = false;
        return;
      }

      if (doc.docs.isNotEmpty) {

        setState(() {
          isDoc = true;
          isAdmin = false;
          isLoading = false;
        });
        checkingUser = false;
        return;
      }


      // التحقق هل هو Admin
      final admin = await FirebaseFirestore.instance
          .collectionGroup("dispensaries")
          .where(
        "admins",
        arrayContains: user.uid,
      )
          .limit(1)
          .get();

      if (!mounted) {
        checkingUser = false;
        return;
      }

      if (admin.docs.isNotEmpty) {

        setState(() {
          isAdmin = true;
          isDoc = false;
          isLoading = false;
        });
        checkingUser = false;
        return;
      }


      // ليس طبيباً وليس Admin
      // إذن Patient

      setState(() {
        isDoc = false;
        isAdmin = false;
        isLoading = false;
      });

    } catch (e) {

      print("Error checking user: $e");

      if (!mounted) {
        checkingUser = false;
        return;
      }

      setState(() {
        isLoading = false;
      });
    }
    checkingUser = false;
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InternetChecker(
        onInternetAvailable: (){
          if(isLoading && !checkingUser){
            checkUser();
          }
        },
          child: Builder(builder: (context){
            if(isLoading){
                return Scaffold(body: Center(child: CircularProgressIndicator(),),);
              }
            if(!isSigned) return LogOrSignPage();
            else if(isDoc) return DoctorPage();
            else if(isAdmin) return AdminHomepage();
            else return Homepage();
            })
          ),

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
        "doctorPage" : (context) => DoctorPage(),
      },
    );
  }
}

