import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/card_widget.dart';
//  الصفحة الرئيسية للمريض الخاصة بمحتوى الصفحة الرئيسية
class HomeContent extends StatefulWidget {
  final String disName;
  final String countryId;
  final String disId;
  const HomeContent({super.key, required this.disId, required this.countryId, required this.disName});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  //مصفوفة لتخزين المجافظات المأخوذة من الداتا بيس
  List<QueryDocumentSnapshot> clinics = [];
  //متغير لتحديد فيما اذا تم جلب البيانات او لا
  bool isLoading = true;
  //تابع جلب البيانات
  getData() async{
    QuerySnapshot snapshot =await FirebaseFirestore.instance.collection("countries")
        .doc(widget.countryId).collection("dispensaries")
        .doc(widget.disId).collection("clinics").get();
    clinics.addAll(snapshot.docs);
    setState(() {
      isLoading = false;
    });
  }
  @override
  initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //عنوان الصفحة
        title: Text(widget.disName,),
      ),
      //جسم الصفحة
      body:
      //في حال لم يتم جلب البيانات ستظهر علامة تدل على التحميل
      isLoading ? Center(child: CircularProgressIndicator(),)
      //في حال تم جلب البيانات سيتم عرض محتوى الصفحة والذي هو المحافظات
      : Container(
        padding: EdgeInsets.symmetric(vertical: 30,horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
            //نص توضيحي للصفحة من اجل المستخدم
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  border: BoxBorder.fromLTRB(
                      bottom: BorderSide(width: 1,color: Colors.grey)
                  )
              ),
              //سيتم وضع النص التوضيحي مع صورة له ضمن سطر واحد
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //النص التوضيحي
                  Expanded(
                    child: Text(
                      "أحجز موعدك و أنت بمكانك و اعرف كم شخص امامك",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  //صورة خاصة بالنص التوضيحي
                  CircleAvatar(
                    backgroundImage: AssetImage("images/book_logo.png"),
                    radius: 20,
                  ),

                ],
              ),
            ),
            SizedBox(height: 20,),
            //نص العيادات
            Text(
              "أختر العيادة التي سوف تزورها",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black
              ),
            ),
            SizedBox(height: 10,),
            //عيادات المستوصف
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListView.builder(
                  itemBuilder: (context,index){
                    //العيادة
                    return MyCard(
                        title: clinics[index]["clinicName"],
                        subtitle: clinics[index]["docName"],
                        trailing: "احجز موعدك",
                        trailingColor: Colors.green,
                        //عند الضغط على العيادة سيظهر اليرت لتأكيد الحجز
                        onTap: (){
                          final parentContext = context;
                          showDialog(
                              context: context,
                              builder: (dialogContext){
                                //اليرت الحجز
                                return Dialog(
                                  elevation: 7,
                                  backgroundColor: Colors.white,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          //عنوان الاليرت
                                          Align(
                                            alignment : Alignment.center,
                                            child: Text(
                                              clinics[index]["clinicName"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20,),
                                          //عدد المرضى الحالي بالعيادة
                                          Text(
                                            "يوجد ${clinics[index]["patientNum"]} مريض أمامك",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.blueAccent
                                            ),
                                          ),
                                          SizedBox(height: 20,),
                                          //أزرار التأكيد والإلغاء
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //زر الإلغاء
                                              Expanded(
                                                child: TextButton(
                                                  //عند الضغط عليه سيتم إزالة الاليرت
                                                    onPressed: (){
                                                      Navigator.of(dialogContext).pop();
                                                    },
                                                    child: Text(
                                                      "إلغاء",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w300,
                                                          color: Colors.red
                                                      ),
                                                    )
                                                ),
                                              ),
                                              //زر التأكيد
                                              Expanded(
                                                child: TextButton(
                                                    onPressed: (){
                                                      final messenger = ScaffoldMessenger.of(parentContext);
                                                      //عند الضغط عليه سيظهر اليرت للتأكيد النهائي
                                                      Navigator.of(dialogContext).pop();
                                                      AwesomeDialog(
                                                        context: parentContext,
                                                        title: "تأكيد الحجز",
                                                        desc: "هل أنت متأكد من حجز الموعد",
                                                        dialogType: DialogType.question,
                                                        showCloseIcon: true,
                                                        animType: AnimType.rightSlide,
                                                        btnOkOnPress: ()async{
                                                          //عند تأكيد الحجز
                                                          //نا يتم طلب الحصول على بيانات المريض
                                                          final patient = await FirebaseFirestore.instance.collection("countries")
                                                              .doc(widget.countryId).collection("dispensaries")
                                                              .doc(widget.disId).collection("patients")
                                                              .where("UID",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                                              .limit(1).get();
                                                          //في حال كان المريض يملك موعد لن يتمكن من حجز موعد آخر وسيتم إظهار رسالة توضيحية
                                                          if(patient.docs.first["hasAppoint"]){
                                                            //الرسالة
                                                            AwesomeDialog(
                                                              context: parentContext,
                                                              title: "لديك موعد حالي لا يمكنك الحجز الآن",
                                                              titleTextStyle: TextStyle(
                                                                fontSize: 22,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.red
                                                              )
                                                            ).show();
                                                          }
                                                          //لن يتمكن المريض أيضا من الحجز في حال تم حظره وسيتم إظهلر رساة توضيحية
                                                          else if(!patient.docs.first["available"]){
                                                            //الرسالة
                                                            AwesomeDialog(
                                                                context: parentContext,
                                                                title: "تم حظرك لا يمكنك الحجز يرجى مراجعة المستوصف",
                                                                titleTextStyle: TextStyle(
                                                                    fontSize: 22,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.red
                                                                )
                                                            ).show();
                                                          }else{
                                                            //عند نجاح الحجز سيتم التعديل على بيانات المريض لجعله يمتلك موعد
                                                            patient.docs.first.reference.update(
                                                                {
                                                                  "hasAppoint" : true
                                                                });
                                                            //عند التأكيد سيتم إضافة الموعد لبيانات المريض
                                                            await patient.docs.first.reference.collection("appointment").add({
                                                              "appointClinic" : clinics[index]["clinicName"],
                                                              "appointDis" : widget.disName,
                                                              "appointNum" : clinics[index]["patientNum"]
                                                            });
                                                            messenger.showSnackBar(
                                                                SnackBar(
                                                                    content: Text("تم الحجز"),
                                                                    duration: Duration(seconds: 1)
                                                                )
                                                            );
                                                          }
                                                        },
                                                        btnCancelOnPress: (){},
                                                        btnOkText: "نعم",
                                                        btnCancelText: "لا"
                                                      ).show();
                                                    },
                                                    child: Text(
                                                      "حجز",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w300,
                                                          color: Colors.green
                                                      ),
                                                    )
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                          );
                        }
                    );
                  },
                  itemCount: clinics.length,
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
