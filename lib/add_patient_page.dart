import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispensary/components/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/main_button.dart';
class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  GlobalKey<FormState> patientKey = GlobalKey();
late TextEditingController firstNameController;
late TextEditingController lastNameController;
late TextEditingController ageController;
late TextEditingController phoneNumController;
late TextEditingController nationNumController;

@override
  void initState() {
  firstNameController = TextEditingController();
  lastNameController = TextEditingController();
  ageController = TextEditingController();
  phoneNumController = TextEditingController();
  nationNumController = TextEditingController();
  super.initState();
  }

  @override
  void dispose() {
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
        title: Text(
          "صفحة إضافة مريض",
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
            key: patientKey,
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
                    inputType: TextInputType.name,
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
                    inputType: TextInputType.name,
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
                    inputType: TextInputType.number,
                    isObscure: false,
                    controller: ageController,
                    enabled: true,
                    validator: (val){
                      if(val == ""){
                        return "لا يمكن ترك الحقل فارغا";
                      }
                      int? number = int.tryParse(val!);
                      if(number == null || number < 0){
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
                    inputType: TextInputType.number,
                    isObscure: false,
                    controller: phoneNumController,
                    enabled: true,
                    validator: (val){
                      if(val == ""){
                        return "لا يمكن ترك الحقل فارغا";
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
                    inputType: TextInputType.number,
                    isObscure: false,
                    controller: nationNumController,
                    enabled: true,
                    validator: (val){
                      if(val == ""){
                        return "لا يمكن ترك الحقل فارغا";
                      }
                    }
                ),
                SizedBox(height: 20,),
                //زر الإضافة
                MyButton(
                    onPressed: (){
                      //عند الضغط عليه وتكون الإدخالات صحيحة
                      //سيتم إظهار ديالوغ يحتوي على بيانات المريض لتأكيد الإضافة
                      if(patientKey.currentState!.validate()){
                        showDialog(
                            context: context,
                            builder: (dialogContext){
                              //الديالوغ
                              return Dialog(
                                child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black,
                                                offset: Offset(-5, 5),
                                                blurRadius: 5
                                            )
                                          ]
                                      ),
                                      padding: EdgeInsets.all(20),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            //عنوان الديالوغ
                                            Center(
                                              child: Text(
                                                "هل انت متأكد من إضافة المريض",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            // الاسم الاول الذي تم إدخاله
                                            Text(
                                              "الاسم الأول : ${firstNameController.text}",
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            SizedBox(height: 10,),
                                            // الاسم الأخير الذي تم إدخاله
                                            Text(
                                              "الاسم الأخير : ${lastNameController.text}",
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            SizedBox(height: 10,),
                                            // العمر الذي تم إدخاله
                                            Text(
                                              "العمر : ${ageController.text}",
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            SizedBox(height: 10,),
                                            // رقم الهاتف الذي تم إدخاله
                                            Text(
                                              "الهاتف : ${phoneNumController.text}",
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            SizedBox(height: 10,),
                                            // الرقم الوطني الذي تم إدخاله
                                            Text(
                                              "الرقم الوطني : ${nationNumController.text}",
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            SizedBox(height: 10,),
                                            //أزرار التأكيد والإلغاء
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                //زر التأكيد
                                                Expanded(
                                                  child: TextButton(
                                                    onPressed: ()async{
                                                      //عند الضغط عليه
                                                      //يتم جلب المستوصف الذي ستتم إضافته إليه أولا
                                                      final dispensary =
                                                      await FirebaseFirestore.instance.collectionGroup("dispensaries")
                                                          .where("admins",arrayContains: FirebaseAuth.instance.currentUser!.uid)
                                                          .limit(1).get();
                                                      //ثم يتم جلب الcollection الخاصة بمرضى المستوصف
                                                      final patients = await dispensary.docs.first.reference.collection("patients");
                                                      final patientsColl = await patients.get();
                                                      //متحول لمعرفة فيما إذا كان المريض موجود مسبقا
                                                      bool patientExist = false;
                                                      //إذا تم العثور على هذا المريض ضمن قائمة المرضى يتم تغيير قيمة المتغير
                                                      patientsColl.docs.forEach((element){
                                                        if(element["nationNum"] == nationNumController.text){
                                                          patientExist = true;
                                                        }
                                                      });
                                                      Navigator.of(dialogContext).pop();
                                                      //في حال كان موجود سيتم إظهار رسالة توضيحية ولن تتم الإضافة
                                                      if(patientExist){
                                                        AwesomeDialog(
                                                            context: context,
                                                            title: "المريض موجود مسبقا",
                                                            titleTextStyle: TextStyle(
                                                                color: Colors.red,
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 18
                                                            ),
                                                            dialogType: DialogType.error
                                                        ).show();
                                                        return;
                                                      }
                                                      //في حال لم يكن موجود ستتم إضافته لقائمة المرضى بهذا المستوصف
                                                      await patients.add({
                                                        "UID" : "",
                                                        "age" : ageController.text,
                                                        "firstName" : firstNameController.text,
                                                        "lastName" : lastNameController.text,
                                                        "phone" : phoneNumController.text,
                                                        "nationNum" : nationNumController.text,
                                                        "hasAppoint" : false,
                                                        "available" : true
                                                      });
                                                      //ويتم عرض رسالة توضيحية بنجاح الإضافة
                                                      AwesomeDialog(
                                                        context: context,
                                                        title: "تمت إضافة المريض بنجاح",
                                                        dialogType: DialogType.success,
                                                        titleTextStyle: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w600
                                                        )
                                                      ).show();
                                                    },
                                                    child: Text(
                                                      "تأكيد",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.green
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                //زر الإلغاء
                                                Expanded(
                                                  child: TextButton(
                                                    //عند الضغط عليه سيتم إزالة الديالوغ
                                                    onPressed: (){
                                                      Navigator.of(dialogContext).pop();
                                                    },
                                                    child: Text(
                                                      "إلغاء",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.red
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                ),
                              );
                            }
                        );
                      }
                    },
                    btnColor: Colors.blueAccent,
                    label: "إضافة المريض",
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
