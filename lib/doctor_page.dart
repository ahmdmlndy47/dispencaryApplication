import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispensary/components/main_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//صفحة الطبيب الرئيسية
class DoctorPage extends StatefulWidget {
  const DoctorPage({super.key});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  int appsCount = 1;
  bool isLoaded = false;
  //متغير يعبر عما اذا كان يوجد موعد ام لا
  bool noAppoint = false;
  //متغير للتعبير عما اذا كان تم جلب البيانات ام لا
  bool isLoading = true;
  //متغير للتعبير عن رقم الموعد الحالي
  int currentAppNum  = 1;
  //الطبيب المستحدم الحالي للتطبيق
 late QueryDocumentSnapshot doctor;
  //المستوصف الذي يوجد فيه الطبيب
  late QueryDocumentSnapshot dispensary;
 //العيادة التي يوجد فيها الطبيب
  late QueryDocumentSnapshot clinic;
  late QueryDocumentSnapshot currApp;
  //تابع جلب البيانات
  getData() async {
    if (!isLoaded) {
      final doc = await FirebaseFirestore.instance
          .collectionGroup("doctors")
          .where("UID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .limit(1)
          .get();
      final dis = await FirebaseFirestore.instance.collectionGroup(
          "dispensaries").where(
          "doctors", arrayContains: doc.docs.first["nationNum"]).limit(1).get();
      final cl = await dis.docs.first.reference.collection("clinics").where(
          "docName", isEqualTo: "${doc.docs.first["firstName"]} ${doc.docs
          .first["lastName"]}").limit(1).get();
      dispensary = dis.docs.first;
      doctor = doc.docs.first;
      clinic = cl.docs.first;
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      isLoaded = true;
    }
  }
  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //عنوان الصفحة
      appBar: AppBar(
        title: Text(
          "صفحة الطبيب",
        ),
        //زر تسجيل الخروج
        actions: [
          ElevatedButton.icon(
            onPressed: (){
              //عند الضغط عليه سيظهر dialog للتأكيد
              AwesomeDialog(
                  context: context,
                  title: "تسجيل الخروج",
                  desc: "هل أنت متأكد من تسجيل الخروج",
                  dialogType: DialogType.question,
                  showCloseIcon: true,
                  animType: AnimType.rightSlide,
                  btnOkOnPress: (){
                    //عند التأكيد سيتم تسجيل الخروج والانتقال لصفحة التسجيل
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil("logOrSignPage", (route)=>false);
                  },
                  btnCancelOnPress: (){},
                  btnOkText: "نعم",
                  btnCancelText: "لا"
              ).show();
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
      //جسم الصفحة
      body:
          //في حال لم ينتهي جلب البيانات سيتم إظهار دائرة التحميل
      isLoading ? Center(child: CircularProgressIndicator(),)
      //وإلا سيتم عرض بيانات الصفحة
      : StreamBuilder(
          stream: FirebaseFirestore.instance.collectionGroup("appointment")
              .where("disId",isEqualTo: dispensary.id)
              .where("appointClinic",isEqualTo: clinic["clinicName"])
              .snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot> apps){
            //في حال لم يتم تحميل البيانات بعد ستظهر دائرة الloading
           if(apps.connectionState == ConnectionState.waiting){
             return Center(child: CircularProgressIndicator(),);
           }
           //الآن يتم جلب الموعد الحالي وتخزينه
           final currentAppoint = apps.data!.docs.where((app) => app["appointNum"] == currentAppNum).toList();
           //في حال لم يتم إيجاد موعد سيتم تغيير الnoAppoint
           if(currentAppoint.isEmpty){
             noAppoint = true;
           }else{
             //وإلا فهناك موعد يتم تخزينه ضمن متغير
             currApp = currentAppoint.first;
             noAppoint = false;
           }
           //الآن سيتم عرض بيانات الصفحة
            return Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  //في حال لم يكن هناك مواعيد سيتم إظهار رسالة توضيحية وإلا يتم عرض الجزء الخاص بالموعد
                  apps.data!.docs.length == 0 || noAppoint
                      ?
                  //الرسالة التوضيحية
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(-5, 5),
                                blurRadius: 5
                            )
                          ]
                      ),
                      child: Text(
                        "لا يوجد مواعيد حاليا",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white
                        ),
                      ),
                    ),
                  )
                      :
                  //الجزء الخاص بالموعد الحالي وبياناته من الصفحة
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(-5, 5),
                              blurRadius: 5,
                              color: Colors.grey
                          )
                        ]
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //عنوان هذا الجزء
                        Text(
                          "الموعد الحالي",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20,),
                        //رقم الموعد
                        Text(
                          "${appsCount}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 10,),
                        //اسم المريض صاحب الموعد
                        Text(
                          "${currApp["patientName"]}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20,),
                        //أزرار انهاء حالة وأخذ الموعد التالي
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //زر التالي
                            //يتم استخدام هذا الزر في حال أتى المريض لموعده وتم انهاء حالته من قبل الطبيب
                            Expanded(
                                child: MyButton(
                                    onPressed: ()async{
                                      //عند الضغط عليه سيتم حذف الموعد والتعديل على ىيانات المريض
                                      //ليصبح المريض لا يملك اي موعد
                                      final patient = await dispensary.reference.collection("patients").where("nationNum",isEqualTo: currApp["patientId"]).limit(1).get();
                                      if(patient.docs.isEmpty) return;
                                      //الجزء الخاص بالتعديل
                                      await patient.docs.first.reference.update({
                                        "hasAppoint" : false
                                      });
                                      //تعديل دور المرضى الباقيين وانقاصه
                                      for (final app in apps.data!.docs) {
                                        if (app.id != currApp.id &&
                                            app["appointNum"] > currApp["appointNum"]) {
                                          await app.reference.update({
                                            "appointNum": FieldValue.increment(-1),
                                          });
                                        }
                                      }
                                      //الجزء الخاص بالحذف
                                      await currApp.reference.delete();
                                      //وسيتم إنقاص عدد المرضى بالعيادة
                                      await clinic.reference.update({"patientNum" : FieldValue.increment(-1)});


                                    },
                                    label: "التالي",
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    fontSize: 18,
                                    btnColor: Colors.blueAccent
                                )),
                            SizedBox(width: 10,),
                            //زر التخلف عن الموعد
                            //هذا الزر يستخدم لتقديم الدور ولكن في حال تخلف المريض عن الموعد
                            Expanded(
                                child: MyButton(
                                    onPressed: ()async{
                                      //عند الضغط عليه سيتم حذف الموعد والتعديل على ىبيانات المريض
                                      //ليصبح المريض لا يملك اي موعد
                                      final patient = await dispensary.reference.collection("patients").where("nationNum",isEqualTo: currApp["patientId"]).limit(1).get();
                                      //الجزء الخاص بالتعديل
                                      //يتم التعديل لجعل المريض لا يملك موعد
                                      //وثم يتم تعديل بيانات المريض لجعله تخلف عن موعد
                                      if(patient.docs.isEmpty) return;
                                      await patient.docs.first.reference.update({
                                        "hasAppoint" : false,
                                        "missedAnApp" : true
                                      });

                                      //تعديل دور المرضى الباقيين وانقاصه
                                      for (final app in apps.data!.docs) {
                                        if (app.id != currApp.id &&
                                            app["appointNum"] > currApp["appointNum"]) {
                                          await app.reference.update({
                                            "appointNum": FieldValue.increment(-1),
                                          });
                                        }
                                      }
                                      //الجزء الخاص بالحذف
                                      await currApp.reference.delete();
                                      //وسيتم إنقاص عدد المرضى بالعيادة
                                      await clinic.reference.update({"patientNum" : FieldValue.increment(-1)});

                                    },
                                    label: "تخلف عن الموعد",
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    fontSize: 18,
                                    btnColor: Colors.blueAccent
                                )),
                          ],
                        )
                      ],
                    ),
                  )
                ],


              ),
            );
          }
      ),
    );
  }
}
