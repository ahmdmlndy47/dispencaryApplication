import 'package:dispensary/appointment_page.dart';
import 'package:dispensary/components/card_widget.dart';
import 'package:dispensary/components/specializations.dart';
import 'package:dispensary/home_content.dart';
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
  int _current = 0;

 List<Widget> widgets = [
   HomeContent(),
   AppointmentPage()
 ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets[_current],
      bottomNavigationBar: BottomNavigationBar(
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
          //تبويبة الصفحة الرئيسية
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "الصفحة الرئيسية",

          ),
          //تبويبة الموعد

          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: "موعدي",

          )
        ],
      ),
    );
  }
}
