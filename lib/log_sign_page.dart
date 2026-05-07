import 'package:dispensary/signup.dart';
import 'package:flutter/material.dart';
import 'login.dart';
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
                  MaterialButton(
                    onPressed:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    shape: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    minWidth: 200,
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                    color: Colors.blueAccent,
                    splashColor: Colors.blueAccent.shade700,
                    child: Text(
                      "تسجيل الدخول",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  //زر اضافة الايميل و كلمة المرور
                  MaterialButton(
                    onPressed:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      );
                    },
                    shape: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    minWidth: 200,
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                    color: Colors.blueAccent,
                    splashColor: Colors.blueAccent.shade700,
                    child: Text(
                      "إنشاء حساب",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
