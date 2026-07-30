import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispensary/components/input_field.dart';
import 'package:dispensary/components/main_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AddDoctorPage extends StatefulWidget {
  const AddDoctorPage({super.key});

  @override
  State<AddDoctorPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddDoctorPage> {
  
  List<String> specialties = [
    "الطب العام",
    "الطب الباطني",
    "الجراحة العامة",
    "طب الأطفال",
    "طب النساء",
    "طب القلب",
    "طب العظام",
    "طب الأعصاب",
    "الطب النفسي",
    "طب العيون",
    "طب الأنف والأذن والحنجرة",
    "الأمراض الجلدية",
    "طب الأسنان",
    "التخدير والإنعاش",
    "الأشعة والتصوير الطبي",
    "طب الطوارئ",
    "طب الأسرة",
    "طب المسالك البولية",
    "الأمراض الصدرية",
    "أمراض الجهاز الهضمي",
    "أمراض الغدد والسكري",
    "طب الأورام",
    "جراحة الأعصاب",
    "جراحة القلب",
    "جراحة التجميل",
    "طب الكلى",
    "أمراض الدم",
    "الروماتيزم",
    "الطب الشرعي",
    "الطب الرياضي",
  ];
  GlobalKey<FormState> key = GlobalKey();
  late TextEditingController specializationController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController ageController;
  late TextEditingController phoneNumController;
  late TextEditingController nationNumController;
  @override
  void initState() {
    specializationController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    ageController = TextEditingController();
    phoneNumController = TextEditingController();
    nationNumController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    specializationController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    phoneNumController.dispose();
    nationNumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //عنوان الصفحة
      appBar: AppBar(
        centerTitle: true,
        title: Text("صفحة إضافة طبيب",),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //حقل إدخال الاسم الأول
                Text(
                  "الاسم الأول",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                InputField(
                    hint: "أدخل الاسم الأول",
                    icon: Icon(Icons.person),
                    isObscure: false,
                    controller: firstNameController,
                    enabled: true,
                    validator: (val){
                      if(val == ""){
                        return "لا يمكن ترك الحقل فارغا";
                      }
                    }
                ),
                SizedBox(height: 20,),
                //حقل إدخال الاسم الأخير
                Text(
                  "الاسم الأخير",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                InputField(
                    hint: "أدخل الاسم الأخير",
                    icon: Icon(Icons.person),
                    isObscure: false,
                    controller: lastNameController,
                    enabled: true,
                    validator: (val){
                      if(val == ""){
                        return "لا يمكن ترك الحقل فارغا";
                      }
                    }
                ),
                SizedBox(height: 20,),
                //حقل إدخال العمر
                Text(
                  "العمر",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                InputField(
                    hint: "أدخل العمر",
                    icon: Icon(Icons.elderly),
                    isObscure: false,
                    controller: ageController,
                    enabled: true,
                    validator: (val){
                      if(val == ""){
                        return "لا يمكن ترك الحقل فارغا";
                      }
                      if(val!.contains(new RegExp(r'[a-zA-z]'))){
                        return "إدخال خاطئ";
                      }
                    }
                ),
                SizedBox(height: 20,),
                //حقل إدخال رقم الهاتف
                Text(
                  "رقم الهاتف",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                InputField(
                    hint: "أدخل رقم الهاتف",
                    icon: Icon(Icons.phone),
                    isObscure: false,
                    controller: phoneNumController,
                    enabled: true,
                    validator: (val){
                      if(val == ""){
                        return "لا يمكن ترك الحقل فارغا";
                      }
                      if(val!.contains(new RegExp(r'[a-zA-z]'))){
                        return "إدخال خاطئ";
                      }
                    }
                ),
                SizedBox(height: 20,),
                //حقل إدخال الرقم الوطني
                Text(
                  "الرقم الوطني",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                InputField(
                    hint: "أدخل الرقم الوطني",
                    icon: Icon(Icons.numbers),
                    isObscure: false,
                    controller: nationNumController,
                    enabled: true,
                    validator: (val){
                      if(val == ""){
                        return "لا يمكن ترك الحقل فارغا";
                      }
                      if(val!.contains(new RegExp(r'[a-zA-z]'))){
                        return "إدخال خاطئ";
                      }
                    }
                ),
                SizedBox(height: 20,),
                //حقل إدخال الاختصاص
                Text(
                  "الاختصاص",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                InputField(
                    hint: "أدخل الاختصاص",
                    icon: Icon(Icons.medical_information),
                    isObscure: false,
                    controller: specializationController,
                    enabled: true,
                    validator: (val){
                      if(val == ""){
                        return "لا يمكن ترك الحقل فارغا";
                      }
                    }
                ),
                // Directionality(
                //   textDirection: TextDirection.rtl,
                //   child: DropdownButtonFormField(
                //       decoration: InputDecoration(
                //         filled: true,
                //         fillColor: Colors.blue[50],
                //         prefixIcon: Icon(Icons.medical_information),
                //         enabledBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(40),
                //           borderSide: BorderSide(color: Colors.grey),
                //         ),
                //         focusedBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(40),
                //           borderSide: BorderSide(color: Colors.grey),
                //         ),
                //         hintText: "الاختصاص",
                //       ),
                //       items: specialties.map<DropdownMenuItem<String>>((speciality){
                //         return DropdownMenuItem<String>(
                //           value: speciality,
                //           child: Text(speciality),
                //         );
                //       }).toList(),
                //       onChanged: (val){
                //         setState(() {
                //           selectedSpeciality = val;
                //         });
                //       }),
                // ),
                SizedBox(height: 20,),
                //زر الإضافة
                MyButton(
                  //عند الضغط عليه والإدخال صحيح
                    onPressed: () async{
                      if(key.currentState!.validate()){
                        final dispensary = await FirebaseFirestore.instance.collectionGroup("dispensaries").where("admins",arrayContains: FirebaseAuth.instance.currentUser!.uid).limit(1).get();
                        //في حال لم يتم الوصول للمستوصف في قاعدة البيانات
                        //يتم إظهار dialog يوضح الخطأ
                        if(dispensary.docs.isEmpty){
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            title: "خطأ",
                            desc: "لا يمكن إيجاد المستوصف الحالي لإضافة الطبيب فيه",
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
                          //بعدها يتم تفريغ الحقول
                          setState(() {
                            firstNameController.text = "";
                            ageController.text = "";
                            lastNameController.text = "";
                            specializationController.text = "";
                            nationNumController.text = "";
                            phoneNumController.text = "";
                          });
                          return;
                        }
                        final doc =await dispensary.docs.first.reference.collection("doctors").where("nationNum",isEqualTo: nationNumController.text).limit(1).get();
                        //في حال لم يتم الوصول للأطباء في قاعدة البيانات
                        //يتم إظهار dialog يوضح الخطأ
                        if(doc.docs.isNotEmpty){
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            title: "خطأ",
                            desc: "الطبيب موجود مسبقا",
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
                          //بعدها يتم تفريغ الحقول
                          setState(() {
                            firstNameController.text = "";
                            ageController.text = "";
                            lastNameController.text = "";
                            specializationController.text = "";
                            nationNumController.text = "";
                            phoneNumController.text = "";
                          });
                          return;
                        }
                        //في حال لم يحدث أي خطأ وتم الوصول للأطباء في المستوصف
                        //يتم إضافة الطبيب للمستوصف
                        await dispensary.docs.first.reference.collection("doctors").add(
                            {
                              "firstName" : firstNameController.text,
                              "lastName" : lastNameController.text,
                              "phoneNum" : phoneNumController.text,
                              "nationNum" : nationNumController.text,
                              "speciality" : specializationController.text,
                            });
                        //يتم إظهار رسالة تبين الإضافة بنجاح
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم إضافة الطبيب"),duration: Duration(milliseconds: 1500),));
                        //بعدها يتم تفريغ الحقول
                        setState(() {
                          firstNameController.text = "";
                          ageController.text = "";
                          lastNameController.text = "";
                          specializationController.text = "";
                          nationNumController.text = "";
                          phoneNumController.text = "";
                        });
                      }
                    },
                    btnColor: Colors.blueAccent,
                    label: "إضافة الطبيب",
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fontSize: 18
                )
              ],
            )
        ),
      ),
    );
  }
}
