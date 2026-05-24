import 'package:dispensary/appointment_page.dart';
import 'package:dispensary/home_content.dart';
import 'package:dispensary/myrecords.dart';
import 'package:dispensary/profile.dart';
import 'package:flutter/material.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}
// الصفحة الرئيسية للمريض
// هذه الصفحة ستحتوي فقط على الشريط السفلي
// وذلك كي يظهر الاب بار الخاص بكل صفحة من صفحات المريض
class _HomepageState extends State<Homepage> {
  int _current = 3;

 List<Widget> widgets = [
   MyProfile(),
   MyRecords(),
   AppointmentPage(),
   HomeContent(),
 ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: widgets[_current],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _current,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.blueAccent,
        onTap: (val){
          setState(() {
            _current = val;
          });
        },
        items: [
          //تبويبة الملف الشخصي

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "الملف الشخصي",

          ),
          //تبويبة السجلات

          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: "سجلاتي",

          ),
          //تبويبة الموعد

          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: "موعدي",

          ),
          //تبويبة الصفحة الرئيسية
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "الصفحة الرئيسية",

          ),
        ],
      ),
    );
  }
}
