import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispensary/components/input_field.dart';
import 'package:dispensary/components/main_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//صفحة إضافة عيادة للمستوصف
class AddClinic extends StatefulWidget {
  const AddClinic({super.key});

  @override
  State<AddClinic> createState() => _AddClinicState();
}

class _AddClinicState extends State<AddClinic> {
  GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController clinicName;
  List<QueryDocumentSnapshot> doctors = [];
  String? selectedDoc;
  //تابع جلب الأطباء من أجل السيليكشن الخاصة بالأطباء
  getDoctors() async{
    final dispensary = await FirebaseFirestore.instance.collectionGroup("dispensaries").where("admins",arrayContains: FirebaseAuth.instance.currentUser!.uid).limit(1).get();
    final doctorsSnapshot = await dispensary.docs.first.reference.collection("doctors").get();
    doctors = doctorsSnapshot.docs;
    setState(() {});
  }
  @override
  void initState() {
    clinicName  = TextEditingController();
    getDoctors();
    super.initState();
  }
  @override
  void dispose() {
    clinicName.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //عنوان الصفحة
      appBar: AppBar(
        title: Text("إضافة عيادة"),
        centerTitle: true,
      ),
      //جسم الصفحة
      body: Directionality(
          textDirection: TextDirection.rtl,
          child: Form(
            key: formKey,
            //عناصر جسم الصفحة
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                //نص توضيحي من أجل الإضافة
                Center(
                  child: Text(
                    "أدخل بيانات العيادة ثم أضغط على إضافة لإضافة عيادة للمستوصف",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  "الطبيب",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                //السليكشن الخاصة بالأطباء
                DropdownButtonFormField(
                  validator: (val){
                    if(val == "" || val == null){
                      return "يجب اختيار طبيب";
                    }
                  },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      hintText: "اسم الطبيب",
                    ),
                    items: doctors.map<DropdownMenuItem<String>>((doctor){
                      return DropdownMenuItem(
                        value: "${doctor["firstName"]} ${doctor["lastName"]}",
                        child: Text(
                          "${doctor["firstName"]} ${doctor["lastName"]}",
                        ),
                      );
                    }).toList(),
                    onChanged: (val){
                      setState(() {
                        selectedDoc = val;
                      });
                    }),
                SizedBox(height: 20,),
                Text(
                  "اسم العيادة",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                //حقل إدخال اسم العيادة
                InputField(
                    hint: "أدخل اسم العيادة",
                    icon: Icon(Icons.medical_information),
                    isObscure: false,
                    inputType: TextInputType.text,
                    controller: clinicName,
                    enabled: true,
                    validator: (val){
                      if(val == "" || val == null){
                        return "لا يمكن ترك الحقل فارغا";
                      }
                      if(val.contains(new RegExp('[0-9]'))){
                        return "اسم خاطئ";
                      }
                    },
                ),
                SizedBox(height: 10,),
                //زر الإضافة
                MyButton(
                    onPressed: () async{
                      //عند الضغط عليه يتم التحقق أولا من صحة المدخلات
                      if(formKey.currentState!.validate()){
                        // في حال المدخلات صحيحة يتم جلب العيادات
                        final dispensary = await FirebaseFirestore.instance.collectionGroup("dispensaries").where("admins",arrayContains: FirebaseAuth.instance.currentUser!.uid).limit(1).get();
                        final clinics  = await dispensary.docs.first.reference.collection("clinics");
                        //البحث عن عيادة بنفس اسم العيادة الجديدة
                        final exClinic = await clinics.where("clinicName",isEqualTo: clinicName.text).limit(1).get();
                        //في حال كان هناك عيادة بنفس الاسم سيتم إظهار dialog لتوضيخ أن العيادة موجودة مسبقا
                        if(exClinic.docs.isNotEmpty){
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            title: "خطأ",
                            desc: "العيادة موجودة مسبقا",
                            descTextStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.red
                            ),
                            titleTextStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                            )
                          ).show();
                          return;
                        }
                        //في حال لم تكن العيادة موجودة مسبقا يتم إضافة العيادة للمستوصف
                        clinics.add({
                          "available" : true,
                          "patientNum" : 0,
                          "docName" : selectedDoc,
                          "clinicName" : clinicName.text,
                        } );
                        //يتم إظهار نص للإعلام بالإضافة
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تمت الإضافة"),duration: Duration(milliseconds: 1500),));
                        //ثم يتم إفراغ الحقول
                        clinicName.text = "";
                      }
                    },
                    label: "إضافة",
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    fontSize: 18,
                    btnColor: Colors.blueAccent
                ),
              ],
            ),
          )
      ),
    );
  }
}
