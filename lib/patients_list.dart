import 'package:dispensary/components/card_widget.dart';
import 'package:dispensary/components/main_button.dart';
import 'package:flutter/material.dart';
List patients = [
  {
    "patientName" : "أحمد ملندي",
    "patientAge" : 22,
    "availablity" : true,
    "nationNum" : 6060456456345,
    "phoneNum" : 0940456748,
  },
  {
    "patientName" : "حسن باكير",
    "patientAge" : 22,
    "availablity" : false,
    "nationNum" : 6060456456345,
    "phoneNum" : 0940456748,
  },
  {
    "patientName" : "حمزة فاروسي",
    "patientAge" : 22,
    "availablity" : true,
    "nationNum" : 6060456456345,
    "phoneNum" : 0940456748,
  },
  {
    "patientName" : "علي حاج محمود",
    "patientAge" : 22,
    "availablity" : true,
    "nationNum" : 6060456456345,
    "phoneNum" : 0940456748,
  },
  {
    "patientName" : "عمر فاروسي",
    "patientAge" : 22,
    "availablity" : true,
    "nationNum" : 6060456456345,
    "phoneNum" : 0940456748,
  },
  {
    "patientName" : "محمود ناجي",
    "patientAge" : 22,
    "availablity" : true,
    "nationNum" : 6060456456345,
    "phoneNum" : 0940456748,
  },
  {
    "patientName" : "ناجي حداد",
    "patientAge" : 22,
    "availablity" : true,
    "nationNum" : 6060456456345,
    "phoneNum" : 0940456748,
  },
  {
    "patientName" : "عروة باكير",
    "patientAge" : 22,
    "availablity" : true,
    "nationNum" : 6060456456345,
    "phoneNum" : 0940456748,
  },
  {
    "patientName" : "أنس عبدالله",
    "patientAge" : 22,
    "availablity" : false,
    "nationNum" : 6060456456345,
    "phoneNum" : 0940456748,
  }
  ,{
    "patientName" : "خالد فاروسي",
    "patientAge" : 22,
    "availablity" : true,
    "nationNum" : 6060456456345,
    "phoneNum" : 0940456748,
  }
  ,{
    "patientName" : "أحمد حمدو",
    "patientAge" : 22,
    "availablity" : false,
    "nationNum" : 6060456456345,
    "phoneNum" : 0940456748,
  },
  {
    "patientName" : "أحمد بريمو",
    "patientAge" : 22,
    "availablity" : true,
    "nationNum" : 6060456456345,
    "phoneNum" : 0940456748,
  },
  {
    "patientName" : "رائد أمين",
    "patientAge" : 22,
    "availablity" : true,
    "nationNum" : 6060456456345,
    "phoneNum" : 0940456748,
  },
  {
    "patientName" : "يامن ملندي",
    "patientAge" : 22,
    "availablity" : false,
    "nationNum" : 6060456456345,
    "phoneNum" : 0940456748,
  },






];
class PatientsList extends StatefulWidget {
  const PatientsList({super.key});

  @override
  State<PatientsList> createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("قائمة المرضى"),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          child: ListView(
            children: [
              MyButton(
                  onPressed: (){
                    showSearch(context: context, delegate: MySearch());
                  },
                  label: "البحث عن مريض",
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  fontSize: 18,
                  btnColor: Colors.blue.shade600
              ),
              SizedBox(height: 20,),
              Text(
                "أدخل اسم المريض المطلوب",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w300
                ),
              ),
              ...List.generate(
                patients.length,(index){
                  return MyCard(
                      title: patients[index]["patientName"],
                      subtitle: "${patients[index]["nationNum"]}",
                      trailing: "انقر لرؤية المزيد",
                      onTap: () {},
                      trailingColor: Colors.green
                  );
              },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MySearch extends SearchDelegate {
  @override
  String get searchFieldLabel => "أدخل اسم المريض";
  @override
  TextStyle? get searchFieldStyle => TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.grey
  );
  @override
  TextInputType? get keyboardType => TextInputType.name;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            close(context, null);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.blueAccent,

          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.close, color: Colors.red,));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty){
      return Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              return MyCard(
                  title: patients[index]["patientName"],
                  subtitle: "${patients[index]["nationNum"]}",
                  trailing: "انقر لرؤية المزيد",
                  onTap: () {},
                  trailingColor: Colors.green
              );
            }


        ),
      );
    }else{
      List filteredPatient = patients.where((pat) => pat["patientName"].contains(query)).toList();
      return Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          itemCount: filteredPatient.length,
          itemBuilder: (context,index){
            return MyCard(
                title: filteredPatient[index]["patientName"],
                subtitle: "${filteredPatient[index]["nationNum"]}",
                trailing: "انقر لرؤية المزيد",
                onTap: () {},
                trailingColor: Colors.green
            );
          },
        ),
      );
    }
  }
}
