import 'package:dispensary/components/card_widget.dart';
import 'package:flutter/material.dart';
class DoctorsList extends StatefulWidget {
  const DoctorsList({super.key});

  @override
  State<DoctorsList> createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList> {
  List doctors = [
    {
      "docName" : "د.سمير خضورة",
      "nationNum" : 060601045645234,
      "phoneNum" : 0992267248,
      "specialization" : "أطفال",
    },
    {
      "docName" : "د.عائد عبدالله",
      "nationNum" : 060601045645234,
      "phoneNum" : 0992267248,
      "specialization" : "داخلية",
    },
    {
      "docName" : "د.فداء علواني",
      "nationNum" : 060601045645234,
      "phoneNum" : 0992267248,
      "specialization" : "صدرية",
    },
    {
      "docName" : "د.مي شهاب",
      "nationNum" : 060601045645234,
      "phoneNum" : 0992267248,
      "specialization" : "عينية",
    },
    {
      "docName" : "د.إيفا حنينو",
      "nationNum" : 060601045645234,
      "phoneNum" : 0992267248,
      "specialization" : "أسنان",
    },
    {
      "docName" : "د.بسام شحادة",
      "nationNum" : 060601045645234,
      "phoneNum" : 0992267248,
      "specialization" : "أذنية",
    },
    {
      "docName" : "د.عادل اسماعيل",
      "nationNum" : 060601045645234,
      "phoneNum" : 0992267248,
      "specialization" : "جلدية",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("قائمة الأطباء"),
        centerTitle: true,
      ),
      body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            child: ListView(
              children: [
                Text(
                  "قائمة أطباء المركز",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ...List.generate(doctors.length, (index){
                  return MyCard(
                      title: doctors[index]["docName"],
                      subtitle: doctors[index]["specialization"],
                      trailing: "انقر لرؤية المزيد",
                      onTap: (){},
                      trailingColor: Colors.green
                  );
                }
                )
              ],
            ),
          )
      ),
    );
  }
}
