import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispensary/components/card_widget.dart';
import 'package:dispensary/components/input_field.dart';
import 'package:dispensary/components/main_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class PatientsList extends StatefulWidget {
  const PatientsList({super.key});

  @override
  State<PatientsList> createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  //مصفوفة لتخزين المرضى الذين يتم البحث عنهم
  List<QueryDocumentSnapshot> patients = [];
  GlobalKey<FormState> editKey = GlobalKey();
  //متغير للتأكد فيما إذا كان قد تم البحث ام لا
  bool searched = false;
  //متغير يعبر عن إذا كان حقل التعديل الخاص بالعمر مفتوح ومتاح للتعديل
  bool isAgeEnabled = false;
  //متغير يعبر عن إذا كان حقل التعديل الخاص برقم الهاتف مفتوح ومتاح للتعديل
  bool isPhoneEnabled = false;
  //متغير يعبر عن إذا كان حقل التعديل الخاص بالرقم الوطني مفتوح ومتاح للتعديل
  bool isNationNumEnabled = false;
  GlobalKey<FormState> nameKey = GlobalKey();
  //القائمة الخاصة بالcontrollers الخاصة للحقول لكل مريض
  List controllers = [];
  //الcontrollers الخاصين بحقول البحث (الاسم الاول|الاسم الثاني)
  late TextEditingController fNameController;
  late TextEditingController lNameController;
  //التابع الخاص بجلب المرضى عند البحث
  getPatients(String fName,String lName) async{
    controllers.clear();
    //اولا يتم جلب المستوصف الحالي
    final dispensary =
    await FirebaseFirestore.instance
        .collectionGroup("dispensaries")
        .where(
        "admins",
        arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .limit(1).get();
    //ثانيا يتم حلب المرضى الذين اسمهم يوافق مدخلات البحث
    final ptns = await dispensary.docs.first.reference
        .collection("patients")
        .where("firstName",isEqualTo: fName)
        .where("lastName",isEqualTo: lName).get();
    patients = ptns.docs;
    //يتم تعبئة controllers بعدد المرضى الذين تم الحصول عليهم
    for(int i=0;i<patients.length;i++){
      controllers.add({
        "ageController" : TextEditingController(),
        "phoneController" : TextEditingController(),
        "nationNumController" : TextEditingController(),
      });
    }

  }
  @override
  void initState() {
    fNameController = TextEditingController();
    lNameController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    fNameController.dispose();
    lNameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //عنوان الصفحة
      appBar: AppBar(
        title: Text("قائمة المرضى"),
        centerTitle: true,
      ),
      //جسم الصفحة
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Form(
          key: nameKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              //كونتينر فيه نص توضيحي يشرح آلية البحث
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        offset: Offset(-5, 5),
                        color: Colors.grey
                      )
                    ]
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "هذه الصفحة تحتوي على مرضى المستوصف يحب إدخال اسم المريض المطلوب للبحث عنه والحصول على بياناته",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              //نص توضيحي لحقل الاسم الأول الخاص بالبحث
              Text(
                "الاسم الأول للمريض",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              //حقل الاسم الأول الخاص بالبحث
              InputField(
                  hint: "أدخل اسم المريض الأول",
                  icon: Icon(Icons.person),
                  isObscure: false,
                  controller: fNameController,
                  enabled: true,
                  inputType: TextInputType.name,
                  validator: (val){
                    if(val == "" || val == null){
                      return "لا يمكن ترك الحقل فارغا";
                    }
                  },
              ),
              SizedBox(height: 10,),
              //نص توضيحي لحقل الاسم الأخير الخاص بالبحث
              Text(
                "الاسم الأخير للمريض",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              //نص توضيحي لحقل الاسم الأخير الخاص بالبحث
              InputField(
                hint: "أدخل اسم المريض الأخير",
                icon: Icon(Icons.person),
                isObscure: false,
                controller: lNameController,
                enabled: true,
                inputType: TextInputType.name,
                validator: (val){
                  if(val == "" || val == null){
                    return "لا يمكن ترك الحقل فارغا";
                  }
                },
              ),
              SizedBox(height: 10,),
              //زر البحث
              MyButton(
                  onPressed: () async{
                    //عند الضغط عليه سيتحقق من صحة المدخلات أولا
                    if(nameKey.currentState!.validate()){
                      //ّإذا كانت صحيحة سيتم تنفيذ تابع البحث وجلب المرضى
                      await getPatients(fNameController.text.trim(), lNameController.text.trim());

                        setState(() {
                          searched = true;
                        });

                    }
                  },
                  label: "بحث",
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  fontSize: 16,
                  btnColor: Colors.blueAccent
              ),
              SizedBox(height: 20,),
              //هنا يتم اختبار فيما إذا كان فد تم البحث ولم يجد مريض بهذا الاسم
              //سيتم إظهار رسالة توضيحية في هذه الحالة
              if(searched && patients.isEmpty)
                //الرسالة التوضيحية
                Text(
                  "هذا المريض غير موجود بالمستوصف",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black
                  ),
                ),
              //هنا في حال تم إيجاد مرضى بهذا الاسم
              if(searched && patients.isNotEmpty)
                //سيتم بناء قائمة بهؤلاء المرضى
                ...List.generate(patients.length, (index){
                  //كل مريض عبارة عن card
                  return MyCard(
                      title: "${patients[index]["firstName"]} ${patients[index]["lastName"]}",
                      subtitle: patients[index]["nationNum"],
                      trailing: "انقر لرؤية المزيد",
                      onTap: () {
                        //عند الضغط على المريض سيظهرdialog يحتوي البيانات الحالية للتعديل عليها
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
                                            key: editKey,
                                            child: Column(
                                              textDirection: TextDirection.rtl,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                //عنوان الاليرت والذي هو اسم المريض
                                                Text(
                                                  "${patients[index]["firstName"]} ${patients[index]["lastName"]}",
                                                  style: Theme.of(context).textTheme.titleMedium,
                                                ),
                                                SizedBox(height: 20,),
                                                //سطر عمر المريض
                                                Row(
                                                  children: [
                                                    //حقل العمر ولكن سيكون disabled بالبداية
                                                    Expanded(
                                                      flex : 3,
                                                      child: InputField(
                                                          hint: "${patients[index]["age"]}",
                                                          icon: Icon(Icons.elderly),
                                                          inputType: TextInputType.number,
                                                          isObscure: false,
                                                          controller: controllers[index]["ageController"],
                                                          enabled: isAgeEnabled,
                                                        validator: (val){
                                                          if(isAgeEnabled && val == ""){
                                                            return "لا يمكن ترك الحقل فارغا";
                                                          }
                                                          if(isAgeEnabled && val!.contains(new RegExp(r'[a-zA-z]'))){
                                                            return "إدخال خاطئ";
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    //زر التعديل على حقل العمر والذي سيجعل الحقلenabled
                                                    Expanded(
                                                        child: TextButton(
                                                            onPressed: (){
                                                              setDialogState(() {
                                                                isAgeEnabled = true;
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
                                                //سطر رقم هاتف المريض
                                                Row(
                                                  children: [
                                                    //حقل رقم الهاتف ولكن سيكون disabled بالبداية
                                                    Expanded(
                                                      flex : 3,
                                                      child: InputField(
                                                          hint: "${patients[index]["phone"]}",
                                                          icon: Icon(Icons.phone),
                                                          inputType: TextInputType.number,
                                                          isObscure: false,
                                                          controller: controllers[index]["phoneController"],
                                                          enabled: isPhoneEnabled,
                                                        validator: (val){
                                                          if(isPhoneEnabled && val == ""){
                                                            return "لا يمكن ترك الحقل فارغا";
                                                          }
                                                          if(isPhoneEnabled && val!.contains(new RegExp(r'[a-zA-z]'))){
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
                                                                isPhoneEnabled = true;
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
                                                //سطر رقم المريض الوطني
                                                Row(
                                                  children: [
                                                    //حقل الرقم الوطني ولكن سيكون disabled بالبداية
                                                    Expanded(
                                                      flex : 3,
                                                      child: InputField(
                                                          hint: "${patients[index]["nationNum"]}",
                                                          inputType: TextInputType.number,
                                                          icon: Icon(Icons.numbers),
                                                          isObscure: false,
                                                          controller: controllers[index]["nationNumController"],
                                                          enabled: isNationNumEnabled,
                                                          validator: (val){
                                                            if(isNationNumEnabled && val == ""){
                                                              return "لا يمكن ترك الحقل فارغا";
                                                            }
                                                            if(isNationNumEnabled && val!.contains(new RegExp(r'[a-zA-z]'))){
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
                                                                isNationNumEnabled = true;
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
                                                //زر سويتش لحظر المريض وجعله غير قايل لحجز موعد
                                                Card(
                                                  shape: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                      borderSide: BorderSide(color: patients[index]["available"] ? Colors.red : Colors.blueAccent)
                                                  ),
                                                  elevation: 7,
                                                  shadowColor: Colors.grey,
                                                  child: SwitchListTile(
                                                    value: !patients[index]["available"],
                                                    onChanged: (val)async{
                                                        await patients[index].reference.update({
                                                          "available" : !val
                                                        });
                                                      // setDialogState((){
                                                      //   patients[index]["available"] = !val;
                                                      // });

                                                    },
                                                    title : Text(
                                                      "حظر المريض",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      "عند حظر المريض سيصبح غير قادر على حجز موعد",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.w300
                                                      ),
                                                    ),
                                                    activeTrackColor: Colors.blueAccent,
                                                    inactiveTrackColor: Colors.grey,
                                                    thumbColor: WidgetStatePropertyAll(Colors.white),
                                                    trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
                                                  ),
                                                ),
                                                SizedBox(height: 10,),
                                                //زر حذف المريض من المركز
                                                MyButton(
                                                    onPressed: (){
                                                      //عند الضغط على الزر سيظهر dialog لتأكيد الجذف
                                                      Navigator.of(dialogContext).pop();
                                                      AwesomeDialog(
                                                          context: parentContext,
                                                          title: "هل أنت متأكد من حذف المريض",
                                                          dialogType: DialogType.warning,
                                                          animType: AnimType.rightSlide,
                                                          btnOkOnPress: () async{
                                                            await patients[index].reference.delete();
                                                          },
                                                          btnCancelOnPress: (){
                                                          },
                                                          btnOkText: "حذف",
                                                          btnCancelText: "إلغاء",
                                                          btnCancelColor: Colors.red,
                                                          btnOkColor: Colors.green
                                                      ).show();
                                                    },
                                                    label: "حذف المريض",
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
                                                          if(editKey.currentState!.validate()) {
                                                            //عند الضغط عليه سيظهر dialog لتأكيد التعديل
                                                            Navigator
                                                                .of(
                                                                dialogContext)
                                                                .pop();
                                                            AwesomeDialog(
                                                              dismissOnTouchOutside: false,
                                                                context: parentContext,
                                                                title: "هل أنت متأكد من التعديل",
                                                                dialogType: DialogType
                                                                    .warning,
                                                                animType: AnimType
                                                                    .rightSlide,
                                                                btnOkOnPress: () {
                                                                  if(isAgeEnabled){
                                                                    patients[index].reference.update(
                                                                        {
                                                                          "age" : controllers[index]["ageController"].text
                                                                        });
                                                                  }
                                                                  if(isNationNumEnabled){
                                                                    patients[index].reference.update(
                                                                        {
                                                                          "nationNum" : controllers[index]["nationNumController"].text
                                                                        });
                                                                  }
                                                                  if(isPhoneEnabled){
                                                                    patients[index].reference.update(
                                                                        {
                                                                          "phone" : controllers[index]["phoneController"].text
                                                                        });
                                                                  }
                                                                  ScaffoldMessenger
                                                                      .of(
                                                                      parentContext)
                                                                      .showSnackBar(
                                                                      SnackBar(
                                                                        content: Text(
                                                                            "تم التعديل"),
                                                                        duration: Duration(
                                                                            seconds: 1),));
                                                                  controllers[index]["ageController"]
                                                                      .text =
                                                                  "";
                                                                  controllers[index]["nationNumController"]
                                                                      .text =
                                                                  "";
                                                                  controllers[index]["phoneController"]
                                                                      .text =
                                                                  "";
                                                                  isAgeEnabled =
                                                                  false;
                                                                  isPhoneEnabled =
                                                                  false;
                                                                  isNationNumEnabled =
                                                                  false;
                                                                },
                                                                btnCancelOnPress: () {
                                                                  setState(() {
                                                                    controllers[index]["ageController"]
                                                                        .text =
                                                                    "";
                                                                    controllers[index]["nationNumController"]
                                                                        .text =
                                                                    "";
                                                                    controllers[index]["phoneController"]
                                                                        .text =
                                                                    "";
                                                                    isAgeEnabled =
                                                                    false;
                                                                    isPhoneEnabled =
                                                                    false;
                                                                    isNationNumEnabled =
                                                                    false;
                                                                  });
                                                                },
                                                                btnOkText: "تعديل",
                                                                btnCancelText: "إلغاء",
                                                                btnCancelColor: Colors
                                                                    .red,
                                                                btnOkColor: Colors
                                                                    .green
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
                                                          controllers[index]["ageController"]
                                                              .text =
                                                          "";
                                                          controllers[index]["nationNumController"]
                                                              .text =
                                                          "";
                                                          controllers[index]["phoneController"]
                                                              .text =
                                                          "";
                                                          isAgeEnabled = false;
                                                          isPhoneEnabled = false;
                                                          isNationNumEnabled = false;
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
                      trailingColor: Colors.green
                  );
                })

            ],
          ),
        ),
      ),
    );
  }
}
