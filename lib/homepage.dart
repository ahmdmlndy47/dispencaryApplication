import 'package:dispensary/components/specializations.dart';
import 'package:flutter/material.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
 final List<String> _specializations = [
    "الأطفال",
    "الداخلية",
    "الصدرية",
    "العينية",
    "الأسنان",
    "الأذنية",
    "الجلدية",
  ];
 final List<String> _doctors = [
    "سمير خضورة",
    "سمير خضورة",
    "سمير خضورة",
    "سمير خضورة",
    "سمير خضورة",
    "سمير خضورة",
    "سمير خضورة",
  ];
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
        centerTitle: false,
        title: Text(
          "مستوصف الخير",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white
          ),),
        actions: [
          ElevatedButton.icon(
              onPressed: (){
                Navigator.of(context).pushNamed("logOrSignPage");
              },
              iconAlignment: IconAlignment.end,
              style: ButtonStyle(
                shadowColor: WidgetStatePropertyAll(Colors.grey),
                elevation: WidgetStatePropertyAll(5),
                backgroundColor: WidgetStatePropertyAll(Colors.blueAccent.shade700)
              ),
              label: Text(
                "التسجيل في التطبيق",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.white
                ),
              ),
            icon: Icon(Icons.login,color: Colors.white,),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30,horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
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
                  Text(
                    "أحجز موعدك و أنت بمكانك و اعرف كم شخص امامك",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage("images/book_logo.png"),
                    radius: 20,
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            Text(
              "أختر العيادة يلي رح تزورها",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black
              ),
            ),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: GridView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 20,
                        childAspectRatio: 1.9
                      ),
                      itemCount: 7,

                      itemBuilder: (BuildContext context, index){
                        return Speciality(specialityName: _specializations[index],doctorName: _doctors[index],);
                      }),
              ),
            ),
          ],
        ),
      ),
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
