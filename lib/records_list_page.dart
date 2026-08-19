import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispensary/components/card_widget.dart';
import 'package:dispensary/record_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/input_field.dart';
import 'components/main_button.dart';
//صفحة البحث عن  سجل
class RecordsListPage extends StatefulWidget {
  final String clinicName;
  const RecordsListPage({super.key, required this.clinicName});

  @override
  State<RecordsListPage> createState() => _RecordsListPageState();
}

class _RecordsListPageState extends State<RecordsListPage> {
  //متغير لحفظ الرقم الوطني للمريض
  late String patientNationNum;
  //المفتاح الخاص بحقل الرقم الوطني
  GlobalKey<FormState> nationNumKey = GlobalKey();
  //الcontroller الخاص بحقل الرقم الوطني
  late TextEditingController nationNumController;
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
    nationNumController = TextEditingController();
    getData();
  }
  @override
  void dispose() {
    nationNumController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //عنوان الصفحة
      appBar: AppBar(
        title: Text("صفحة السجلات الطبية"),
        centerTitle: true,
      ),
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RecordsListPage(clinicName: widget.clinicName)));
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
          "يجب أولا إدخال الرقم الوطني للتأكد أن المريض مسجل و لديه سجل بهذه العيادة",
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
                // جلب بيانات المريض
                final data = patient.docs.first.data();

                // جلب السجلات الموجودة عند المريض
                final List<Map<String, dynamic>> records =
                data["records"] == null
                    ? []
                    : List<Map<String, dynamic>>.from(data["records"]);

                // التحقق من وجود سجل لهذه العيادة
                final hasRecord = records.any(
                      (record) => record.containsKey("سجل ${widget.clinicName}"),
                );

                // إذا لم يكن لديه سجل بهذه العيادة
                if (!hasRecord) {
                  AwesomeDialog(
                    context: context,
                    title: "خطأ",
                    desc: "هذا المريض لا يملك سجل بهذه العيادة",
                    dialogType: DialogType.error,
                    titleTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.red,
                    ),
                    descTextStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.redAccent,
                    ),
                  ).show();

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
              //في حال كان المريض موجود وله سجل سيتم عرضه
              if (isPatientExist)
                StreamBuilder<QuerySnapshot>(
                  stream: dispensary.reference
                      .collection("patients")
                      .where(
                    "nationNum",
                    isEqualTo: patientNationNum,
                  )
                      .limit(1)
                      .snapshots(),

                  builder: (context, patientSnapshot) {

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

                    // الآن أصبح من الآمن الوصول إلى المريض
                    final patient = patientSnapshot.data!.docs.first;

                    return MyCard(
                      title: "${patient["firstName"]} ${patient["lastName"]}",
                      subtitle: "سجل ${widget.clinicName}",
                      trailing: "انقر للمزيد من التفاصيل",
                      //عند الضغط على السجل سيتم الانتقال لصفحة السجل
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecordPage(clinicName: widget.clinicName,patientNationNum: patientNationNum,docId: doctor["nationNum"],)));
                      },
                      trailingColor: Colors.green,
                    );
                  },
                ),
                ]
                )

                )
                );
              }
            }
