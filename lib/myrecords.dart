import 'package:dispensary/components/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

List records = [
  {
    "clinicName" : "العيادة العينية",
    "recordDate" : DateTime(2024,6,12),
    "docName" : "د.مي شهاب"
  },
  {
    "clinicName" : "العيادة الصدرية",
    "recordDate" : DateTime(2024,7,3),
    "docName" : "د.فداء علواني"
  },
  {
    "clinicName" : "العيادة الجلدية",
    "recordDate" : DateTime(2024,3,22),
    "docName" : "د.عادل اسماعيل"
  },
  {
    "clinicName" : "عيادة الأسنان",
    "recordDate" : DateTime(2024,9,29),
    "docName" : "د.إيفا حنينو"
  },
  {
    "clinicName" : "العيادة العينية",
    "recordDate" : DateTime(2024,1,7),
    "docName" : "د.مي شهاب"
  },
  {
    "clinicName" : "عيادة الأسنان",
    "recordDate" : DateTime(2025,1,10),
    "docName" : "د.إيفا حنينو"
  },
  {
    "clinicName" : "العيادة الجلدية",
    "recordDate" : DateTime(2025,2,4),
    "docName" : "د.عادل اسماعيل"
  },
  {
    "clinicName" : "العيادة الصدرية",
    "recordDate" : DateTime(2025,2,23),
    "docName" : "د.فداء علواني"
  },
  {
    "clinicName" : "العيادة الأسنان",
    "recordDate" : DateTime(2025,3,8),
    "docName" : "د.إيفا حنينو"
  },
  {
    "clinicName" : "العيادة العينية",
    "recordDate" : DateTime(2025,3,11),
    "docName" : "د.مي شهاب"
  },
  {
    "clinicName" : "العيادة الأذنية",
    "recordDate" : DateTime(2025,3,30),
    "docName" : "د.بسام شحادة"
  },
  {
    "clinicName" : "العيادة العينية",
    "recordDate" : DateTime(2025,4,20),
    "docName" : "د.مي شهاب"
  },
  {
    "clinicName" : "عيادة الأسنان",
    "recordDate" : DateTime(2025,5,13),
    "docName" : "د.إيفا حنينو"
  },
  {
    "clinicName" : "العيادة الجلدية",
    "recordDate" : DateTime(2025,6,22),
    "docName" : "د.عادل اسماعيل"
  },
  {
    "clinicName" : "عيادة الأطفال",
    "recordDate" : DateTime(2026,6,20),
    "docName" : "د.سمير خضورة"
  },

];
//صفحة السجلات الطبية للمريض
class MyRecords extends StatefulWidget {
  const MyRecords({super.key});

  @override
  State<MyRecords> createState() => _MyRecordsState();
}

