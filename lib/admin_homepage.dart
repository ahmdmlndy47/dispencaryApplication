import 'package:dispensary/components/card_widget.dart';
import 'package:dispensary/components/input_field.dart';
import 'package:dispensary/components/main_button.dart';
import 'package:dispensary/components/my_editing_alert.dart';
import 'package:flutter/material.dart';
class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}
// الصفحة الرئيسية للآدمن
class _AdminHomepageState extends State<AdminHomepage> {
  final TextEditingController addingClinicController = TextEditingController();
  final String _editingClinicDocNameHint = "اسم الطبيب";
  final Icon clinicIcon = Icon(Icons.medical_information);
  final Icon doctorIcon = Icon(Icons.person);
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "المدير",
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        //زر تسجيل الخروج
        actions: [
          ElevatedButton.icon(
            onPressed: (){
              Navigator.of(context).pushNamed("logOrSignPage");
            },
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blueAccent.shade700)
            ),
            label: Text(
              "تسجيل الخروج",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white
              ),
            ),
            icon: Icon(Icons.logout,color: Colors.white,),
            iconAlignment: IconAlignment.end,
          )
        ],
        backgroundColor: Colors.blueAccent,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          children: [
            //أزرار الإضافة والتعديل على المرضى والأطباء
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                        offset: Offset(-5, 5))
                  ]
              ),
              child: Column(
                children: [
                  //أزرار إضافة المستخدمين
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //زر إضافة مريض
                      Expanded(
                        child: MyButton(
                            onPressed: (){},
                            fontSize: 18,
                            label: "إضافة مريض",
                            shape: RoundedRectangleBorder()),
                      ),
                      SizedBox(width: 20,),
                      // زر إضافة طبيب
                      Expanded(
                        child: MyButton(
                            onPressed: (){},
                            fontSize: 18,
                            label: "إضافة طبيب",
                            shape: RoundedRectangleBorder()),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  //أزرار التعديل على المستخدمين
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //زر لعرض قائمة المرضى المسجلين بالتطبيق
                      Expanded(
                        child: MyButton(
                            onPressed: (){},
                            fontSize: 18,
                            label: "مرضى المستوصف",
                            shape: RoundedRectangleBorder()),
                      ),
                      SizedBox(width: 20,),
                      // زر لعرض قائمة أطباء المستوصف
                      Expanded(
                        child:MyButton(
                            onPressed: (){},
                            fontSize: 18,
                            label: "أطباء المستوصف",
                            shape: RoundedRectangleBorder()),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  //زر لإضافة عيادة
                  MyButton(
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (context){
                              return Dialog(
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "أدخل معلومات العيادة التي سوف تضيفها",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        InputField(
                                            hint: "اسم العيادة",
                                            icon: Icon(Icons.medical_information),
                                            isObscure: false,
                                            controller: addingClinicController,
                                            enabled: true,
                                            validator: (val){}
                                        ),
                                        SizedBox(height: 20,),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton(
                                                    onPressed: (){
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text(
                                                      "إلغاء",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w300,
                                                          color: Colors.blueAccent
                                                      ),)),
                                              TextButton(
                                                  onPressed: (){
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                        context: context,
                                                        builder: (context){
                                                          return Directionality(
                                                            textDirection: TextDirection.rtl,
                                                            child: AlertDialog(
                                                              title: Text(
                                                                "هل انت متأكد من إضافة هذه العيادة:",
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.black
                                                                ),
                                                              ),
                                                              content: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text("اسم العيادة:${addingClinicController.text}"),
                                                                ],
                                                              ),
                                                              actions: [
                                                                //زر الإلغاء
                                                                TextButton(
                                                                  onPressed: (){
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: Text(
                                                                    "لا",
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.blueAccent
                                                                    ),
                                                                  ),
                                                                ),
                                                                //زر التأكيد
                                                                TextButton(
                                                                  onPressed: (){
                                                                    //عند التأكيد سنرجع لصفحة الآدمن ويظهر سناك بار بالتأكيد
                                                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                                                        "adminHomepage",
                                                                            (route)=> false);
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(
                                                                          content: Text("تمت الإضافة"),
                                                                          duration: Duration(seconds: 1),
                                                                        ));
                                                                  },
                                                                  child: Text(
                                                                    "نعم",
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.blueAccent
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Text(
                                                    "إضافة",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w300,
                                                        color: Colors.blueAccent
                                                    ),)),
                                            ],
                                          ),

                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      label: "إضافة عيادة للمستوصف",
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)
                      ),
                      fontSize: 18
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            //قائمة عيادات المستوصف للتعديل عليها من قبل الآدمن
            Text(
              "عيادات المستوصف",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(height: 10,),
            //عيادة الأطفال
            MyCard(
                title: "عيادة الأطفال",
                subtitle: "د.سمير خضورة",
                trailing: "انقر للتعديل",
                onTap: (){
                  //عند الضغط على العيادة سيظهر بوب اب التعديل
                  showDialog(
                      context: context,
                      builder: (context){
                        //البوب اب الذي سيظهر
                        return MyEditingAlert(
                          doctorHint: _editingClinicDocNameHint,
                          iconHint: Icon(Icons.person),
                          fieldController: editingController,
                          isFieldSecure: false,
                          enabledField: true,
                          //عند تأكيد التعديل سيظهر اليرت لتأكيد التعديل النهائي
                          onVerifyPressed: (){
                            Navigator.of(context).pop();
                            //ليرت التأكيد
                            showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text(
                                      "هل أنت متأكد أنك تريد التعديل",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceBetween,
                                    actions: [
                                      //زر الإلغاء
                                      TextButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "لا",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent
                                          ),
                                        ),
                                      ),
                                      //زر التأكيد
                                      TextButton(
                                        onPressed: (){
                                          //عند التأكيد سنرجع لصفحة الآدمن ويظهر سناك بار بالتأكيد
                                          Navigator.of(context).pushNamedAndRemoveUntil(
                                              "adminHomepage",
                                                  (route)=> false);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("تم التعديل"),
                                                duration: Duration(seconds: 1),
                                              ));
                                        },
                                        child: Text(
                                          "نعم",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                        );
                      });
                }),
            SizedBox(height: 10,),
            //العيادة الداخلية
            MyCard(
                title: "العيادة لداخلية",
                subtitle: "د.سمير خضورة",
                trailing: "انقر للتعديل",
                onTap: (){
                  //عند الضغط على العيادة سيظهر بوب اب التعديل
                  showDialog(
                      context: context,
                      builder: (context){
                        //البوب اب الذي سيظهر
                        return MyEditingAlert(
                          doctorHint: _editingClinicDocNameHint,
                          iconHint: Icon(Icons.person),
                          fieldController: editingController,
                          isFieldSecure: false,
                          enabledField: true,
                          //عند تأكيد التعديل سيظهر اليرت لتأكيد التعديل النهائي
                          onVerifyPressed: (){
                            Navigator.of(context).pop();
                            //ليرت التأكيد
                            showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text(
                                      "هل أنت متأكد أنك تريد التعديل",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceBetween,
                                    actions: [
                                      //زر الإلغاء
                                      TextButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "لا",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent
                                          ),
                                        ),
                                      ),
                                      //زر التأكيد
                                      TextButton(
                                        onPressed: (){
                                          //عند التأكيد سنرجع لصفحة الآدمن ويظهر سناك بار بالتأكيد
                                          Navigator.of(context).pushNamedAndRemoveUntil(
                                              "adminHomepage",
                                                  (route)=> false);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("تم التعديل"),
                                                duration: Duration(seconds: 1),
                                              ));
                                        },
                                        child: Text(
                                          "نعم",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                        );
                      });
                }),
            SizedBox(height: 10,),
            //العيادة الصدرية
            MyCard(
                title: "العيادة الصدرية",
                subtitle: "د.سمير خضورة",
                trailing: "انقر للتعديل",
                onTap: (){
                  //عند الضغط على العيادة سيظهر بوب اب التعديل
                  showDialog(
                      context: context,
                      builder: (context){
                        //البوب اب الذي سيظهر
                        return MyEditingAlert(
                          doctorHint: _editingClinicDocNameHint,
                          iconHint: Icon(Icons.person),
                          fieldController: editingController,
                          isFieldSecure: false,
                          enabledField: true,
                          //عند تأكيد التعديل سيظهر اليرت لتأكيد التعديل النهائي
                          onVerifyPressed: (){
                            Navigator.of(context).pop();
                            //ليرت التأكيد
                            showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text(
                                      "هل أنت متأكد أنك تريد التعديل",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceBetween,
                                    actions: [
                                      //زر الإلغاء
                                      TextButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "لا",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent
                                          ),
                                        ),
                                      ),
                                      //زر التأكيد
                                      TextButton(
                                        onPressed: (){
                                          //عند التأكيد سنرجع لصفحة الآدمن ويظهر سناك بار بالتأكيد
                                          Navigator.of(context).pushNamedAndRemoveUntil(
                                              "adminHomepage",
                                                  (route)=> false);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("تم التعديل"),
                                                duration: Duration(seconds: 1),
                                              ));
                                        },
                                        child: Text(
                                          "نعم",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                        );
                      });
                }),
            SizedBox(height: 10,),
            //العيادة العينية
            MyCard(
                title: "العيادة العينية",
                subtitle: "د.سمير خضورة",
                trailing: "انقر للتعديل",
                onTap: (){
                  //عند الضغط على العيادة سيظهر بوب اب التعديل
                  showDialog(
                      context: context,
                      builder: (context){
                        //البوب اب الذي سيظهر
                        return MyEditingAlert(
                          doctorHint: _editingClinicDocNameHint,
                          iconHint: Icon(Icons.person),
                          fieldController: editingController,
                          isFieldSecure: false,
                          enabledField: true,
                          //عند تأكيد التعديل سيظهر اليرت لتأكيد التعديل النهائي
                          onVerifyPressed: (){
                            Navigator.of(context).pop();
                            //ليرت التأكيد
                            showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text(
                                      "هل أنت متأكد أنك تريد التعديل",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceBetween,
                                    actions: [
                                      //زر الإلغاء
                                      TextButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "لا",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent
                                          ),
                                        ),
                                      ),
                                      //زر التأكيد
                                      TextButton(
                                        onPressed: (){
                                          //عند التأكيد سنرجع لصفحة الآدمن ويظهر سناك بار بالتأكيد
                                          Navigator.of(context).pushNamedAndRemoveUntil(
                                              "adminHomepage",
                                                  (route)=> false);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("تم التعديل"),
                                                duration: Duration(seconds: 1),
                                              ));
                                        },
                                        child: Text(
                                          "نعم",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                        );
                      });
                }),
            SizedBox(height: 10,),
            //عيادة الأسنان
            MyCard(
                title: "عيادة الأسنان",
                subtitle: "د.سمير خضورة",
                trailing: "انقر للتعديل",
                onTap: (){
                  //عند الضغط على العيادة سيظهر بوب اب التعديل
                  showDialog(
                      context: context,
                      builder: (context){
                        //البوب اب الذي سيظهر
                        return MyEditingAlert(
                          doctorHint: _editingClinicDocNameHint,
                          iconHint: Icon(Icons.person),
                          fieldController: editingController,
                          isFieldSecure: false,
                          enabledField: true,
                          //عند تأكيد التعديل سيظهر اليرت لتأكيد التعديل النهائي
                          onVerifyPressed: (){
                            Navigator.of(context).pop();
                            //ليرت التأكيد
                            showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text(
                                      "هل أنت متأكد أنك تريد التعديل",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceBetween,
                                    actions: [
                                      //زر الإلغاء
                                      TextButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "لا",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent
                                          ),
                                        ),
                                      ),
                                      //زر التأكيد
                                      TextButton(
                                        onPressed: (){
                                          //عند التأكيد سنرجع لصفحة الآدمن ويظهر سناك بار بالتأكيد
                                          Navigator.of(context).pushNamedAndRemoveUntil(
                                              "adminHomepage",
                                                  (route)=> false);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("تم التعديل"),
                                                duration: Duration(seconds: 1),
                                              ));
                                        },
                                        child: Text(
                                          "نعم",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                        );
                      });
                }),
            SizedBox(height: 10,),
            //العيادة الأذنية
            MyCard(
                title: "العيادة الأذنية",
                subtitle: "د.سمير خضورة",
                trailing: "انقر للتعديل",
                onTap: (){
                  //عند الضغط على العيادة سيظهر بوب اب التعديل
                  showDialog(
                      context: context,
                      builder: (context){
                        //البوب اب الذي سيظهر
                        return MyEditingAlert(
                          doctorHint: _editingClinicDocNameHint,
                          iconHint: Icon(Icons.person),
                          fieldController: editingController,
                          isFieldSecure: false,
                          enabledField: true,
                          //عند تأكيد التعديل سيظهر اليرت لتأكيد التعديل النهائي
                          onVerifyPressed: (){
                            Navigator.of(context).pop();
                            //ليرت التأكيد
                            showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text(
                                      "هل أنت متأكد أنك تريد التعديل",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceBetween,
                                    actions: [
                                      //زر الإلغاء
                                      TextButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "لا",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent
                                          ),
                                        ),
                                      ),
                                      //زر التأكيد
                                      TextButton(
                                        onPressed: (){
                                          //عند التأكيد سنرجع لصفحة الآدمن ويظهر سناك بار بالتأكيد
                                          Navigator.of(context).pushNamedAndRemoveUntil(
                                              "adminHomepage",
                                                  (route)=> false);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("تم التعديل"),
                                                duration: Duration(seconds: 1),
                                              ));
                                        },
                                        child: Text(
                                          "نعم",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                        );
                      });
                }),
            SizedBox(height: 10,),
            //العيادة الجلدية
            MyCard(
                title: "عيادة الجلدية",
                subtitle: "د.سمير خضورة",
                trailing: "انقر للتعديل",
                onTap: (){
                  //عند الضغط على العيادة سيظهر بوب اب التعديل
                  showDialog(
                      context: context,
                      builder: (context){
                        //البوب اب الذي سيظهر
                        return MyEditingAlert(
                          doctorHint: _editingClinicDocNameHint,
                          iconHint: Icon(Icons.person),
                          fieldController: editingController,
                          isFieldSecure: false,
                          enabledField: true,
                          //عند تأكيد التعديل سيظهر اليرت لتأكيد التعديل النهائي
                          onVerifyPressed: (){
                            Navigator.of(context).pop();
                            //ليرت التأكيد
                            showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text(
                                      "هل أنت متأكد أنك تريد التعديل",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceBetween,
                                    actions: [
                                      //زر الإلغاء
                                      TextButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "لا",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent
                                          ),
                                        ),
                                      ),
                                      //زر التأكيد
                                      TextButton(
                                        onPressed: (){
                                          //عند التأكيد سنرجع لصفحة الآدمن ويظهر سناك بار بالتأكيد
                                          Navigator.of(context).pushNamedAndRemoveUntil(
                                              "adminHomepage",
                                                  (route)=> false);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("تم التعديل"),
                                                duration: Duration(seconds: 1),
                                              ));
                                        },
                                        child: Text(
                                          "نعم",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                        );
                      });
                })
          ],
        ),
      ),
    );
  }
}
