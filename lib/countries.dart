import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispensary/dispensariesPage.dart';
import 'package:flutter/material.dart';
// صفحة المحافظات
class Countries extends StatefulWidget {
  const Countries({super.key});

  @override
  State<Countries> createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {
  //مصفوفة لتخزين المجافظات المأخوذة من الداتا بيس
  List<QueryDocumentSnapshot> data = [];
  //متغير لتحديد فيما اذا تم جلب البيانات او لا
  bool isLoading = true;
  //تابع جلب البيانات
  getData() async{
    QuerySnapshot snapshot =await FirebaseFirestore.instance.collection("countries").get();
    data.addAll(snapshot.docs);
    setState(() {
      isLoading = false;
    });
  }
  @override
  initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //عنوان الصفحة وهو عبارة عن نص توضيحي
      appBar: AppBar(
        title: Text(
          "اختر المحافظة التي تريد ان تزور مستوصف فيها",
          style: TextStyle(
            fontSize: 16
          ),
        ),
      ),
      //جسم الصفحة
      body:
          //في حال لم يتم جلب البيانات ستظهر علامة تدل على التحميل
      isLoading ? Center(child: CircularProgressIndicator())
      //في حال تم جلب البيانات سيتم عرض محتوى الصفحة والذي هو المحافظات
          : Directionality(
            textDirection: TextDirection.rtl,
            //الwidget التي ستضم المحافظات
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              itemCount: data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10
              ),
              itemBuilder: (context,index){
                //المحافظة الواحدة
                  return InkWell(
                    //عند الضغط على المحافظة سيتم عرض صفحة المستوصفات
                    onTap: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                          builder: (context)=> DispensariesPage(
                            disId: data[index].id,
                            countryName : data[index]["countryName"]
                          )
                      )
                      );
                    },
                    //كل عنصر من المحافظات يحتوي على اسم المحافظة وصورة معبرة عنها
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black,offset: Offset(-5, 5),blurRadius: 5)
                        ],
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //اسم المحافظة
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              color: Colors.blueAccent,
                            ),
                            child: Text(
                              data[index]["countryName"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                          ),
                          //الصورة المعبرة عن المحافظة
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                                image: DecorationImage(
                                  image: NetworkImage(data[index]["imagePath"]),
                                  fit: BoxFit.cover
                                )
                              ),
                              ),
                          ),
                        ],
                      ),
                    ),
                  );
                },


                  ),
          ),
    );
  }
}
