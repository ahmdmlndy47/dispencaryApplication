import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
// صفحة الموعد الخاص بالمريض
class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  bool hasAppoint = true;
  bool _sendNot = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //عنوان الصفحة
      appBar: AppBar(
        centerTitle: true,
        title: Text("موعدي",),
      ),
      //جسم الصفحة
      body: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            children: [
              //خيار تفعيل إشعار عند اقتراب الدور لخمس أشخاص
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  margin: EdgeInsets.only(top: 20),
                  elevation: 7,
                  child: SwitchListTile(
                    value: _sendNot,
                    onChanged: (val){
                        setState(() {
                          _sendNot = val;
                        });
                      },
                    //عنوان الخيار
                    title: Text(
                      "إرسال إشعار تذكير",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                    ),
                    //توضيح للخيار
                    subtitle: Text(
                      "عند اقتراب الدور لخمس أشخاص أمامك سيتم إرسال إشعار إليك",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey
                      ),
                    ),
                    activeTrackColor: Colors.blueAccent,
                    inactiveTrackColor: Colors.grey,
                    thumbColor: WidgetStatePropertyAll(Colors.white),
                    trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              //إذا كان لديه موعد سنظهر الموعد
              //إذا لم يكن لديه موعد سيظهر نص يوضح أنه ليس لديه موعد
              hasAppoint ? Padding(
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
                        //العيادة التي حجز فيها الموعد
                        Text(
                          "لديك موعد بالعيادة العينية",
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
                                  color: Colors.red,
                                  width: 2
                              ),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black
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
                                    color: Colors.red
                                ),
                              ),
                              SizedBox(height: 10,),
                              //عدد المرضى المتبقيين
                              Text(
                                "21",
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
                                "الوقت المتبقي تقريبا 2ساعة",
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
                                        btnOkOnPress: (){setState(() {
                                          hasAppoint = false;
                                        });}
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
              )
              //الرسالة التوضيحي بأنه لا يملك موعد
                  : Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Center(
                                    child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 50),
                    decoration: BoxDecoration(
                        border: BoxBorder.all(
                            color: Colors.red,
                            width: 2
                        ),
                        color: Colors.black,
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
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                                    ),
                                  ),
                  ),

            ],
          ),
        )
    );
  }
}
