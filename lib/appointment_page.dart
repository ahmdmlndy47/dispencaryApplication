import 'package:flutter/material.dart';
// صفحة الموعد الخاص بالمريض
class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  bool hasAppoint = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //عنوان الصفحة
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          "موعدي",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white
          ),
        ),
      ),
      //جسم الصفحة
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        //إذا كان لديه موعد سنظهر الموعد
        //إذا لم يكن لديه موعد سيظهر نص يوضح أنه ليس لديه موعد
        child: hasAppoint ? Center(
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
                            showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    //نص التأكيد
                                    title: Text(
                                      "هل انت متأكد من إلغاء الموعد",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceBetween,
                                    //أزرار الإلغاء و التأكيد
                                    actions: [
                                      //زر إلغاء لإلغاء الموعد
                                      TextButton(
                                        //عند الضغط عليه سيتم إزالة الأليرت
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "لا",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300
                                            ),
                                          )),
                                      //زر تأكيد الإلغاء
                                      TextButton(
                                          onPressed: (){
                                            //عند الضغط عليه سنجعل المريض لا يملك موعد
                                            //وذلك من أجل عرض الرسالة التوضيحية بأنه لا يملك موعد
                                            Navigator.of(context).pop();
                                            setState(() {
                                              hasAppoint = false;
                                            });
                                          },
                                          child: Text(
                                            "نعم",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300
                                            ),
                                          ))
                                    ],
                                  );
                                });
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
        )
        //الرسالة التوضيحي بأنه لا يملك موعد
            : Center(
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
    );
  }
}
