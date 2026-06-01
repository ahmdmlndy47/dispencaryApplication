import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dispensary/components/card_widget.dart';
import 'package:dispensary/components/input_field.dart';
import 'package:dispensary/components/main_button.dart';
import 'package:flutter/material.dart';
class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}
// الصفحة الرئيسية للآدمن
class _AdminHomepageState extends State<AdminHomepage> {
  List clinics = [
    {
      "clinicName" : "عيادة الأطفال",
      "docName" : "د.سمير خضورة",
    },
    {
      "clinicName" : "العيادة الداخلية",
      "docName" : "د.عائد عيدالله",
    },
    {
      "clinicName" : "العيادة الصدرية",
      "docName" : "د.فداء علواني",
    },
    {
      "clinicName" : "العيادة العينية",
      "docName" : "د.مي شهاب",
    },
    {
      "clinicName" : "عيادة الأسنان",
      "docName" : "د.إيفا حنينو",
    },
    {
      "clinicName" : "عيادة الأذنية",
      "docName" : "د.بسام شحادة",
    },
    {
      "clinicName" : "العيادة الجلدية",
      "docName" : "د.عادل اسماعيل",
    },
  ];
  String? selectedDoc;
  final TextEditingController addingClinicController = TextEditingController();
  final Icon clinicIcon = Icon(Icons.medical_information);
  final Icon doctorIcon = Icon(Icons.person);
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("المدير",),
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
                            onPressed: (){
                              Navigator.of(context).pushNamed("addPatientPage");
                            },
                            btnColor: Colors.blueAccent,
                            fontSize: 18,
                            label: "إضافة مريض",
                            shape: RoundedRectangleBorder()),
                      ),
                      SizedBox(width: 20,),
                      // زر إضافة طبيب
                      Expanded(
                        child: MyButton(
                            onPressed: (){
                              Navigator.of(context).pushNamed("addDoctorPage");
                            },
                            btnColor: Colors.blueAccent,
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
                            onPressed: (){
                              Navigator.of(context).pushNamed("patientList");
                            },
                            btnColor: Colors.blueAccent,
                            fontSize: 18,
                            label: "مرضى المستوصف",
                            shape: RoundedRectangleBorder()),
                      ),
                      SizedBox(width: 20,),
                      // زر لعرض قائمة أطباء المستوصف
                      Expanded(
                        child:MyButton(
                            onPressed: (){
                              Navigator.of(context).pushNamed("doctorsList");
                            },
                            btnColor: Colors.blueAccent,
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
                                        DropdownButtonFormField(
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.person),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(20)
                                              ),
                                              hintText: "اسم الطبيب",
                                            ),
                                            items: clinics.map<DropdownMenuItem<String>>((clinic){
                                              return DropdownMenuItem(
                                                value: clinic["docName"],
                                                child: Text(clinic["docName"]),
                                              );
                                            }).toList(),
                                            onChanged: (val){
                                              setState(() {
                                                selectedDoc = val;
                                              });
                                            }),
                                        SizedBox(height: 20,),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: TextButton(
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
                                              ),
                                              Expanded(
                                                child: TextButton(
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
                                                                    SizedBox(height: 10,),
                                                                    Text("اسم الطبيب: $selectedDoc"),

                                                                  ],
                                                                ),
                                                                actionsAlignment: MainAxisAlignment.spaceBetween,
                                                                actions: [
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
                                              ),
                                            ],
                                          ),

                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      btnColor: Colors.blueAccent,
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
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10,),
            ...List.generate(
                clinics.length,
                (index)=> MyCard(
                    title: clinics[index]["clinicName"],
                    subtitle: clinics[index]["docName"],
                    trailing: "انقر للتعديل",
                    trailingColor: Colors.red,
                    onTap: (){
                      final parentContext = context;
                      //عند الضغط على العيادة سيظهر بوب اب التعديل
                      showDialog(
                          context: context,
                          builder: (dialogContext){
                            //البوب اب الذي سيظهر
                            return Dialog(
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      //عتوان بوب اب التعديل
                                      Text(
                                        "التعديل على العيادة",
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 30,),
                                      //السيليكشن الخاصة باسماء الأطباء
                                      Form(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Column(
                                            children: [
                                              DropdownButtonFormField(
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(Icons.person),
                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(20)
                                                    ),
                                                    hintText: "اسم الطبيب",
                                                  ),
                                                  items: clinics.map<DropdownMenuItem<String>>((clinic){
                                                    return DropdownMenuItem(
                                                      value: clinic["docName"],
                                                      child: Text(
                                                        clinic["docName"],
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (val){
                                                    setState(() {
                                                      selectedDoc = val;
                                                    });
                                                  }),
                                              SizedBox(height: 20,),
                                              MyButton(
                                                  onPressed: (){
                                                    final messenger = ScaffoldMessenger.of(parentContext);
                                                    Navigator.of(dialogContext).pop();
                                                    AwesomeDialog(
                                                      context: parentContext,
                                                      title: "حذف عيادة",
                                                      desc: "هل انت متأكد من حذف العيادة",
                                                      dialogType: DialogType.error,
                                                      animType: AnimType.rightSlide,
                                                      btnCancelText: "لا",
                                                      btnOkText: "نعم",
                                                      showCloseIcon: true,
                                                      btnCancelOnPress: (){},
                                                      btnOkOnPress: (){
                                                        messenger.showSnackBar(
                                                          SnackBar(
                                                            content: Text("تم الحذف"),
                                                            duration: Duration(seconds: 1),
                                                          )
                                                        );
                                                      }
                                                    ).show();
                                                  },
                                                  btnColor: Colors.red,
                                                  label: "حذف العيادة",
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  fontSize: 18)
                                            ],
                                          ),
                                        ),),
                                      SizedBox(height: 80,),
                                      //أزرار التأكيد و الإلغاء
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          //زر الإلغاء
                                          Expanded(
                                            child: TextButton(
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "إلغاء",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w300,
                                                      color: Colors.red
                                                  ),)),
                                          ),
                                          //زر التأكيد
                                          Expanded(
                                            child: TextButton(
                                                onPressed: (){
                                                  final messenger = ScaffoldMessenger.of(parentContext);
                                                  Navigator.of(dialogContext).pop();
                                                  AwesomeDialog(
                                                      context: parentContext,
                                                      title: "تعديل العيادة",
                                                      desc: "هل انت متأكد من التعديل",
                                                      dialogType: DialogType.warning,
                                                      animType: AnimType.rightSlide,
                                                      btnCancelText: "لا",
                                                      btnOkText: "نعم",
                                                      showCloseIcon: true,
                                                      btnCancelOnPress: (){},
                                                      btnOkOnPress: (){
                                                        messenger.showSnackBar(
                                                            SnackBar(
                                                              content: Text("تم التعديل"),
                                                              duration: Duration(seconds: 1),
                                                            )
                                                        );
                                                      }
                                                  ).show();
                                                },
                                                child: Text(
                                                  "تعديل",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w300,
                                                      color: Colors.red
                                                  ),)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                )
            )
          ],
        ),
      ),
    );
  }
}
