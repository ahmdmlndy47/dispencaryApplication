import 'package:flutter/material.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: hasAppoint ? Center(
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
                Text(
                  "موعدك الحالي",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  "لديك موعد بالعيادة العينية",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 10,),
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
                      Text(
                        "دورك الحالي",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Colors.red
                        ),
                      ),
                      SizedBox(height: 10,),
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
                  mainAxisSize: MainAxisSize.min,
                  textDirection: TextDirection.rtl,
                  children: [
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
                    Expanded(
                      child: TextButton(
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text(
                                      "هل انت متأكد من إلغاء الموعد",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceBetween,
                                    actions: [
                                      TextButton(
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
                                      TextButton(
                                          onPressed: (){
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
