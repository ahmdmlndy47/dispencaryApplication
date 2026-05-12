import 'package:dispensary/components/card_widget.dart';
import 'package:dispensary/components/specializations.dart';
import 'package:flutter/material.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}
// الصفحة الرئيسية للمريض
class _HomepageState extends State<Homepage> {
  int _current = 0;
 List clinics = [
   {
     "clinicName" : "عيادة الأطفال",
     "docName" : "د.سمير خضورة",
   },
   {
     "clinicName" : "العيادة الداخلية",
     "docName" : "د.عائد عيدالله",
   },
   {
     "clinicName" : "العيادة الصدرية",
     "docName" : "د.فداء علواني",
   },
   {
     "clinicName" : "العيادة العينية",
     "docName" : "د.مي شهاب",
   },
   {
     "clinicName" : "عيادة الأسنان",
     "docName" : "د.إيفا حنينو",
   },
   {
     "clinicName" : "عيادة الأذنية",
     "docName" : "د.بسام شحادة",
   },
   {
     "clinicName" : "العيادة الجلدية",
     "docName" : "د.عادل اسماعيل",
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
          "مستوصف الخير",
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
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  CircleAvatar(
                      backgroundImage: AssetImage("images/book_logo.png"),
                      radius: 20,
                  ),

                ],
              ),
            ),
            SizedBox(height: 20,),
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
                        onTap: (){}
                    );
                  },
                  itemCount: clinics.length,
                ),
              ),
            ),
          ],
        ),
      ),
      //تبويبات الصفحة والشريط السفلي
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _current,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.blueAccent,
        onTap: (val){
          setState(() {
            _current = val;
          });
        },
        items: [
          //بويبة الصفحة الرئيسية
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "الصفحة الرئيسية",

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "الصفحة الرئيسية",

          )
        ],
      ),
    );
  }
}
