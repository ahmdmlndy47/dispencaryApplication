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
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
          // صورة الخلفبة للصفحة
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/logOrSignPage.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    // الازرار
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //اسم التطبيق
                        Text(
                          "Dispensaries",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20,),
                        // زر تسجبل الدخول
                        MyButton(
                            onPressed: (){
                              Navigator.of(context).pushNamed("loginPage");
                            },
                            btnColor: Colors.blueAccent,
                            fontSize: 26,
                            label: "تسجيل الدخول",
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 0,color: Colors.transparent)
                            )),
                        SizedBox(height: 40,),
                        //زر اضافة الايميل و كلمة المرور
                        MyButton(
                            onPressed: (){
                              Navigator.of(context).pushNamed("signupPage");
                            },
                            btnColor: Colors.blueAccent,
                            fontSize: 26,
                            label: "إضافة إيميل",
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 0,color: Colors.transparent)
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        )
    );
  }
}