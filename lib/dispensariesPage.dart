import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispensary/components/card_widget.dart';
import 'package:dispensary/homepage.dart';
import 'package:flutter/material.dart';
//صفحة المستوصفات داخل المحافظة
class DispensariesPage extends StatefulWidget {
  final String countryName;
  final String disId;
  const DispensariesPage({super.key, required this.disId, required this.countryName});

  @override
  State<DispensariesPage> createState() => _DispensariesPageState();
}

class _DispensariesPageState extends State<DispensariesPage> {
  //مصفوفة لتخزين المجافظات المأخوذة من الداتا بيس
  List<QueryDocumentSnapshot> data = [];
  //متغير لتحديد فيما اذا تم جلب البيانات او لا
  bool isLoading = true;
  //تابع جلب البيانات
  getData() async{
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection("countries").doc(widget.disId).collection("dispensaries").get();
    data.addAll(snapshot.docs);
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //عنوان الصفحة
      appBar: AppBar(
        title: Text(
          "مستوصفات ${widget.countryName}"
        ),
      ),
      //جسم الصفحة
      body:
      //في حال لم يتم جلب البيانات ستظهر علامة تدل على التحميل
      isLoading ? Center(child: CircularProgressIndicator(),)
      //في حال تم جلب البيانات سيتم عرض محتوى الصفحة والذي هو المحافظات
      : Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          //الwidget التي ستضم المستوصفات
          child: ListView.builder(
            itemBuilder: (context,index){
              //المستوصف الواحد
              return MyCard(
                  title: data[index]["disName"],
                  subtitle: data[index]["disAddress"],
                  trailing: "انقر للمزيد من التفاصيل",
                  //عند الضغط على المستوصف سيتم نقلنا للصفحة الرئيسية للمستوصف
                  onTap: (){
                    Navigator.of(context).
                    push(MaterialPageRoute(
                        builder: (context) => Homepage(disHomePageId: data[index].id,countryId: widget.disId,)
                    )
                    );
                  },
                  trailingColor: Colors.green
              );
            },
            itemCount: data.length,
          ),
        ),
      ),
    );
  }
}
