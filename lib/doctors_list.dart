import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dispensary/components/card_widget.dart';
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
  List doctors = [
    {
      "docName" : "د.سمير خضورة",
      "nationNum" : 060601045645234,
      "phoneNum" : 0992267248,
      "specialization" : "أطفال",
    },
    {
      "docName" : "د.عائد عبدالله",
      "nationNum" : 060601045645234,
      "phoneNum" : 0992267248,
      "specialization" : "داخلية",
    },
    {
      "docName" : "د.فداء علواني",
      "nationNum" : 060601045645234,
      "phoneNum" : 0992267248,
      "specialization" : "صدرية",
    },
    {
      "docName" : "د.مي شهاب",
      "nationNum" : 060601045645234,
      "phoneNum" : 0992267248,
      "specialization" : "عينية",
    },
    {
      "docName" : "د.إيفا حنينو",
      "nationNum" : 060601045645234,
      "phoneNum" : 0992267248,
      "specialization" : "أسنان",
    },
    {
      "docName" : "د.بسام شحادة",
      "nationNum" : 060601045645234,
      "phoneNum" : 0992267248,
      "specialization" : "أذنية",
    },
    {
      "docName" : "د.عادل اسماعيل",
      "nationNum" : 060601045645234,
      "phoneNum" : 0992267248,
      "specialization" : "جلدية",
    },
  ];
  List controllers = [];
  @override
  void initState() {
    for(int i=0;i<doctors.length;i++){
      controllers.add({
        "name" : doctors[i]["patientName"],
        "nationNumController" : TextEditingController(),
        "phoneController" : TextEditingController(),
        "phoneNumEnabled" : false,
        "nationNumEnabled" : false,
      });
    }
    super.initState();
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
      body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            child: ListView(
              children: [
                //نص توضيحي
                Text(
                  "قائمة أطباء المركز",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                //قائمة الأطباء
                ...List.generate(doctors.length, (index){
                  return MyCard(
                      title: doctors[index]["docName"],
                      subtitle: doctors[index]["specialization"],
                      trailing: "انقر لرؤية المزيد",
                      //عند الضغط على الطبيب سيظهر اليرت بالمزيد من التفاصي للتعديل عليها
                      onTap: () {
                        final parentContext = context;
                        showDialog(
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
                                          child: Column(
                                            textDirection: TextDirection.rtl,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              //عنوان الاليرت والذي هو اسم الطبيب
                                              Text(
                                                doctors[index]["docName"],
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
                                                        hint: "${doctors[index]["phoneNum"]}",
                                                        icon: Icon(Icons.phone),
                                                        isObscure: false,
                                                        controller: controllers[index]["phoneController"],
                                                        enabled: controllers[index]["phoneNumEnabled"]
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
                                                        hint: "${doctors[index]["nationNum"]}",
                                                        icon: Icon(Icons.numbers),
                                                        isObscure: false,
                                                        controller: controllers[index]["nationNumController"],
                                                        enabled: controllers[index]["nationNumEnabled"]
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
                                                        title: "هل أنت متأكد من حذف المريض",
                                                        dialogType: DialogType.warning,
                                                        animType: AnimType.rightSlide,
                                                        btnOkOnPress: (){},
                                                        btnCancelOnPress: (){},
                                                        btnOkText: "حذف",
                                                        btnCancelText: "إلغاء",
                                                        btnCancelColor: Colors.green,
                                                        btnOkColor: Colors.red
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
                                                        //عند الضغط عليه سيظهر dialog لتأكيد التعديل
                                                        Navigator.of(dialogContext).pop();
                                                        AwesomeDialog(
                                                            context: parentContext,
                                                            title: "هل أنت متأكد من التعديل",
                                                            dialogType: DialogType.warning,
                                                            animType: AnimType.rightSlide,
                                                            btnOkOnPress: (){},
                                                            btnCancelOnPress: (){},
                                                            btnOkText: "تعديل",
                                                            btnCancelText: "إلغاء",
                                                            btnCancelColor: Colors.green,
                                                            btnOkColor: Colors.red
                                                        ).show();
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
                                    )

                                );
                              });
                            }
                        );
                      },
                      trailingColor: Colors.green
                  );
                }
                )
              ],
            ),
          )
      ),
    );
  }
}
