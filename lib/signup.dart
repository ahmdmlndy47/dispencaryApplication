import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dispensary/components/input_field.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}
//صفحة إضافة ايميل و كلمة مرور
class _SignUpPageState extends State<SignUpPage> {
  //مصفوفة لتخزين المجافظات المأخوذة من الداتا بيس
  List<QueryDocumentSnapshot> data = [];
  //ماغير يعبر فيما إذا كان المستخدم قد أضاف إيميل مسبقا
  bool haveEmail = false;
  //متغير يعبر فيما إذا كان قد تم تسجيل المستخدم بالتطبيق
  bool isSigned = false;
  //متغير لجعل حقول إضافة الإيميل مغلقة حتى التأكد أن المستخدم موجود ولم بضيف إيميل
  bool isEnabled = false;
  //متغير يعبر عن أن المستخدم مريض
  bool isPatient = false;
  //متغير يعبر عن أن المستخدم طبيب
  bool isDoc = false;
  String? patientId;
  GlobalKey<FormState> nationNumKey = GlobalKey();
  GlobalKey<FormState> emailAndPassKey = GlobalKey();
  TextEditingController id = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  //تابع جلب بيانات المريض في حال كان المستخدم مريض
  getPatientData(String nationNum) async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collectionGroup("patients").where("nationNum",isEqualTo: nationNum).limit(1).get();
    data =  snapshot.docs;
  }
  //تابع جلب بيانات الطبيب في حال كان المستخدم طبيب
  getDoctorData(String nationNum) async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collectionGroup("doctors").where("nationNum",isEqualTo: nationNum).limit(1).get();
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
                        if(val!.contains(new RegExp(r'[a-zA-z]'))){
                          return "إدخال خاطئ";
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
                            // تصفير حالة التحقق السابقة
                            isSigned = false;
                            isPatient = false;
                            isDoc = false;
                            haveEmail = false;
                            isEnabled = false;
                            data.clear();
                            //عند الضغط عليه سيتم تفعيل تابع جلب بيانات المريض
                            await getPatientData(id.text);
                            //في حال كان يوجد بيانات فهو مريض وتم تسجيله بالتطبيق
                            if(data.isNotEmpty){
                              isSigned = true;
                              isPatient = true;
                              //الآن يتم اختبار فيما إذا كان قد أضاف إيميل مسبقا
                              if(data[0]["UID"] != ""){
                                haveEmail = true;
                              }
                            }else {
                              //هنا يتم استدعاء تابع جلب بيانات طبيب لأن المستخدم لم يكن مريض
                              await getDoctorData(id.text);
                              //في حال كان يوجد بيانات فهو طبيب وتم تسجيله بالتطبيق
                              if(data.isNotEmpty){
                                isSigned = true;
                                isDoc = true;
                                //الآن يتم اختبار فيما إذا كان قد أضاف إيميل مسبقا
                                if(data[0]["UID"] != ""){
                                  haveEmail = true;
                                }
                              }
                            }
                            //بعد اختبار المستخدم في حال كان غير مسجل بالتطبيق سيتم إظهار رسالة توضيحية بذلك
                            if(isSigned == false){
                              //الرسالة
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
                            //إذا وصلنا لهنا فهو مسجل
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
                            //إذا وصلنا لهنا فهو مسجل و لا يملك إيميل
                              setState(() {
                                //سيتم تغيير قيمة isEnabled لفتح الحقول
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
                    //حقول إضافة الإيميل
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
                        //في حال لم يتم التحقق من وجود المستخدم وصحة بياناته سيكون هذا الور غير فعال
                        onPressed: isEnabled ? () async{
                          if(emailAndPassKey.currentState!.validate()){
                            try {
                              //عند الضغط عليه سيتم إنشاء حساب بواسطة الإيميل والباسوورد
                              final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: email.text,
                                password: password.text,

                              );
                              //في حال كان المستخدم مريض
                              if(isPatient){
                                //أولا يتم جلب الcollections الخاصة بالمريض بكل المستوصفات
                                final patients = await FirebaseFirestore.instance.collectionGroup("patients").where("nationNum",isEqualTo: id.text).get();
                                //بعد ذلك ستتم إضافة الuser ID الخاص بحسابه لقاعدة بيانات المرضى
                                for(final patient in patients.docs){
                                  await patient.reference.update({
                                    "UID" : credential.user!.uid,
                                  });
                                }
                                if (!mounted) return;
                                //بعد ذلك يتم الانتقال لصفحة تسجيل الدخول
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  "loginPage",
                                      (route) => false,
                                );
                                return;
                              }
                              //في حال كان المستخدم طبيب
                              if(isDoc){
                                //أولا يتم جلب بيانات الطبيب
                                final doctor = await FirebaseFirestore.instance.collectionGroup("doctors").where("nationNum",isEqualTo: id.text).limit(1).get();
                                //بعد ذلك يتم إضافة الuser ID لبيانات الطبيب
                                await doctor.docs.first.reference.update({
                                  "UID" : FirebaseAuth.instance.currentUser!.uid
                                });
                                if (!mounted) return;
                                //بعد ذلك يتم الانتقال لصفحة تسجيل الدخول
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  "loginPage",
                                      (route) => false,
                                );
                                return;
                              }

                              //إذا وصلنا لهنا فهناك خطأ قد حصل أثناء جلب البيانات
                                AwesomeDialog(
                                    context: context,
                                    title: "خطأ ",
                                    desc: "حدث خطأ ما",
                                    animType: AnimType.rightSlide,
                                    dialogType: DialogType.error
                                ).show();


                            } on FirebaseAuthException catch (e) {
                              //في حال كانت كلمة المرور ضعيفة ستظهر رسالة توضيحية بذلك
                              if (e.code == 'weak-password') {
                                AwesomeDialog(
                                  context: context,
                                  title: "خطأ إدخال",
                                  desc: "كلمة المرور ضعيفة",
                                  animType: AnimType.rightSlide,
                                  dialogType: DialogType.error
                                ).show();
                                //في حال كان الإيميل موجود مسبقا ضمن قاعدة البيانات ستظهر رسالة توضيحية بذلك
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
