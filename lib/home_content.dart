import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'components/card_widget.dart';
//  الصفحة الرئيسية للمريض الخاصة بمحتوى الصفحة الرئيسية
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List clinics = [
    {
      "clinicName" : "عيادة الأطفال",
      "docName" : "د.سمير خضورة",
      "patientNum" : 23
    },
    {
      "clinicName" : "العيادة الداخلية",
      "docName" : "د.عائد عيدالله",
      "patientNum" : 5
    },
    {
      "clinicName" : "العيادة الصدرية",
      "docName" : "د.فداء علواني",
      "patientNum" : 21
    },
    {
      "clinicName" : "العيادة العينية",
      "docName" : "د.مي شهاب",
      "patientNum" : 18
    },
    {
      "clinicName" : "عيادة الأسنان",
      "docName" : "د.إيفا حنينو",
      "patientNum" : 11
    },
    {
      "clinicName" : "عيادة الأذنية",
      "docName" : "د.بسام شحادة",
      "patientNum" : 9
    },
    {
      "clinicName" : "العيادة الجلدية",
      "docName" : "د.عادل اسماعيل",
      "patientNum" : 30
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        //عنوان الصفحة
        title: Text(
          "الصفحة الرئيسية",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26,
              color: Colors.white
          ),),
      ),
      //جسم الصفحة
      body: Container(
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
                                  backgroundColor: Colors.black,
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
                                                  color: Colors.white,
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
                                                      Navigator.of(context).pop();
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
                                                        btnOkOnPress: (){
                                                          messenger.showSnackBar(
                                                              SnackBar(
                                                                  content: Text("تم الحجز"),
                                                                  duration: Duration(seconds: 1)
                                                              )
                                                          );
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
