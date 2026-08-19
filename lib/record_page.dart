import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'components/input_field.dart';
import 'components/main_button.dart';
//صفحة السجل الطبي
class RecordPage extends StatefulWidget {
  final String clinicName;
  final String docId;
  final String patientNationNum;
  const RecordPage({super.key, required this.patientNationNum, required this.docId, required this.clinicName});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  //المفتاح الخاص بحقول الزيارة
  GlobalKey<FormState> visitKey = GlobalKey();
  //المفتاح الخاص بحقول الأدوية
  GlobalKey<FormState> medicinesKey = GlobalKey();
  //متغير يعبر عما إذا تم جلب البيانات
  bool isLoading = true;
  //متغير يعبر عما إذا حدث خطأ أثناء جلب البيانات
  bool error = false;
  //متغير يعبر عما إذا كان الطبيب يريد إضافة زيارة
  bool wantToAdd = false;
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
  //متغير يعبر عن عدد الأدوية
  int medicinesNum = 0;
  //متغير لجلب المستوصف من الداتا بيس
  late QueryDocumentSnapshot dispensary;
  //تابع جلب البيانات
  getData() async{
    final dis =
    await FirebaseFirestore.instance
        .collectionGroup("dispensaries")
        .where("doctors",arrayContains: widget.docId)
        .limit(1).get();
    if(dis.docs.isEmpty){
      setState(() {
        error = true;
      });
      return;
    }
    dispensary = dis.docs.first;
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    super.initState();
    getData();
    medicinesNumController = TextEditingController();
    dateController = TextEditingController();
    symptomsController = TextEditingController();
    diagnosisController = TextEditingController();
  }
  @override
  void dispose() {
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
    return Scaffold(
      //عنوان الصفحة
      appBar: AppBar(
        title: Text("صفحة السجل الطبي"),
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context)=>RecordPage(
                          clinicName: widget.clinicName,
                          docId: widget.docId,
                          patientNationNum: widget.patientNationNum,)));
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
      //في حال الوصول لهنا فتم جلب البيانات بشكل صحيح
          : Padding(
            padding: const EdgeInsets.all(20),
            child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
              children: [
                StreamBuilder(
                    stream: dispensary.reference.collection("patients").where("nationNum",isEqualTo: widget.patientNationNum).limit(1).snapshots(),
                    builder: (context,AsyncSnapshot<QuerySnapshot> patientSnapshot){
                      // ما زالت البيانات قيد التحميل
                      if (patientSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // حدث خطأ أثناء جلب البيانات
                      if (patientSnapshot.hasError) {
                        return Center(
                          child: Text("حدث خطأ أثناء جلب بيانات المريض"),
                        );
                      }

                      // لا يوجد مريض
                      if (!patientSnapshot.hasData ||
                          patientSnapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text("لم يتم العثور على المريض"),
                        );
                      }
                      //عند الوصول لهنا فنحن حصلنا على البيانات دون أخطاء
                      //أولا نخزن السجلات ضمن مصفوفة
                      final List<Map<String, dynamic>> records =
                      patientSnapshot.data!.docs.first["records"] == null
                          ? []
                          : List<Map<String, dynamic>>.from(patientSnapshot.data!.docs.first["records"]);
                      //أولا نخزن index السجل ضمن متغير
                      final recordIndex = records.indexWhere(
                            (r) => r.containsKey("سجل ${widget.clinicName}"),
                      );
                      //إذا كان ال index يساوي -1 هذا يعني لا يوجد سجل يتم إظهار رسالة توضيحية
                      if (recordIndex == -1) {
                        return Center(
                          child: Text(
                            "لا يوجد سجل لهذه العيادة",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        );
                      }
                      //الآن يتم تخزين السجل
                      final record = records[recordIndex];

                      final recordData = Map<String, dynamic>.from(
                        record["سجل ${widget.clinicName}"],
                      );
                      //ثم نخزن الزيارات
                      final List<Map<String, dynamic>> visits =
                      recordData["visits"] == null
                          ? []
                          : List<Map<String, dynamic>>.from(recordData["visits"]);
                      //الآن يتم عرض السجل
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(-5, 5),
                                      blurRadius: 5
                                  ),
                                ],
                                color: Colors.white
                            ),
                            padding: EdgeInsets.all(20),
                            //محتوى السجل
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //عنوان السجل والذي هو عيادة السجل
                                Center(
                                  child: Text(
                                    "سجل ${widget.clinicName}",
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                SizedBox(height: 20,),
                                //اسم المريض والعيادة
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    //اسم المريض
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "${patientSnapshot.data!.docs.first["firstName"]} ${patientSnapshot.data!.docs.first["lastName"]}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                    //العيادة
                                    Expanded(
                                      child: Text(
                                        widget.clinicName,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                //container لإضافة خط بين اسم السجل والزيارات
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(width: 1,color: Colors.black)
                                      )
                                  ),
                                ),
                                SizedBox(height: 10,),
                                //قائمة الزيارات
                                for(int i=0;i<visits.length;i++)
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    //محتويات كل زيارة
                                    children: [
                                      Center(
                                        child: Text(
                                          "الزيارة ${i+1}",
                                          style: Theme.of(context).textTheme.titleMedium,),
                                      ),
                                      SizedBox(height:10),
                                      //تاريخ الزيارة
                                      Text(
                                        "تاريخ الزيارة : ${visits[i]["date"]}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      //الأعراض
                                      Text(
                                        "الأعراض : ${visits[i]["symptoms"]}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      //التشخيص المرضي
                                      Text(
                                        "التشخيص : ${visits[i]["diagnosis"]}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      //الأدوية المعطاة
                                      Text(
                                        "الأدوية : ${visits[i]["medicines"]}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      //container لإضافة خط بين الزيارات
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(width: 1,color: Colors.black)
                                            )
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                    ],
                                  ),

                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          MyButton(
                            //عند الضغط على الزر يتم فتح الحقول للإضافة
                              onPressed: (){
                                if(wantToAdd == false){
                                  setState(() {
                                    wantToAdd = true;
                                  });
                                }
                              },
                              label: "إضافة زيارة جديدة",
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              fontSize: 18,
                              btnColor: Colors.blueAccent
                          ),
                          SizedBox(height: 10,),
                          //في حال كان الطبيب يريد الإضافة و السجل موجود سيتم إظهار الحقول
                          if(wantToAdd && recordData["visits"] != null) Form(
                            key: visitKey,
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
                                //زر إضافة الزيارة
                                MyButton(
                                    onPressed: () async{
                                      if(visitKey.currentState!.validate()){
                                        //الآن سيتم إضافة الزيارة
                                        final patient = patientSnapshot.data!.docs.first;
                                        //أولا تخزين السجلات
                                        final List<Map<String, dynamic>> records =
                                        patient["records"] == null
                                            ? []
                                            : List<Map<String, dynamic>>.from(patient["records"]);
                                        //ثانيا جلب سجل العيادة و تخزينها
                                        final recordIndex = records.indexWhere(
                                              (r) => r.containsKey("سجل ${widget.clinicName}"),
                                        );

                                        if (recordIndex == -1) {
                                          return;
                                        }
                                        //جلب معلومات السجل وتخزينها
                                        final recordData = Map<String, dynamic>.from(
                                          records[recordIndex]["سجل ${widget.clinicName}"],
                                        );
                                        //تخزين مصفوفة الزيارات
                                        final List<Map<String, dynamic>> visits =
                                        recordData["visits"] == null
                                            ? []
                                            : List<Map<String, dynamic>>.from(recordData["visits"]);
                                        //إنشاء مصفوفة الأدوية المدخلة
                                        List<String> medicines = [];
                                        for(int i=0;i<medicinesControllers.length;i++){
                                          medicines.add(medicinesControllers[i].text);
                                        }
                                        //إضافة الزيارة لمصفوفة الزيارات المحلية
                                        visits.add({
                                          "date": dateController.text.trim(),
                                          "symptoms": symptomsController.text.trim(),
                                          "diagnosis": diagnosisController.text.trim(),
                                          "medicines": medicines,
                                        });
                                        //التعديل على مصفوفة الزيارات الموجودة ضمن بيانات السجل المخزن
                                        recordData["visits"] = visits;

                                        records[recordIndex] = {
                                          "سجل ${widget.clinicName}": recordData,
                                        };
                                        //إضافة التعديل في قاعدة البيانات
                                        await patient.reference.update({
                                          "records": records,
                                        });
                                        if (!mounted) return;
                                        //بعدها يتم إظهار رسالة نجاح
                                        AwesomeDialog(
                                            context: context,
                                            title : "نجاح",
                                            desc: "تمت إضافة الزيارة بنجاح",
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
                                        dateController.clear();
                                        symptomsController.clear();
                                        diagnosisController.clear();
                                        medicinesNumController.clear();
                                        for (var controller in medicinesControllers) {
                                          controller.clear();
                                        }
                                        //بعدها يتم إعادة الصفحة لشكلها البدائي
                                        medicinesNum = 0;
                                        wantToAdd = false;
                                        setState(() {});
                                      }


                                    },
                                    label: "إضافة الزيارة",
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
                      );
                    }
                )
              ],
            )
                  ),
          ),
    );
  }
}
