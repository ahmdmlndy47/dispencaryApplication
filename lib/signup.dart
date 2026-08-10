import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  //مصفوفة لتخزين المجافظات المأخوذة من الداتا بيس
  List<QueryDocumentSnapshot> data = [];
  bool haveEmail = false;
  bool isSigned = false;
  bool isEnabled = false;
  String? patientId;
  GlobalKey<FormState> nationNumKey = GlobalKey();
  GlobalKey<FormState> emailAndPassKey = GlobalKey();
  TextEditingController id = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  //تابع جلب البيانات
  getData(String nationNum) async{
    QuerySnapshot snapshot =await FirebaseFirestore.instance.collectionGroup("patients").where("nationNum",isEqualTo: nationNum).limit(1).get();
    data =  snapshot.docs;
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    id.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }
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
              key: nationNumKey,
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
                    //حقل إدخال رمز الوطني
                    Text(
                      "الرمز الوطني",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    InputField(
                      validator: (val){
                        if(val == ""){
                          return "لا يمكن ترك الحقل فارغا";
                        }
                      },
                      hint: "أدخل الرمز الوطني",
                      icon: Icon(Icons.perm_identity),
                      inputType: TextInputType.number,
                      isObscure: false,
                      controller: id,
                      enabled: true,),
                    SizedBox(height: 10,),
                    //زر التحقق
                    Center(
                      child: MaterialButton(
                        onPressed: ()async{
                          if(nationNumKey.currentState!.validate()){
                            await getData(id.text);
                            if(data.isNotEmpty){
                              isSigned = true;
                              if(data[0]["UID"] != ""){
                                haveEmail = true;
                              }
                            }

                            if(isSigned == false){
                              AwesomeDialog(
                                context: context,
                                title: "يجب ان تكون قد أنشأت حساب من قبل راجع المستوصف لإنشاء حساب",
                                titleTextStyle: TextStyle(
                                  color: Colors.red
                                ),
                                btnOkText: "موافق"
                              ).show();
                              id.text = "";
                              return;
                            }
                            //هنا سيتم التأكد إذا كان هذا الuser قد قام بإضافة ايميل مسبقا
                            if(haveEmail){
                                //في حال كان لديه ايميل سيظهر dialog يوضح الخظأ
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  title: "خطأ",
                                  desc: "هذا المستخدم يملك حساب مسبقا",
                                  titleTextStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red
                                  ),
                                  descTextStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.red
                                  ),
                                ).show();
                                id.text = "";
                                setState(() {
                                  haveEmail = false;
                                });
                                return;
                            }

                              setState(() {
                                isEnabled = true;
                              });

                          }
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
                    Form(
                      key: emailAndPassKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
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
                            inputType: TextInputType.emailAddress,
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
                            inputType: TextInputType.visiblePassword,
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
                            inputType: TextInputType.visiblePassword,
                            isObscure: true,
                            controller: confirmPassword,
                            enabled: isEnabled,),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    //زر إنشاء الحساب
                    Center(
                      child: MaterialButton(
                        onPressed: isEnabled ? () async{
                          if(emailAndPassKey.currentState!.validate()){
                            try {
                              //عند الضغط عليه سيتم إنشاء حساب بواسطة الإيميل والباسوورد
                              final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: email.text,
                                password: password.text,

                              );
                              //بعدها سننتقل للصفحة الرئيسية
                              Navigator.of(context).pushNamedAndRemoveUntil("loginPage", (route) => false);
                              final patient = await FirebaseFirestore.instance.collectionGroup("patients").where("nationNum",isEqualTo: id.text).limit(1).get();
                              //بعد ذلك ستتم إضافة الuser ID الخاص بحسابه لقاعدة بيانات المرضى
                              await patient.docs.first.reference.update({
                                "UID" : FirebaseAuth.instance.currentUser!.uid
                              });

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
                              print("Error $e");
                            }
                          }
                        } : null,
                        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(color: Colors.transparent)
                        ),
                        color: isEnabled  ? Colors.blueAccent : Colors.grey.shade600,
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
