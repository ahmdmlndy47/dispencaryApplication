import 'package:flutter/material.dart';

import 'components/main_button.dart';
// صفحة تسجيل الدخول او إضافة ايميل و كلمة مرور
class LogOrSignPage extends StatefulWidget {
  const LogOrSignPage({super.key});

  @override
  State<LogOrSignPage> createState() => _LogOrSignPageState();
}

class _LogOrSignPageState extends State<LogOrSignPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Container(
          // صورة الخلفبة للصفحة
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/logOrSignPage.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(30),
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20)
              ),
              // الازرار
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // زر تسجبل الدخول
                  MyButton(
                      onPressed: (){
                          Navigator.of(context).pushNamed("loginPage");
                          },
                      fontSize: 26,
                      label: "تسجيل الدخول",
                      shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(width: 0,color: Colors.transparent)
                      )),
                  //زر اضافة الايميل و كلمة المرور
                  MyButton(
                      onPressed: (){
                          Navigator.of(context).pushNamed("signupPage");
                        },
                      fontSize: 26,
                      label: "إنشاء حساب",
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 0,color: Colors.transparent)
                      )
                    ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