class _MyRecordsState extends State<MyRecords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       //عنوان الصفحة
      appBar: AppBar(
        title: Text("سجلاتي الطبية"),
        centerTitle: true,
      ),
      //محتوى الصفحة
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              //زر البحث للبحث عن سجل بواسطة التاريخ
              // ElevatedButton.icon(
              //   onPressed: (){
              //     showSearch(context: context, delegate: MySearch());
              //   },
              //   label: Text(
              //     "أدخل تاريخ السجل",
              //     style: TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.w500,
              //       color: Colors.white
              //     ),
              //   ),
              //   icon: Icon(Icons.search),
              //   style: ButtonStyle(
              //     shadowColor: WidgetStatePropertyAll(Colors.grey),
              //     elevation: WidgetStatePropertyAll(5),
              //     padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 15,horizontal: 30)),
              //     backgroundColor: WidgetStatePropertyAll(Colors.blue.shade600),
              //     iconColor: WidgetStatePropertyAll(Colors.white),
              //     iconSize: WidgetStatePropertyAll(26),
              //     iconAlignment: IconAlignment.end
              //   ),
              // ),
              InkWell(
                onTap: (){
                  showSearch(context: context, delegate: MySearch());
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.grey,offset: Offset(-5, 5),blurRadius: 5)
                    ],
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(40)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.search,color: Colors.blueAccent,),
                      Text(
                        "ابحث عن سجلك باستخدام التاريخ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              //نص توضيحي
              Text(
                "أدخل تاريخ الزيارة الخاصة بسجلك بالشكل التالي 13-4-2020",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey
                ),
              ),
              SizedBox(height: 10,),
              //جميع السجلات الطبية الخاصة بالمريض
              ...List.generate(records.length, (index){
                return MyCard(
                    title: "تقرير ${records[index]["clinicName"]}",
                    subtitle: "${intl.DateFormat("yyyy-MM-dd").format(records[index]["recordDate"])}",
                    trailing: "انقر للمزيد من التفاصيل",
                    //عند الضغط على أي سجل سيظهر اليرت يحتوي على السجل الطبي كاملا
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (context){
                            //الاليرت
                            return Dialog(
                              insetPadding: EdgeInsets.symmetric(horizontal: 20),
                                child: SingleChildScrollView(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: BoxBorder.all(
                                        width: 1,
                                        color: Colors.black
                                      ),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                        bottom: Radius.circular(10)
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black54,
                                          offset: Offset(-5, 5),
                                          blurRadius: 5
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        //زر لإغلاق الاليرت والخروج من السجل الطبي
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                              icon: Icon(Icons.close,size: 20,color: Colors.black,)),
                                        ),
                                        //اسم العيادة الخاصة بالسجل
                                        Center(
                                          child: Text(
                                            records[index]["clinicName"],
                                            style: Theme.of(context).textTheme.titleMedium,
                                          ),
                                        ),
                                        SizedBox(height: 15,),
                                        //معلومات عن العيادة وهي اسم الطبيب وتاريخ صدور السجل من العيادة
                                        Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1,
                                                color: Colors.black
                                              )
                                            )
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              //تاريخ السجل
                                              Expanded(
                                                child: Text(
                                                  "${intl.DateFormat("yyyy-MM-dd").format(records[index]["recordDate"])}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                  
                                              ),
                                              //اسم الطبيب الذي أصدر السجل
                                              Expanded(
                                                child: Text(
                                                  "${records[index]["docName"]}",
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                  
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                         //عنوان قسم التشخيص في السجل
                                        Center(
                                          child: Text(
                                            "تشحيص الحالة المرضية",
                                            style: Theme.of(context).textTheme.titleMedium,
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        //التشخيص المرضي
                                        Text(
                                          "تم تشخيص المريض على أنه يعاني من مرض ال_____ وذلك تبعا للأعراض_______",
                                          textAlign: TextAlign.right,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.green
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(width: 1,color: Colors.black)
                                            )
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        //عنوان قسم الوصفة الطبية بالسجل
                                        Center(
                                          child: Text(
                                            "الوصفة الطبية",
                                            style: Theme.of(context).textTheme.titleMedium,
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        //الوصفة الطبية والتي هي عبارة عن مجموعة أدوية
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            //الدواء الأول
                                            Text(
                                              "1-panadol حبة مساءاً وحبة صباحاً",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: Colors.green
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            //الدواء الثاني
                                            Text(
                                              "2-panadol حبة مساءاً وحبة صباحاً",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: Colors.green
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            //الدواء الثالث
                                            Text(
                                              "3-panadol حبة مساءاً وحبة صباحاً",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: Colors.green
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            );
                          });
                    },
                    trailingColor: Colors.green
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

class MySearch extends SearchDelegate{
  @override
  String get searchFieldLabel => "أدخل تاريخ مثل 13-4-2020";
  @override
  TextStyle? get searchFieldStyle => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.grey
  );
  @override
  TextInputType? get keyboardType => TextInputType.datetime;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
    IconButton(
        onPressed: (){
          close(context, null);
        },
        icon: Icon(Icons.arrow_back,color: Colors.black,)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    if(query.isNotEmpty) {
      return IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close, color: Colors.black,));
    }else {return null;}
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List filteredRec = records.where((rec)=>rec["recordDate"].toString().contains(query)).toList();
    if(query.isEmpty){
      return ListView.builder(
        itemCount: records.length,
        itemBuilder: (context,index){
          return Directionality(
            textDirection: TextDirection.rtl,
            child: MyCard(
                title: "تقرير ${records[index]["clinicName"]}",
                subtitle: "${intl.DateFormat("yyyy-MM-dd").format(records[index]["recordDate"])}",
                trailing: "انقر للمزيد من التفاصيل",
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (context){
                        return Dialog(
                          insetPadding: EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: BoxBorder.all(
                                    width: 1,
                                    color: Colors.black
                                ),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                    bottom: Radius.circular(10)
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black54,
                                      offset: Offset(-5, 5),
                                      blurRadius: 5
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Icons.close,size: 20,color: Colors.black,)),
                                  ),
                                  Center(
                                    child: Text(
                                      records[index]["clinicName"],
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Colors.black
                                            )
                                        )
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${intl.DateFormat("yyyy-MM-dd").format(records[index]["recordDate"])}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey,
                                            ),
                                          ),

                                        ),
                                        Expanded(
                                          child: Text(
                                            "${records[index]["docName"]}",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey,
                                            ),
                                          ),

                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Center(
                                    child: Text(
                                      "تشحيص الحالة المرضية",
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Text(
                                    "تم تشخيص المريض على أنه يعاني من مرض ال_____ وذلك تبعا للأعراض_______",
                                    textAlign: TextAlign.right,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.green
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width: 1,color: Colors.black)
                                        )
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Center(
                                    child: Text(
                                      "الوصفة الطبية",
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "1-panadol حبة مساءاً وحبة صباحاً",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Colors.green
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "2-panadol حبة مساءاً وحبة صباحاً",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Colors.green
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "3-panadol حبة مساءاً وحبة صباحاً",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Colors.green
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                trailingColor: Colors.green
            ),
          );
        },
      );
    }else{
      return ListView.builder(
        itemCount: filteredRec.length,
        itemBuilder: (context,index){
          return Directionality(
            textDirection: TextDirection.rtl,
            child: MyCard(
                title: "تقرير ${filteredRec[index]["clinicName"]}",
                subtitle: "${intl.DateFormat("yyyy-MM-dd").format(filteredRec[index]["recordDate"])}",
                trailing: "انقر للمزيد من التفاصيل",
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (context){
                        return Dialog(
                          insetPadding: EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: BoxBorder.all(
                                    width: 1,
                                    color: Colors.black
                                ),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                    bottom: Radius.circular(10)
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black54,
                                      offset: Offset(-5, 5),
                                      blurRadius: 5
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Icons.close,size: 20,color: Colors.black,)),
                                  ),
                                  Center(
                                    child: Text(
                                      records[index]["clinicName"],
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Colors.black
                                            )
                                        )
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${intl.DateFormat("yyyy-MM-dd").format(records[index]["recordDate"])}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey,
                                            ),
                                          ),

                                        ),
                                        Expanded(
                                          child: Text(
                                            "${records[index]["docName"]}",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey,
                                            ),
                                          ),

                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Center(
                                    child: Text(
                                      "تشحيص الحالة المرضية",
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Text(
                                    "تم تشخيص المريض على أنه يعاني من مرض ال_____ وذلك تبعا للأعراض_______",
                                    textAlign: TextAlign.right,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.green
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width: 1,color: Colors.black)
                                        )
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Center(
                                    child: Text(
                                      "الوصفة الطبية",
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "1-panadol حبة مساءاً وحبة صباحاً",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Colors.green
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "2-panadol حبة مساءاً وحبة صباحاً",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Colors.green
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "3-panadol حبة مساءاً وحبة صباحاً",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Colors.green
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                trailingColor: Colors.green
            ),
          );
        },
      );
    }
  }
}
