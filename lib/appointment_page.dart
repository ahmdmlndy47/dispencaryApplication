import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// صفحة الموعد الخاص بالمريض
class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  //تابع لحساب الوقت المتبقي تقريبا للموعد
  String calculateRemainingTime(dynamic appointNum) {
    int number = (appointNum as num).toInt();

    int totalMinutes = number * 10;

    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return "متبقي تقريباً $hours ساعة و $minutes دقيقة";
    } else if (hours > 0) {
      return "متبقي تقريباً $hours ساعة";
    } else {
      return "متبقي تقريباً $minutes دقيقة";
    }
  }
  bool _sendNot = false;
  bool _isUpdatingNotification = false;
  // Stream خاص بمستند الموعد
  late Stream<QuerySnapshot> _appointmentsStream;
  // Stream خاص بمستند المريض
  late Stream<QuerySnapshot> _patientStream;
  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Stream للمواعيد
    _appointmentsStream = FirebaseFirestore.instance
        .collectionGroup("appointment")
        .where(
      "UID",
      isEqualTo: uid,
    )
        .snapshots();

    // Stream للمريض
    _patientStream = FirebaseFirestore.instance
        .collectionGroup("patients")
        .where(
      "UID",
      isEqualTo: uid,
    )
        .limit(1)
        .snapshots();
  }
  // ============================================================
  // تغيير حالة الإشعارات
  // ============================================================

  Future<void> changeNotificationSetting(bool value) async {
    if (_isUpdatingNotification) {
      return;
    }

    setState(() {
      _isUpdatingNotification = true;
      _sendNot = value;
    });

    try {
      final patient = await FirebaseFirestore.instance
          .collectionGroup("patients")
          .where(
        "UID",
        isEqualTo: FirebaseAuth.instance.currentUser!.uid,
      )
          .limit(1)
          .get();

      if (patient.docs.isEmpty) {
        if (!mounted) return;

        setState(() {
          _sendNot = !value;
          _isUpdatingNotification = false;
        });

        AwesomeDialog(
          context: context,
          title: "خطأ",
          desc: "لم يتم العثور على بيانات المريض",
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          showCloseIcon: true,
          btnOkText: "حسناً",
          btnOkOnPress: () {},
        ).show();

        return;
      }

      // تحديث sendNot فقط بدون حذف باقي بيانات المريض
      await patient.docs.first.reference.set(
        {
          "sendNot": value,
        },
        SetOptions(
          merge: true,
        ),
      );

      if (!mounted) return;

      setState(() {
        _isUpdatingNotification = false;
      });

      AwesomeDialog(
        context: context,
        title: value
            ? "تم تفعيل الإشعارات"
            : "تم إيقاف الإشعارات",
        desc: value
            ? "سيتم إرسال تذكير عند اقتراب دورك"
            : "لن يتم إرسال إشعارات تذكير",
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        showCloseIcon: true,
        btnOkText: "حسناً",
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _sendNot = !value;
        _isUpdatingNotification = false;
      });

      AwesomeDialog(
        context: context,
        title: "خطأ",
        desc: "حدث خطأ أثناء تعديل إعداد الإشعارات",
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        showCloseIcon: true,
        btnOkText: "حسناً",
        btnOkOnPress: () {},
      ).show();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //عنوان الصفحة
      appBar: AppBar(
        centerTitle: true,
        title: Text("موعدي",),
      ),
      //جسم الصفحة
      body:  ListView(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        children: [
          // ========================================================
          // Stream المريض
          // ========================================================

          StreamBuilder<QuerySnapshot>(
            stream: _patientStream,
            builder: (context, patientSnapshot) {

              if (patientSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (patientSnapshot.hasError) {
                return Center(
                  child: Text(
                    "حدث خطأ: ${patientSnapshot.error}",
                  ),
                );
              }

              if (!patientSnapshot.hasData ||
                  patientSnapshot.data!.docs.isEmpty) {
                return const SizedBox();
              }

              // مستند المريض
              final patient =
                  patientSnapshot.data!.docs.first;

              // قراءة sendNot
              final data =
              patient.data() as Map<String, dynamic>;

              final bool sendNot =
                  data["sendNot"] ?? false;

              // مزامنة قيمة السويتش مع Firestore
              if (!_isUpdatingNotification &&
                  _sendNot != sendNot) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _sendNot = sendNot;
                    });
                  }
                });
              }

              // ==================================================
              // سويتش الإشعارات
              // ==================================================

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  elevation: 7,

                  child: SwitchListTile(
                    value: _sendNot,

                    // منع الضغط أثناء تحديث Firestore
                    onChanged: _isUpdatingNotification
                        ? null
                        : (value) {
                      changeNotificationSetting(
                        value,
                      );
                    },

                    title: const Text(
                      "إرسال إشعار تذكير",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    subtitle: const Text(
                      "عند اقتراب الدور لخمس أشخاص أمامك سيتم إرسال إشعار إليك",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),

                    activeTrackColor:
                    Colors.blueAccent,

                    inactiveTrackColor:
                    Colors.grey,

                    thumbColor:
                    const WidgetStatePropertyAll(
                      Colors.white,
                    ),

                    trackOutlineColor:
                    const WidgetStatePropertyAll(
                      Colors.transparent,
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 30,),
          StreamBuilder(
                  stream: _appointmentsStream,
                  builder: (context,appSnapshot){
                    //في حال لم يتم الوصول لبيانات الموعد بعد ستظهر دائرة الloading
                    if(appSnapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    //في حال حدث خطأ أثناء جلب البيانات يتم إظهار رسالة خطأ
                    if (appSnapshot.hasError) {
                      return Center(
                        child: Text(
                          "حدث خطأ: ${appSnapshot.error}",
                        ),
                      );
                    }
                    //في حال كان للمريض موعد ولم يتم العثور على بيانات له سيتم إظهار رسالة توضيحية
                    if (!appSnapshot.hasData ||
                        appSnapshot.data!.docs.isEmpty){
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 50),
                              decoration: BoxDecoration(
                                  border: BoxBorder.all(
                                      color: Colors.transparent,
                                      width: 2
                                  ),
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(-5, 5),
                                        blurRadius: 5
                                    )
                                  ]
                              ),
                              //النص التوضيحي
                              child: Text(
                                "لا يوجد موعد حالي",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    final appointments = appSnapshot.data!.docs;
                    //قائمة المواعيد
                    return Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: appointments.length,
                          itemBuilder: (context,index){
                            final appointment = appointments[index];
                            return Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Center(
                                //الموعد الذي سيظهر
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color:  Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(-5, 5),
                                            blurRadius: 5
                                        ),

                                      ]
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //عنوان الموعد
                                      Text(
                                        "موعدك الحالي",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      //المستوصف التي حجز فيها الموعد
                                      Text(
                                        "لديك موعد ب${appointment["appointDis"]}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      //العيادة التي حجز فيها الموعد
                                      Text(
                                        "${appointment["appointClinic"]}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      //كونتينر خاص بعدد المرضى المتبقي ليصل المريض لدوره
                                      Container(
                                        decoration: BoxDecoration(
                                            border: BoxBorder.all(
                                                color: Colors.blueGrey,
                                                width: 2
                                            ),
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.blueAccent
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            //نص توضيحي
                                            Text(
                                              "دورك الحالي",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18,
                                                  color: Colors.white
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            //عدد المرضى المتبقيين
                                            Text(
                                              "${appointment["appointNum"]}",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      Row(
                                        //سطر يحتوي على الوقت المتبقي المتوقع وزر لإلغاء الموعد
                                        mainAxisSize: MainAxisSize.min,
                                        textDirection: TextDirection.rtl,
                                        children: [
                                          //الوقت المتبقي
                                          Expanded(
                                            child: Text(
                                              calculateRemainingTime(appointment["appointNum"]),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400
                                              ),
                                            ),
                                          ),
                                          // زر إلغاء الموعد
                                          Expanded(
                                            child: TextButton(
                                                onPressed: (){
                                                  //عند الضغط عليه سيظهر اليرت لتأكيد الإلغاء
                                                  AwesomeDialog(
                                                      context: context,
                                                      title: "تأكيد الإلغاء",
                                                      desc: "هل أنت متأكد من إلغاء الموعد؟",
                                                      showCloseIcon: true,
                                                      dialogType: DialogType.error,
                                                      animType: AnimType.rightSlide,
                                                      btnCancelText: "لا",
                                                      btnOkText: "نعم",
                                                      btnCancelOnPress: (){},
                                                      btnOkOnPress: ()async{
                                                        //في حال كان رقم الموعد أقل من أو يساوي خمسة لا يمكن إلغاء الموعد
                                                        //ويتم إظهار رسالة
                                                        if(appointment["appointNum"] < 6){
                                                          AwesomeDialog(
                                                            context: context,
                                                            dialogType: DialogType.error,
                                                            title: "خطأ",
                                                            desc: "لا يمكن إلغاء الحجز بعد الآن",
                                                            titleTextStyle: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18
                                                            ),
                                                            descTextStyle: TextStyle(
                                                                color: Colors.redAccent,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 16
                                                            )
                                                          ).show();
                                                          return;
                                                        }
                                                        //عند إلغاء الموعد سيتم التعديل على بيانات المريض
                                                        //يتم جعل المريض لا يمتلك موعد
                                                        final patient = await FirebaseFirestore.instance.collection("countries")
                                                            .doc(appointment["countryId"])
                                                            .collection("dispensaries")
                                                            .doc(appointment["disId"]).collection("patients")
                                                            .where("UID",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                                            .limit(1).get();
                                                        if(patient.docs.isNotEmpty){
                                                          await patient.docs.first.reference.update(
                                                              {
                                                                "hasAppoint" : false
                                                              });
                                                        }
                                                        //ثم يتم انقاص عدد المرضى بالعيادة
                                                        final clinic =
                                                        await FirebaseFirestore.instance.collection("countries")
                                                            .doc(appointment["countryId"])
                                                            .collection("dispensaries")
                                                            .doc(appointment["disId"])
                                                            .collection("clinics")
                                                            .where("clinicName",isEqualTo: appointment["appointClinic"])
                                                            .limit(1).get();
                                                        if(clinic.docs.isNotEmpty){
                                                          await clinic.docs.first.reference.update(
                                                              {
                                                                "patientNum" : FieldValue.increment(-1)
                                                              });
                                                        }
                                                        //ويتم إنقاص الدور بالمواعيد التي بعده
                                                        final appoints =
                                                        await FirebaseFirestore.instance
                                                            .collectionGroup("appointment")
                                                            .where("disId",isEqualTo: appointment["disId"])
                                                            .where("appointClinic",isEqualTo: appointment["appointClinic"])
                                                            .where("appointNum",isGreaterThan: appointment["appointNum"]).get();
                                                        if(appoints.docs.isNotEmpty)
                                                        for(int i=0;i<appoints.docs.length;i++){
                                                         await appoints.docs[i].reference.update({"appointNum" : FieldValue.increment(-1)});
                                                        }

                                                        //يتم حذف الموعد
                                                        await appointment.reference.delete();

                                                      }
                                                  ).show();
                                                },
                                                child: Text(
                                                  "إلغاء الموعد",
                                                  style:TextStyle(
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 12
                                                  ),
                                                )),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                    );
                  }
              )
        ],
      ),
              );
            }
            }





