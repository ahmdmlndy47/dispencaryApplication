import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispensary/components/card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/input_field.dart';
import 'components/main_button.dart';
//صفحة قائمة الأطباء
class DoctorsList extends StatefulWidget {
  const DoctorsList({super.key});

  @override
  State<DoctorsList> createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList> {
  GlobalKey<FormState> formKey = GlobalKey();
  Stream<QuerySnapshot>? stream;
  List<QueryDocumentSnapshot> doctors = [];
  List controllers = [];
  //تابع جلب الأطباء وتهيئة الstream
  getDoctors() async{
    final snapshot = await FirebaseFirestore.instance.collectionGroup("dispensaries").where("admins",arrayContains: FirebaseAuth.instance.currentUser!.uid).limit(1).get();
    if (snapshot.docs.isEmpty) {
      return;
    }
    final dispensary = snapshot.docs.first.reference;
    stream = dispensary.collection("doctors").snapshots();
    final doctorsSnapshot = await dispensary.collection("doctors").get();
    doctors = doctorsSnapshot.docs;
    for(int i=0;i<doctors.length;i++){
      controllers.add({
        "nationNumController" : TextEditingController(),
        "phoneController" : TextEditingController(),
        "phoneNumEnabled" : false,
        "nationNumEnabled" : false,
      });
    }
    if (mounted) {
      setState(() {});
    }
  }
  @override
  void initState() {
    super.initState();
    getDoctors();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //عنوان الصفحة
      appBar: AppBar(
        title: Text("قائمة الأطباء"),
        centerTitle: true,
      ),
      //MyCardعناصر الصفحة وهي قائمة الأطباء وكل واحد ضمن yCard
      body:  Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                //نص توضيحي
                Text(
                  "قائمة أطباء المركز",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
               //قائمة الأطباء

                StreamBuilder<QuerySnapshot>(stream: stream, builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                  if (stream == null) {
                    return const Center( child: CircularProgressIndicator(), );
                  }
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  if (snapshot.hasError) {
                    return Center( child: Text("حدث خطأ: ${snapshot.error}"), );
                  }
                  if(!snapshot.hasData || snapshot.data!.docs.length == 0){
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(-5, 5),
                                        blurRadius: 5
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Text(
                                "لا يوجد بيانات لعرضها",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent
                                ),
                              ),
                            ),
                          ),),
                      ),
                    );
                  }
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        return MyCard(
                            title: "${snapshot.data!.docs[index]["firstName"]} ${snapshot.data!.docs[index]["lastName"]}",
                            subtitle: "اخصائي ${snapshot.data!.docs[index]["speciality"]}",
                            trailing: "انقر للتعديل",
                            onTap:  () {
                          final parentContext = context;
                          showDialog(
                            barrierDismissible: false,
                              context: context,
                              builder: (dialogContext){
                                return StatefulBuilder(builder: (context,setDialogState){
                                  //الاليرت
                                  return Dialog(
                                      child:  Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: SingleChildScrollView(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(color: Colors.black,offset: Offset(-5, 5),blurRadius: 5)
                                                ],
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            child: Form(
                                              key: formKey,
                                              child: Column(
                                                textDirection: TextDirection.rtl,
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  //عنوان الاليرت والذي هو اسم الطبيب
                                                  Text(
                                                    "${snapshot.data!.docs[index]["firstName"]} ${snapshot.data!.docs[index]["lastName"]}",
                                                    style: Theme.of(context).textTheme.titleMedium,
                                                  ),
                                                  SizedBox(height: 20,),
                                                  //سطر رقم هاتف الطبيب
                                                  Row(
                                                    children: [
                                                      //حقل رقم الهاتف ولكن سيكون disabled بالبداية
                                                      Expanded(
                                                        flex : 3,
                                                        child: InputField(
                                                            hint: "${snapshot.data!.docs[index]["phoneNum"]}",
                                                            icon: Icon(Icons.phone),
                                                            inputType: TextInputType.number,
                                                            isObscure: false,
                                                            controller: controllers[index]["phoneController"],
                                                            enabled: controllers[index]["phoneNumEnabled"],
                                                          validator: (val){
                                                            if(val == ""){
                                                              return "لا يمكن ترك الحقل فارغا";
                                                            }
                                                            if(val!.contains(new RegExp(r'[a-zA-z]'))){
                                                              return "إدخال خاطئ";
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      //زر التعديل على حقل رقم الهاتف والذي سيجعل الحقلenabled
                                                      Expanded(
                                                          child: TextButton(
                                                              onPressed: (){
                                                                setDialogState(() {
                                                                  controllers[index]["phoneNumEnabled"] = true;
                                                                });
                                                              },
                                                              child: Text(
                                                                "تعديل",
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.blueAccent,
                                                                ),
                                                              )
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  //سطر رقم الطبيب الوطني
                                                  Row(
                                                    children: [
                                                      //حقل الرقم الوطني ولكن سيكون disabled بالبداية
                                                      Expanded(
                                                        flex : 3,
                                                        child: InputField(
                                                            hint: "${snapshot.data!.docs[index]["nationNum"]}",
                                                            icon: Icon(Icons.numbers),
                                                            inputType: TextInputType.number,
                                                            isObscure: false,
                                                            controller: controllers[index]["nationNumController"],
                                                            enabled: controllers[index]["nationNumEnabled"],
                                                          validator: (val){
                                                            if(val == ""){
                                                              return "لا يمكن ترك الحقل فارغا";
                                                            }
                                                            if(val!.contains(new RegExp(r'[a-zA-z]'))){
                                                              return "إدخال خاطئ";
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      //زر التعديل على حقل الرقم الوطني والذي سيجعل الحقلenabled
                                                      Expanded(
                                                          child: TextButton(
                                                              onPressed: (){
                                                                setDialogState(() {
                                                                  controllers[index]["nationNumEnabled"] = true;
                                                                });
                                                              },
                                                              child: Text(
                                                                "تعديل",
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.blueAccent,
                                                                ),
                                                              )
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  //زر حذف الطبيب من المركز
                                                  MyButton(
                                                      onPressed: (){
                                                        //عند الضغط على الزر سيظهر dialog لتأكيد الجذف
                                                        Navigator.of(dialogContext).pop();
                                                        AwesomeDialog(
                                                            context: parentContext,
                                                            title: "هل أنت متأكد من حذف الطبيب",
                                                            dialogType: DialogType.warning,
                                                            animType: AnimType.rightSlide,
                                                            //عند تأكيد الجذف يتم إزالة الطبيب من قاعدة بيانات المستوصف
                                                            btnOkOnPress: (){
                                                              snapshot.data!.docs[index].reference.delete();
                                                            },
                                                            btnCancelOnPress: (){},
                                                            btnOkText: "حذف",
                                                            btnCancelText: "إلغاء",
                                                            btnCancelColor: Colors.red,
                                                            btnOkColor: Colors.green
                                                        ).show();
                                                      },
                                                      label: "حذف الطبيب",
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                      fontSize: 16,
                                                      btnColor: Colors.redAccent
                                                  ),
                                                  SizedBox(height: 10,),
                                                  //أزرار حفظ التعديل والإلغاء
                                                  Row(
                                                    children: [
                                                      //زر حفظ التغييرات
                                                      Expanded(child: TextButton(
                                                          onPressed: (){
                                                            if(formKey.currentState!.validate()){
                                                              //عند الضغط عليه سيظهر dialog لتأكيد التعديل
                                                              Navigator.of(dialogContext).pop();
                                                              AwesomeDialog(
                                                                //لا يمكن إغلاق الdialog عند الضغط خارجه
                                                                  dismissOnTouchOutside: false,
                                                                  context: parentContext,
                                                                  title: "هل أنت متأكد من التعديل",
                                                                  dialogType: DialogType.warning,
                                                                  animType: AnimType.rightSlide,
                                                                  //عند تأكيد التعديل
                                                                  btnOkOnPress: (){
                                                                    //يتم تحديث بيانات الطبيب ضمن قاعدة البيانات
                                                                    snapshot.data!.docs[index].reference.update(
                                                                        {
                                                                          "nationNum" : controllers[index]["nationNumController"].text,
                                                                          "phoneNum" : controllers[index]["phoneController"].text,
                                                                        });
                                                                    //بعد التعديل يتم إغلاق الحقول وجعلها disabled مجددا
                                                                    controllers[index]["nationNumController"].text = "";
                                                                    controllers[index]["phoneController"].text = "";
                                                                    controllers[index]["nationNumEnabled"] = false;
                                                                    controllers[index]["phoneNumEnabled"] = false;
                                                                  },
                                                                  //بعد الخروج من الdialog يتم إغلاق الحقول وجعلها disabled مجددا
                                                                  btnCancelOnPress: (){
                                                                    setState(() {
                                                                      controllers[index]["nationNumController"].text = "";
                                                                      controllers[index]["phoneController"].text = "";
                                                                      controllers[index]["nationNumEnabled"] = false;
                                                                      controllers[index]["phoneNumEnabled"] = false;
                                                                    });
                                                                  },
                                                                  btnOkText: "تعديل",
                                                                  btnCancelText: "إلغاء",
                                                                  btnCancelColor: Colors.red,
                                                                  btnOkColor: Colors.green
                                                              ).show();
                                                            }
                                                          },
                                                          child: Text(
                                                            "حفظ التغييرات",
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 14,
                                                              color: Colors.red,
                                                            ),
                                                          )
                                                      )),
                                                      //زر الإلغاء عند الضغط عليه سيتم إزالة الاليرت وعد التعديل
                                                      Expanded(child: TextButton(
                                                          onPressed: (){
                                                            Navigator.of(dialogContext).pop();
                                                            //بعد الخروج من الdialog يتم إغلاق الحقول وجعلها disabled مجددا
                                                            setState(() {
                                                              controllers[index]["nationNumController"].text = "";
                                                              controllers[index]["phoneController"].text = "";
                                                              controllers[index]["nationNumEnabled"] = false;
                                                              controllers[index]["phoneNumEnabled"] = false;
                                                            });
                                                          },
                                                          child: Text(
                                                            "إلغاء",
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 14,
                                                              color: Colors.green,
                                                            ),
                                                          )
                                                      )),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )

                                  );
                                });
                              }
                          );
                        },
                            trailingColor: Colors.red);
                      },
                    ),
                  );
                }),

              ],
            ),
          )
      ),
    );
  }
}
//  ...List.generate(doctors.length, (index){
//    return MyCard(
//        title: doctors[index]["docName"],
//        subtitle: doctors[index]["specialization"],
//        trailing: "انقر لرؤية المزيد",
//        //عند الضغط على الطبيب سيظهر اليرت بالمزيد من التفاصي للتعديل عليها
//        onTap: () {
//          final parentContext = context;
//          showDialog(
//              context: context,
//              builder: (dialogContext){
//                return StatefulBuilder(builder: (context,setDialogState){
//                  //الاليرت
//                  return Dialog(
//                      child:  Directionality(
//                        textDirection: TextDirection.rtl,
//                        child: SingleChildScrollView(
//                          child: Container(
//                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
//                            decoration: BoxDecoration(
//                                color: Colors.white,
//                                boxShadow: [
//                                  BoxShadow(color: Colors.black,offset: Offset(-5, 5),blurRadius: 5)
//                                ],
//                                borderRadius: BorderRadius.circular(20)
//                            ),
//                            child: Column(
//                              textDirection: TextDirection.rtl,
//                              mainAxisSize: MainAxisSize.min,
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: [
//                                //عنوان الاليرت والذي هو اسم الطبيب
//                                Text(
//                                  doctors[index]["docName"],
//                                  style: Theme.of(context).textTheme.titleMedium,
//                                ),
//                                SizedBox(height: 20,),
//                                //سطر رقم هاتف الطبيب
//                                Row(
//                                  children: [
//                                    //حقل رقم الهاتف ولكن سيكون disabled بالبداية
//                                    Expanded(
//                                      flex : 3,
//                                      child: InputField(
//                                          hint: "${doctors[index]["phoneNum"]}",
//                                          icon: Icon(Icons.phone),
//                                          isObscure: false,
//                                          controller: controllers[index]["phoneController"],
//                                          enabled: controllers[index]["phoneNumEnabled"]
//                                      ),
//                                    ),
//                                    //زر التعديل على حقل رقم الهاتف والذي سيجعل الحقلenabled
//                                    Expanded(
//                                        child: TextButton(
//                                            onPressed: (){
//                                              setDialogState(() {
//                                                controllers[index]["phoneNumEnabled"] = true;
//                                              });
//                                            },
//                                            child: Text(
//                                              "تعديل",
//                                              style: TextStyle(
//                                                fontSize: 16,
//                                                fontWeight: FontWeight.w500,
//                                                color: Colors.blueAccent,
//                                              ),
//                                            )
//                                        )
//                                    ),
//                                  ],
//                                ),
//                                SizedBox(height: 10,),
//                                //سطر رقم الطبيب الوطني
//                                Row(
//                                  children: [
//                                    //حقل الرقم الوطني ولكن سيكون disabled بالبداية
//                                    Expanded(
//                                      flex : 3,
//                                      child: InputField(
//                                          hint: "${doctors[index]["nationNum"]}",
//                                          icon: Icon(Icons.numbers),
//                                          isObscure: false,
//                                          controller: controllers[index]["nationNumController"],
//                                          enabled: controllers[index]["nationNumEnabled"]
//                                      ),
//                                    ),
//                                    //زر التعديل على حقل الرقم الوطني والذي سيجعل الحقلenabled
//                                    Expanded(
//                                        child: TextButton(
//                                            onPressed: (){
//                                              setDialogState(() {
//                                                controllers[index]["nationNumEnabled"] = true;
//                                              });
//                                            },
//                                            child: Text(
//                                              "تعديل",
//                                              style: TextStyle(
//                                                fontSize: 16,
//                                                fontWeight: FontWeight.w500,
//                                                color: Colors.blueAccent,
//                                              ),
//                                            )
//                                        )
//                                    ),
//                                  ],
//                                ),
//                                SizedBox(height: 10,),
//                                //زر حذف الطبيب من المركز
//                                MyButton(
//                                    onPressed: (){
//                                      //عند الضغط على الزر سيظهر dialog لتأكيد الجذف
//                                      Navigator.of(dialogContext).pop();
//                                      AwesomeDialog(
//                                          context: parentContext,
//                                          title: "هل أنت متأكد من حذف المريض",
//                                          dialogType: DialogType.warning,
//                                          animType: AnimType.rightSlide,
//                                          btnOkOnPress: (){},
//                                          btnCancelOnPress: (){},
//                                          btnOkText: "حذف",
//                                          btnCancelText: "إلغاء",
//                                          btnCancelColor: Colors.green,
//                                          btnOkColor: Colors.red
//                                      ).show();
//                                    },
//                                    label: "حذف الطبيب",
//                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
//                                    fontSize: 16,
//                                    btnColor: Colors.redAccent
//                                ),
//                                SizedBox(height: 10,),
//                                //أزرار حفظ التعديل والإلغاء
//                                Row(
//                                  children: [
//                                    //زر حفظ التغييرات
//                                    Expanded(child: TextButton(
//                                        onPressed: (){
//                                          //عند الضغط عليه سيظهر dialog لتأكيد التعديل
//                                          Navigator.of(dialogContext).pop();
//                                          AwesomeDialog(
//                                              context: parentContext,
//                                              title: "هل أنت متأكد من التعديل",
//                                              dialogType: DialogType.warning,
//                                              animType: AnimType.rightSlide,
//                                              btnOkOnPress: (){},
//                                              btnCancelOnPress: (){},
//                                              btnOkText: "تعديل",
//                                              btnCancelText: "إلغاء",
//                                              btnCancelColor: Colors.green,
//                                              btnOkColor: Colors.red
//                                          ).show();
//                                        },
//                                        child: Text(
//                                          "حفظ التغييرات",
//                                          style: TextStyle(
//                                            fontWeight: FontWeight.w400,
//                                            fontSize: 14,
//                                            color: Colors.red,
//                                          ),
//                                        )
//                                    )),
//                                    //زر الإلغاء عند الضغط عليه سيتم إزالة الاليرت وعد التعديل
//                                    Expanded(child: TextButton(
//                                        onPressed: (){
//                                          Navigator.of(dialogContext).pop();
//                                        },
//                                        child: Text(
//                                          "إلغاء",
//                                          style: TextStyle(
//                                            fontWeight: FontWeight.w400,
//                                            fontSize: 14,
//                                            color: Colors.green,
//                                          ),
//                                        )
//                                    )),
//                                  ],
//                                )
//                              ],
//                            ),
//                          ),
//                        ),
//                      )
//
//                  );
//                });
//              }
//          );
//        },
//        trailingColor: Colors.green
//    );
//  }
// List doctors = [
//   {
//     "docName" : "د.سمير خضورة",
//     "nationNum" : 060601045645234,
//     "phoneNum" : 0992267248,
//     "specialization" : "أطفال",
//   },
//   {
//     "docName" : "د.عائد عبدالله",
//     "nationNum" : 060601045645234,
//     "phoneNum" : 0992267248,
//     "specialization" : "داخلية",
//   },
//   {
//     "docName" : "د.فداء علواني",
//     "nationNum" : 060601045645234,
//     "phoneNum" : 0992267248,
//     "specialization" : "صدرية",
//   },
//   {
//     "docName" : "د.مي شهاب",
//     "nationNum" : 060601045645234,
//     "phoneNum" : 0992267248,
//     "specialization" : "عينية",
//   },
//   {
//     "docName" : "د.إيفا حنينو",
//     "nationNum" : 060601045645234,
//     "phoneNum" : 0992267248,
//     "specialization" : "أسنان",
//   },
//   {
//     "docName" : "د.بسام شحادة",
//     "nationNum" : 060601045645234,
//     "phoneNum" : 0992267248,
//     "specialization" : "أذنية",
//   },
//   {
//     "docName" : "د.عادل اسماعيل",
//     "nationNum" : 060601045645234,
//     "phoneNum" : 0992267248,
//     "specialization" : "جلدية",
//   },
// ];