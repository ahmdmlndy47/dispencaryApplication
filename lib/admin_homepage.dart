import 'package:flutter/material.dart';
class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}
// الصفحة الرئيسية للآدمن
class _AdminHomepageState extends State<AdminHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "المدير",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        actions: [
          ElevatedButton.icon(
              onPressed: (){
                Navigator.of(context).pushNamed("logOrSignPage");
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
        backgroundColor: Colors.blueAccent,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          children: [
            //أزرار إضافة المستخدمين
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //زر إضافة مريض
                Expanded(
                  child: MaterialButton(
                    onPressed:(){},
                    elevation: 7,
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                    color: Colors.blueAccent,
                    splashColor: Colors.blueAccent.shade700,
                    child: Text(
                      "إضافة مريض",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                // زر إضافة طبيب
                Expanded(
                  child: MaterialButton(
                    onPressed:(){},
                    elevation: 7,
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                    color: Colors.blueAccent,
                    splashColor: Colors.blueAccent.shade700,
                    child: Text(
                      "إضافة طبيب",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Text(
              "عيادات المستوصف",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(height: 10,),
            Card(
              elevation: 5,
              shadowColor: Colors.grey,
              child: ListTile(
                title: Text("عيادة الأطفال"),
                subtitle: Text(
                  "د.سمير خضورة",
                  style: TextStyle(color: Colors.grey),),
                trailing: Text(
                  "انقر للتعديل",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                    color: Colors.red
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Card(
              elevation: 5,
              shadowColor: Colors.grey,
              child: ListTile(
                title: Text("العيادة لداخلية"),
                subtitle: Text(
                  "د.سمير خضورة",
                  style: TextStyle(color: Colors.grey),

                ),
                trailing: Text(
                  "انقر للتعديل",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                      color: Colors.red
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Card(
              elevation: 5,
              shadowColor: Colors.grey,
              child: ListTile(
                title: Text("العيادة الصدرية"),
                subtitle: Text(
                  "د.سمير خضورة",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Text(
                  "انقر للتعديل",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                      color: Colors.red
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Card(
              elevation: 5,
              shadowColor: Colors.grey,
              child: ListTile(
                title: Text("العيادة العينية"),
                subtitle: Text(
                  "د.سمير خضورة",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Text(
                  "انقر للتعديل",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                      color: Colors.red
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Card(
              elevation: 5,
              shadowColor: Colors.grey,
              child: ListTile(
                title: Text("عيادة الأسنان"),
                subtitle: Text(
                  "د.سمير خضورة",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Text(
                  "انقر للتعديل",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                      color: Colors.red
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Card(
              elevation: 5,
              shadowColor: Colors.grey,
              child: ListTile(
                title: Text("العيادة الأذنية"),
                subtitle: Text(
                  "د.سمير خضورة",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Text(
                  "انقر للتعديل",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                      color: Colors.red
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Card(
              elevation: 5,
              shadowColor: Colors.grey,
              child: ListTile(
                title: Text("عيادة الجلدية"),
                subtitle: Text(
                  "د.سمير خضورة",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Text(
                  "انقر للتعديل",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                      color: Colors.red
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
