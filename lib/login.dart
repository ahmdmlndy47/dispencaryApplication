// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dispensary/components/main_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dispensary/components/input_field.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> key = GlobalKey();
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
            child: Form(
              key: key,
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
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  InputField(
                    validator: (val){
                      if(val == ""){
                        return "لا يمكن ترك الحقل فارغاً";
                      }
                      else if(!val!.contains("@gmail.com")){
                        return "البريد الإلكتروني خاطئ";
                      }
                    },
                    hint: "أدخل البريد الإلكتروني",
                    icon: Icon(Icons.mail),
                    isObscure: false,
                    controller: email,
                    enabled: true,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "كلمة المرور",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  InputField(
                    validator: (val){
                      if(val == ""){
                        return "لا يمكن ترك الحقل فارغاً";
                      }
                    },
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
                  MyButton(
                      onPressed: () async{
                        if(key.currentState!.validate()){
                          try {
                            final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: email.text,
                                password: password.text
                            );
                            credential.user!.email == "ahmdmlndy19@gmail.com"
                                ? Navigator.of(context).pushNamedAndRemoveUntil("adminHomepage", (route)=>false)
                                : Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route)=>false);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'invalid-credential') {
                              AwesomeDialog(
                                  context: context,
                                  title: "خطأ إدخال",
                                  desc: "كلمة المرور أو البريد الإلكتروني خاطئ",
                                  animType: AnimType.rightSlide,
                                  dialogType: DialogType.error
                              ).show();
                            }
                          }
                        }
                      },
                      btnColor: Colors.blueAccent,
                      label: "تسجيل الدخول",
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      fontSize: 18
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
          ),
        ],
      ),
    );
  }
}