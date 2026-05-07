import 'package:flutter/material.dart';
import 'package:dispensary/components/input_field.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}
//صفحة إضافة ايميل و كلمة مرور
class _SignUpPageState extends State<SignUpPage> {

  TextEditingController id = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 50,horizontal: 25),
        //صورة الخلفية
        decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage('images/dark_clinic.jpg'),
          fit: BoxFit.cover,
    ),
      ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(20),

            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //صورة اللوغو
                Align(
                  alignment: Alignment.topLeft,
                  child: CircleAvatar(
                  backgroundImage: AssetImage("images/clinic_icon2.png",),
                  radius: 20,
                  ),
                ),
                //حقل إدخال رمز التحقق
                Text(
              "رمز التعريف",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
              ),
                InputField(
                  hint: "أدخل رمز التعريف",
                  icon: Icon(Icons.perm_identity),
                  isObscure: false,
                  controller: id,
                  enabled: true,),
                SizedBox(height: 10,),
                //زر التحقق
                Center(
                  child: MaterialButton(
                    onPressed: (){},
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.transparent)
                    ),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    minWidth: 120,
                    child: Text(
                      "تحقق",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w300),),
                  ),
                ),
                SizedBox(height: 20,),
                //حقل إضافة البريد الإلكتروني
                Text(
                  "البريد الإلكتروني",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                InputField(
                  hint: "أدخل البريد الإلكتروني",
                  icon: Icon(Icons.mail),
                  isObscure: false,
                  controller: email,
                  enabled: false,),
                SizedBox(height: 20,),
                //حقل إضافة كلمة المرور
                Text(
                  "كلمة المرور",
                  style: TextStyle(
                      color:  Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                InputField(
                  hint: "أدخل كلمة المرور",
                  icon: Icon(Icons.lock),
                  isObscure: true,
                  controller: password,
                  enabled: false,),
                SizedBox(height: 20,),
                //حقل تأكيد كلمة المرور
                Text(
                  "تأكيد كلمة المرور",
                  style: TextStyle(
                      color:  Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                InputField(
                  hint: "أدخل كلمة المرور مرة أخرى",
                  icon: Icon(Icons.lock),
                  isObscure: true,
                  controller: password,
                  enabled: false,),
                SizedBox(height: 10,),
                Center(
                  child: MaterialButton(
                    onPressed: (){},
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(color: Colors.transparent)
                    ),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    minWidth: 300,
                    child: Text(
                      "إنشاء الحساب",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
