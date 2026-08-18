import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispensary/components/input_field.dart';
import 'package:dispensary/components/main_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//صفحة إضافة سجل طبي لمريض
class AddRecordPage extends StatefulWidget {
  final String clinicName;
  const AddRecordPage({super.key, required this.clinicName,});

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  //المفتاح الخاص بحقول السجل المضاف
  GlobalKey<FormState> recordKey = GlobalKey();
  //المفتاح الخاص بحقل الرقم الوطني
  GlobalKey<FormState> nationNumKey = GlobalKey();
  //المفتاح الخاص بحقل عدد الأدوية
  GlobalKey<FormState> medicinesKey = GlobalKey();
  //الcontroller الخاص بحقل الرقم الوطني
  late TextEditingController nationNumController;
  //الcontroller الخاص بحقل عدد الأدوية
  late TextEditingController medicinesNumController;
  //مصفوفة الcontrollers الخاصة بحقول الأدوية
  late List<TextEditingController> medicinesControllers = [];
  //الcontroller الخاص بحقل التاريخ
  late TextEditingController dateController;
  //الcontroller الخاص بحقل الأعراض المرضية
  late TextEditingController symptomsController;
  //الcontroller الخاص بحقل التشخيص المرضي
  late TextEditingController diagnosisController;
  //المتغير الخاص بالمستوصف الحالي الذي سيتم جلبه من الداتا بيس
  late QueryDocumentSnapshot dispensary;
  //المتغير الخاص بالطبيب الحالي الذي سيتم جلبه من الداتا بيس
  late QueryDocumentSnapshot doctor;
  //متغير يعبر عما إذا حدث خطأ أثناء جلب البيانات
  bool error = false;
  //متغير يعبر عما إذا كان قد تم الإنتهاء من تحميل البيانات
  bool isLoading = true;
  //تغير يعبر عما إذا كان المريض موجود
  bool isPatientExist = false;
  //متغير يعبر عن عدد الأدوية
  int medicinesNum = 0;
  //متغير لحفظ الرقم الوطني للمريض
  late String patientNationNum;
  //تابع جلب البيانات
  getData() async{
    //الحصول على الطبيب الحالي
    final doc =
    await FirebaseFirestore.instance.collectionGroup("doctors")
        .where("UID",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .limit(1).get();
    //إذا حدث خطأ أثناء جلب الطبيب سيتم تغيير قيمة المتغير error
    if(doc.docs.isEmpty){
      error = true;
      return;
    }
    //الحصول على المستوصف
    final dis =
    await FirebaseFirestore.instance.collectionGroup("dispensaries")
        .where("doctors",arrayContains: doc.docs.first["nationNum"])
        .limit(1).get();
    //إذا حدث خطأ أثناء جلب المستوصف سيتم تغيير قيمة المتغير error
    if(dis.docs.isEmpty){
      error = true;
      return;
    }
    doctor = doc.docs.first;
    dispensary = dis.docs.first;
    setState(() {isLoading = false;});
  }
  @override
  void initState() {
    super.initState();
    getData();
    nationNumController = TextEditingController();
    medicinesNumController = TextEditingController();
    dateController = TextEditingController();
    symptomsController = TextEditingController();
    diagnosisController = TextEditingController();
  }
  @override
  void dispose() {
    nationNumController.dispose();
    medicinesNumController.dispose();
    dateController.dispose();
    symptomsController.dispose();
    diagnosisController.dispose();
    for (var controller in medicinesControllers) {
      controller.dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //عنوان الصفحة
      appBar: AppBar(
        title: Text("صفحة إضافة سجل"),
        centerTitle: true,
      ),
      //جسم الصفحة
      body:
      //في حال حدث خطأ أثناء جلب البيانات ستظهر رسالة توضيحية لإعادة تحميل الصفحة
      error
          ? Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                offset: Offset(-5, 5),
                color: Colors.grey,
                blurRadius: 5
              )
            ],
            color: Colors.white
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "حدث خطأ أثناء تحميل البيانات يرجى إعادة تحميل الصفحة مجددا",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.redAccent
                ),
              ),
              SizedBox(height: 20,),
              MyButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddRecordPage(clinicName: widget.clinicName)));
                  },
                  label: "إعادة تحميل الصفحة",
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  fontSize: 18,
                  btnColor: Colors.red)
            ],
          ),
        ),
      )
      //في حال ما زال يتم تحميل البيانات ستظهر دائرة التحميل وإلا يظهر محتوى الصفحة
      : isLoading
          ? Center(child: CircularProgressIndicator(),)
          : Directionality(
          textDirection: TextDirection.rtl,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                //كونتينر فيه نص توضيحي يشرح آلية الإضافة
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade600,
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
                      "يجب أولا إدخال الرقم الوطني للتأكد أن المريض مسجل وليس لديه سجل آخر",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                //نص توضيحي لحقل الرقم الوطني
                Text(
                  "الرقم الوطني",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                //حقل إدخال الرقم الوطني
                Form(
                  key: nationNumKey,
                  child: InputField(
                      hint: "أدخل الرقم الوطني",
                      icon: Icon(Icons.numbers),
                      isObscure: false,
                      controller: nationNumController,
                      enabled: true,
                      inputType: TextInputType.number,
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
                SizedBox(height: 10,),
                //زر التحقق من الرقم الوطني
                MyButton(
                    onPressed: () async{
                      if(nationNumKey.currentState!.validate()){
                        //أولا يتم التحقق من وجود المريض
                        final patient = await dispensary.reference.collection("patients").where("nationNum",isEqualTo: nationNumController.text.trim()).limit(1).get();
                        //في حال لم يكن موجود سيتم إظهار رسالة توضيحية بذلك
                        if(patient.docs.isEmpty){
                          //الرسالة
                          AwesomeDialog(
                              context: context,
                              title : "خطأ",
                              desc: "هذا المريض غير موجود بالمستوصف",
                              dialogType: DialogType.error,
                              titleTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.red,
                              ),
                              descTextStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.redAccent
                              )
                          ).show();
                          //و يتم إفراغ الحقل الخاص بالرقم الوطني
                          setState(() {
                            nationNumController.clear();
                          });
                          return;
                        }
                        //الآن يتم التحقق فيما إذا كان المريض يملك سجل مسبقا
                        final data = patient.docs.first.data();
                        //إذا كان يملك سجل ستظهر رسالة توضيحية
                        if(data.containsKey("سجل ${widget.clinicName}") && data["سجل ${widget.clinicName}"] != null){
                          //الرسالة
                          AwesomeDialog(
                              context: context,
                              title : "خطأ",
                              desc: "هذا المريض يملك سجل",
                              dialogType: DialogType.error,
                              titleTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.red,
                              ),
                              descTextStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.redAccent
                              )
                          ).show();
                          //و يتم إفراغ الحقل الخاص بالرقم الوطني
                          setState(() {
                            nationNumController.clear();
                          });
                          return;
                        }
                        patientNationNum = nationNumController.text.trim();
                        setState(() {
                          isPatientExist = true;
                        });
                      }
                    },
                    label: "التحقق",
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    fontSize: 18,
                    btnColor: Colors.blueAccent
                ),
                SizedBox(height: 20,),
                //في حال كان المريض موجود بعد التحقق ستظهر حقول السجل
                if(isPatientExist) Form(
                  key: recordKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //النص التوضيحي لحقل تاريخ التشخيص
                      Text(
                        "التاريخ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      //حقل التاريخ
                      InputField(
                          hint: "أدخل التاريخ",
                          icon: Icon(Icons.date_range),
                          isObscure: false,
                          controller: dateController,
                          enabled: true,
                          inputType: TextInputType.datetime,
                          validator: (val){
                            if(val == ""){
                              return "لا يمكن ترك الحقل فارغا";
                            }
                            if(val!.contains(new RegExp(r'[a-zA-z]'))){
                              return "إدخال خاطئ";
                            }
                          },
                      ),
                      SizedBox(height: 10,),
                      //النص التوضيحي لحقل الأعراض المرضية
                      Text(
                        "الأعراض المرضية",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      //حقل الأعراض المرضية
                      InputField(
                          hint: "أدخل الأعراض",
                          icon: Icon(Icons.sick),
                          isObscure: false,
                          controller: symptomsController,
                          enabled: true,
                          inputType: TextInputType.text,
                          validator: (val){
                            if(val == ""){
                              return "لا يمكن ترك الحقل فارغا";
                            }
                          },
                      ),
                      SizedBox(height: 10,),
                      //النص التوضيحي لحقل التشخيص
                      Text(
                        "التشخيص المرضي",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      //حقل التشخيص
                      InputField(
                          hint: "أدخل التشخيص المرضي",
                          icon: Icon(Icons.sick),
                          isObscure: false,
                          controller: diagnosisController,
                          enabled: true,
                          inputType: TextInputType.text,
                          validator: (val){
                            if(val == ""){
                              return "لا يمكن ترك الحقل فارغا";
                            }
                          },
                      ),
                      SizedBox(height: 10,),
                      Form(
                        key: medicinesKey,
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //النص التوضيحي لحقل عدد الأدوية
                          Text(
                            "عدد الأدوية",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          //حقل عدد الأدوية
                          InputField(
                              hint: "أدخل عدد الأدوية",
                              icon: Icon(Icons.numbers),
                              isObscure: false,
                              controller: medicinesNumController,
                              enabled: true,
                              inputType: TextInputType.number,
                              validator: (val){
                                if(val == ""){
                                  return "لا يمكن ترك الحقل فارغا";
                                }
                                if(val!.contains(new RegExp(r'[a-zA-z]'))){
                                  return "إدخال خاطئ";
                                }
                              },
                          ),
                          SizedBox(height: 10,),
                          //زر إضافة عدد الأدوية
                          MyButton(
                              onPressed: (){
                                //عند الضغط عليه سيتم تعديل عدد الأدوية لإنشاء حقول لها
                                if(medicinesKey.currentState!.validate()){
                                  medicinesNum = int.parse(medicinesNumController.text.trim());
                                  // حذف الـ controllers القديمة
                                  for (var controller in medicinesControllers) {
                                    controller.dispose();
                                  }
                                  medicinesControllers = [];
                                  if(medicinesNum != 0) {
                                    for (int i = 0; i < medicinesNum; i++) {
                                      medicinesControllers.add(
                                          TextEditingController());
                                    }
                                  }
                                  setState(() {});
                                }
                              },
                              label: "أدخل عدد الأدوية",
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              fontSize: 18,
                              btnColor: Colors.blueAccent
                          )
                        ],
                      ),),
                      SizedBox(height: 10,),
                      if(medicinesNum != 0)
                      //النص التوضيحي لحقول الأدوية
                      Text(
                        "الأدوية",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      //حقول الأدوية
                      if(medicinesNum != 0)
                      for(int i = 0;i<medicinesNum;i++)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //النص التوضحي للحقل
                            Text(
                              "الدواء ${i+1}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            //الحقل
                            InputField(
                                hint: "أدخل اسم الدواء ${i+1}",
                                icon: Icon(Icons.medication_liquid),
                                isObscure: false,
                                controller: medicinesControllers[i],
                                enabled: true,
                                inputType: TextInputType.text,
                                validator: (val){
                                  if(val == ""){
                                    return "لا يمكن ترك الحقل فارغا";
                                  }
                                },
                            ),
                            SizedBox(height: 10,)
                          ],
                        ),
                      SizedBox(height: 10,),
                      //زر إضافة السجل
                      MyButton(
                          onPressed: () async{
                            if(recordKey.currentState!.validate()){
                              //الآن سيتم إضافة السجل
                              final patient =
                              await dispensary.reference.collection("patients")
                                  .where("nationNum",isEqualTo: patientNationNum)
                                  .limit(1).get();
                              List<String> medicines = [];
                              for(int i=0;i<medicinesControllers.length;i++){
                                medicines.add(medicinesControllers[i].text);
                              }
                              await patient.docs.first.reference.set({
                                "سجل ${widget.clinicName}" : {
                                  "clinicName" : widget.clinicName,
                                  "doctorName" : "د.${doctor["firstName"]} ${doctor["lastName"]}",
                                  "visits" : [{
                                    "date" : dateController.text,
                                    "symptoms" : symptomsController.text,
                                    "diagnosis" : diagnosisController.text,
                                    "medicines" : medicines,
                                  }]
                                }
                              },SetOptions(merge: true));
                              //بعدها يتم إظهار رسالة نجاح
                              AwesomeDialog(
                                  context: context,
                                  title : "نجاح",
                                  desc: "تمت إضافة السجل بنجاح",
                                  dialogType: DialogType.success,
                                  titleTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.green,
                                  ),
                                  descTextStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.green
                                  )
                              ).show();
                              //بعدها يتم إفراغ الجقول
                              nationNumController.clear();
                              dateController.clear();
                              symptomsController.clear();
                              diagnosisController.clear();
                              medicinesNumController.clear();
                              for (var controller in medicinesControllers) {
                                controller.clear();
                              }
                            }
                            //بعدها يتم إعادة الصفحة لشكلها البدائي
                            medicinesNum = 0;
                            isPatientExist = false;
                            setState(() {});

                          },
                          label: "إضافة السجل",
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          fontSize: 18,
                          btnColor: Colors.green
                      ),
                    ],
                  ),
                )
              ],
            ),

          )

    );
  }
}

