// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dispensary/components/input_field.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email =TextEditingController();
  TextEditingController password =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(child: CircleAvatar(backgroundImage: AssetImage('images/clinic_icon2.png'), radius: 70.0),),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                Text(
                  "قم بتسجيل الدخول للمتابعة الى التطبيق",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20,),
                Text(
                  "البريد الإلكتروني",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                InputField(
                  validator: (val){},
                  hint: "أدخل البريد الإلكتروني",
                  icon: Icon(Icons.mail),
                  isObscure: false,
                  controller: email,enabled: true,
                ),
                SizedBox(height: 10,),
                Text(
                  "كلمة المرور",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                InputField(
                  validator: (val){},
                  hint: "أدخل كلمة المرور",
                  icon: Icon(Icons.lock),
                  isObscure: true,
                  controller: password,
                  enabled: true,),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: TextButton(
                    onPressed: (){},
                    child:Text("هل نسيت كلمة المرور ؟",style: TextStyle(color: Colors.blue[400]),),
                  ),
                ),
                 MaterialButton(
                   onPressed:(){
                     Navigator.of(context).pushNamedAndRemoveUntil("homepage",(route) => false);
                   },
                    minWidth: double.infinity,
                    height: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    color: Colors.blue,
                    textColor: Colors.white,
                    elevation: 0,
                    child: Text("تسجيل دخول"),
                  ),
                SizedBox(height: 20,),
                MaterialButton(
                    onPressed: (){},
                    minWidth: double.infinity,
                    height: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    color: Colors.blue,
                    textColor: Colors.white,
                    elevation: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("images/ss.png",width: 30,),
                        SizedBox(width: 10,),
                        Text("تسجيل دخول باستخدام جوجل"),
                      ],
                    ),
                  ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed:(){
                          Navigator.of(context).pushNamed("signupPage");
                        },
                        child: Text("إنشاء حساب",style: TextStyle(color: Colors.blue[400]),)),
                    Text("ليس لديك حساب ؟")
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}