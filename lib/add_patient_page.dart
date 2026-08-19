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
  //controller خاص بالاسم الأول
late TextEditingController firstNameController;
//controller خاص بحقل الاسم الأخير
late TextEditingController lastNameController;
//controller خاص بحقل العمر
late TextEditingController ageController;
//controller خاص بحقل رقم الهاتف
late TextEditingController phoneNumController;
//controller خاص بحقل الرقم الوطني
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
                                                    //عند الضغط عليه
                                                    onPressed: ()async{
                                                      //متغير لتخزين الuser id للمريض ان كان موجود ببعض المستوصفات
                                                      String patientUserId = "";
                                                      //متغير يعبر عن عدد المستوصفات الموجود بها المريض
                                                      int existsCount = 0;
                                                      //مصفوفة المعرفات التي موجود بها المريض
                                                      List<String> dispensariesId = [];
                                                      //متغير يعبر عما إذا كان المريض موجود بمستوصف الآدمن الحالي
                                                      bool isExistInCurr = false;
                                                      //يتم جلب مستوصف الآدمن الحالي
                                                      final currDispensary = await FirebaseFirestore.instance
                                                          .collectionGroup("dispensaries")
                                                          .where("admins",arrayContains: FirebaseAuth.instance.currentUser!.uid)
                                                          .limit(1).get();
                                                      //ثم نبحث عن المريض بهذا المستوصف
                                                      final currPatient =
                                                      await currDispensary.docs.first.reference
                                                          .collection("patients")
                                                          .where("nationNum",isEqualTo: nationNumController.text)
                                                          .limit(1).get();
                                                      //إذا كان موجود نغير قيمة المتغير
                                                      if(currPatient.docs.isNotEmpty){
                                                        dispensariesId.add(currDispensary.docs.first.id);
                                                        patientUserId = currPatient.docs.first["UID"];
                                                        isExistInCurr = true;
                                                      }
                                                      //يتم جلب جميع المستوصفات لأنه عند إنشاء حساب بأي مستوصف سيتم إضافته لكامل مستوصفات التطبيق
                                                      final dispensaries = await FirebaseFirestore.instance
                                                          .collectionGroup("dispensaries")
                                                          .get();
                                                      //متحول لمعرفة فيما إذا كان المريض موجود مسبقا ببقية المستوصفات
                                                      bool patientExist = false;
                                                      //التأكد فيما إذا كان المريض موحود
                                                      for (final dispensary in dispensaries.docs) {
                                                        //عند الحصول على المستوصف الحالي ستتم المتابعة لأننا اختبرناه مسبقا
                                                        if(dispensary.id == currDispensary.docs.first.id){
                                                          continue;
                                                        }
                                                        final patientsSnapshot = await dispensary.reference
                                                            .collection("patients")
                                                            .where(
                                                          "nationNum",
                                                          isEqualTo: nationNumController.text,
                                                        )
                                                            .limit(1)
                                                            .get();
                                                        //إذا كان موجود بهذا المستوصف
                                                        if (patientsSnapshot.docs.isNotEmpty) {
                                                          //نزيد عدد المستوصفات الموجود بها
                                                          existsCount++;
                                                          //نضيف معرف هذا المستوصف لقائمة المعرفات
                                                          dispensariesId.add(dispensary.id);
                                                          //ونخزن الuserId الخاص بالمريض مرة واحدة
                                                          if(patientUserId == ""){
                                                            patientUserId = patientsSnapshot.docs.first["UID"];
                                                          }
                                                        }
                                                      }
                                                      if(existsCount == dispensaries.docs.length - 1){
                                                        //عند إيجاد المريض بكل المستوصفات يتم تغيير قيمة المتحول
                                                        patientExist = true;
                                                      }
                                                      //الآن يتم إغلاق الdialog لعرض نتيجة الإضافة
                                                      if (dialogContext.mounted) {
                                                        Navigator.of(dialogContext).pop();
                                                      }

                                                      //في حال كان موجود بجميع المستوصفات سيتم إظهار رسالة توضيحية ولن تتم الإضافة
                                                      if (patientExist && isExistInCurr) {
                                                        if (!mounted) return;
                                                        //الرسالة
                                                        AwesomeDialog(
                                                          context: context,
                                                          title: "المريض موجود مسبقا",
                                                          titleTextStyle: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 18,
                                                          ),
                                                          dialogType: DialogType.error,
                                                        ).show();
                                                        //إفراغ الحقول
                                                        setState(() {
                                                          firstNameController.clear();
                                                          lastNameController.clear();
                                                          ageController.clear();
                                                          nationNumController.clear();
                                                          phoneNumController.clear();
                                                        });
                                                        return;
                                                      }
                                                      //إذا كان موجود بجميع المستوصفات عدا المستوصف الحالي سيتم إضافته للمستوصف
                                                      if(patientExist && !isExistInCurr){
                                                        await currDispensary.docs.first.reference.collection("patients").add(
                                                            {
                                                              "UID": patientUserId,
                                                              "age": ageController.text,
                                                              "firstName": firstNameController.text,
                                                              "lastName": lastNameController.text,
                                                              "phone": phoneNumController.text,
                                                              "nationNum": nationNumController.text,
                                                              "hasAppoint": false,
                                                              "available": true,
                                                              "missedAnApp": false,
                                                              "records" : []
                                                            });
                                                        //ويتم عرض رسالة توضيحية بنجاح الإضافة
                                                        if (!mounted) return;
                                                        //الرسالة
                                                        AwesomeDialog(
                                                          context: context,
                                                          title: "تمت إضافة المريض بنجاح",
                                                          dialogType: DialogType.success,
                                                          titleTextStyle: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ).show();
                                                        //إفراغ الحقول
                                                        setState(() {
                                                          firstNameController.clear();
                                                          lastNameController.clear();
                                                          ageController.clear();
                                                          nationNumController.clear();
                                                          phoneNumController.clear();
                                                        });
                                                        return;
                                                      }
                                                      //في حال لم يكن موجود ستتم إضافته لقائمة المرضى بكل المستوصفات الغير موجود بها
                                                      for (final dispensary in dispensaries.docs) {
                                                        if(dispensariesId.isNotEmpty && dispensariesId.contains(dispensary.id)){
                                                          continue;
                                                        }
                                                        await dispensary.reference.collection("patients").add({
                                                          "UID": patientUserId,
                                                          "age": ageController.text,
                                                          "firstName": firstNameController.text,
                                                          "lastName": lastNameController.text,
                                                          "phone": phoneNumController.text,
                                                          "nationNum": nationNumController.text,
                                                          "hasAppoint": false,
                                                          "available": true,
                                                          "missedAnApp": false,
                                                        });
                                                      }
                                                      //ويتم عرض رسالة توضيحية بنجاح الإضافة
                                                      if (!mounted) return;
                                                      //الرسالة
                                                      AwesomeDialog(
                                                        context: context,
                                                        title: "تمت إضافة المريض بنجاح",
                                                        dialogType: DialogType.success,
                                                        titleTextStyle: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ).show();
                                                      //إفراغ الحقول
                                                      setState(() {
                                                        firstNameController.clear();
                                                        lastNameController.clear();
                                                        ageController.clear();
                                                        nationNumController.clear();
                                                        phoneNumController.clear();
                                                      });
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
