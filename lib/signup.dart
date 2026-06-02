import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dispensary/components/input_field.dart';
import 'package:http/http.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}
//صفحة إضافة ايميل و كلمة مرور
class _SignUpPageState extends State<SignUpPage> {
  bool isEnabled = false;
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController id = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
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
          child: SingleChildScrollView(
            child: Form(
              key: key,
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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    InputField(
                      // validator: (val){},
                      hint: "أدخل رمز التعريف",
                      icon: Icon(Icons.perm_identity),
                      isObscure: false,
                      controller: id,
                      enabled: true,),
                    SizedBox(height: 10,),
                    //زر التحقق
                    Center(
                      child: MaterialButton(
                        onPressed: (){
                          setState(() {
                            isEnabled = true;
                          });
                        },
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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    InputField(
                      validator: (val){
                        if(val == ""){
                          return "لا يمكن ترك الحقل فارغاً";
                        }else if(!val!.contains("@gmail.com")){
                          return "البريد الإلكتوني غير صحيح";
                        }
                      },
                      hint: "أدخل البريد الإلكتروني",
                      icon: Icon(Icons.mail),
                      isObscure: false,
                      controller: email,
                      enabled: isEnabled,),
                    SizedBox(height: 20,),
                    //حقل إضافة كلمة المرور
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
                      enabled: isEnabled,),
                    SizedBox(height: 20,),
                    //حقل تأكيد كلمة المرور
                    Text(
                      "تأكيد كلمة المرور",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    InputField(
                      validator: (val){
                        if(val == ""){
                          return "لا يمكن ترك الحقل فارغاً";
                        } else if(confirmPassword.text != password.text){
                          return "كلمتا المرور غير متطابقتان";
                        }
                      },
                      hint: "أدخل كلمة المرور مرة أخرى",
                      icon: Icon(Icons.lock),
                      isObscure: true,
                      controller: confirmPassword,
                      enabled: isEnabled,),
                    SizedBox(height: 10,),
                    Center(
                      child: MaterialButton(
                        onPressed: () async{
                          if(key.currentState!.validate()){
                            try {
                              final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: email.text,
                                password: password.text,
                              );
                              Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                AwesomeDialog(
                                  context: context,
                                  title: "خطأ إدخال",
                                  desc: "كلمة المرور ضعيفة",
                                  animType: AnimType.rightSlide,
                                  dialogType: DialogType.error
                                ).show();
                              } else if (e.code == 'email-already-in-use') {
                                AwesomeDialog(
                                    context: context,
                                    title: "خطأ إدخال",
                                    desc: "هذا الحساب موجود مسبقاً",
                                    animType: AnimType.rightSlide,
                                    dialogType: DialogType.error
                                ).show();
                              }
                            } catch (e) {

                            }
                          }
                        },
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
        ),
      ),
    );
  }
}
