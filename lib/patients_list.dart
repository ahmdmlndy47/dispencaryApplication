import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dispensary/components/card_widget.dart';
import 'package:dispensary/components/input_field.dart';
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
List controllers = [];
//صفحة قائمة مرضى المركز
class PatientsList extends StatefulWidget {
  const PatientsList({super.key});

  @override
  State<PatientsList> createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  @override
  void initState() {
    for(int i=0;i<patients.length;i++){
      controllers.add({
        "name" : patients[i]["patientName"],
        "ageController" : TextEditingController(),
        "nationNumController" : TextEditingController(),
        "phoneController" : TextEditingController(),
        "ageEnabled" : false,
        "phoneNumEnabled" : false,
        "nationNumEnabled" : false,
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //عنوان الصفحة
      appBar: AppBar(
        title: Text("قائمة المرضى"),
        centerTitle: true,
      ),
      //عناصر الصفحة
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          child: ListView(
            children: [
              //زر البحث الذي سيظهر حقل البحث
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
              //نص توضيحي لعملية البحث
              Text(
                "أدخل اسم المريض المطلوب",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w300
                ),
              ),
              //ائمة المرضى بحيث كل مريض يتم وضعه ضمن MyCard
              ...List.generate(
                patients.length,(index){
                  //المريض
                  return MyCard(
                      title: patients[index]["patientName"],
                      subtitle: "${patients[index]["nationNum"]}",
                      trailing: "انقر لرؤية المزيد",
                      //عند الضغط على المريض سيظهر اليرت بجميع تفاصيل المريض للتعديل عليه
                      onTap: () {
                        final parentContext = context;
                        showDialog(
                            context: context,
                            builder: (dialogContext){
                              return StatefulBuilder(builder: (context,setDialogState){
                                //الاليرت
                                return Dialog(
                                    child:  Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(color: Colors.black,offset: Offset(-5, 5),blurRadius: 5)
                                              ],
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: Column(
                                            textDirection: TextDirection.rtl,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              //عنوان الاليرت والذي هو اسم المريض
                                              Text(
                                                patients[index]["patientName"],
                                                style: Theme.of(context).textTheme.titleMedium,
                                              ),
                                              SizedBox(height: 20,),
                                              //سطر عمر المريض
                                              Row(
                                                children: [
                                                  //حقل العمر ولكن سيكون disabled بالبداية
                                                  Expanded(
                                                    flex : 3,
                                                    child: InputField(
                                                        hint: "${patients[index]["patientAge"]}",
                                                        icon: Icon(Icons.elderly),
                                                        isObscure: false,
                                                        controller: controllers[index]["ageController"],
                                                        enabled: controllers[index]["ageEnabled"]
                                                    ),
                                                  ),
                                                  //زر التعديل على حقل العمر والذي سيجعل الحقلenabled
                                                  Expanded(
                                                      child: TextButton(
                                                          onPressed: (){
                                                            setDialogState(() {
                                                              controllers[index]["ageEnabled"] = true;
                                                            });
                                                          },
                                                          child: Text(
                                                            "تعديل",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.blueAccent,
                                                            ),
                                                          )
                                                      )
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              //سطر رقم هاتف المريض
                                              Row(
                                                children: [
                                                  //حقل رقم الهاتف ولكن سيكون disabled بالبداية
                                                  Expanded(
                                                    flex : 3,
                                                    child: InputField(
                                                        hint: "${patients[index]["phoneNum"]}",
                                                        icon: Icon(Icons.phone),
                                                        isObscure: false,
                                                        controller: controllers[index]["phoneController"],
                                                        enabled: controllers[index]["phoneNumEnabled"]
                                                    ),
                                                  ),
                                                  //زر التعديل على حقل رقم الهاتف والذي سيجعل الحقلenabled
                                                  Expanded(
                                                      child: TextButton(
                                                          onPressed: (){
                                                            setDialogState(() {
                                                              controllers[index]["phoneNumEnabled"] = true;
                                                            });
                                                          },
                                                          child: Text(
                                                            "تعديل",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.blueAccent,
                                                            ),
                                                          )
                                                      )
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              //سطر رقم المريض الوطني
                                              Row(
                                                children: [
                                                  //حقل الرقم الوطني ولكن سيكون disabled بالبداية
                                                  Expanded(
                                                    flex : 3,
                                                    child: InputField(
                                                        hint: "${patients[index]["nationNum"]}",
                                                        icon: Icon(Icons.numbers),
                                                        isObscure: false,
                                                        controller: controllers[index]["nationNumController"],
                                                        enabled: controllers[index]["nationNumEnabled"]
                                                    ),
                                                  ),
                                                  //زر التعديل على حقل الرقم الوطني والذي سيجعل الحقلenabled
                                                  Expanded(
                                                      child: TextButton(
                                                          onPressed: (){
                                                            setDialogState(() {
                                                              controllers[index]["nationNumEnabled"] = true;
                                                            });
                                                          },
                                                          child: Text(
                                                            "تعديل",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.blueAccent,
                                                            ),
                                                          )
                                                      )
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              //زر سويتش لحظر المريض وجعله غير قايل لحجز موعد
                                              Card(
                                                shape: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                  borderSide: BorderSide(color: patients[index]["availablity"] ? Colors.red : Colors.blueAccent)
                                                ),
                                                elevation: 7,
                                                shadowColor: Colors.grey,
                                                child: SwitchListTile(
                                                    value: !patients[index]["availablity"],
                                                    onChanged: (val){
                                                      setDialogState((){
                                                        patients[index]["availablity"] = !val;
                                                      });
                                                    },
                                                  title : Text(
                                                    "حظر المريض",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    "عند حظر المريض سيصبح غير قادر على حجز موعد",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w300
                                                    ),
                                                  ),
                                                  activeTrackColor: Colors.blueAccent,
                                                  inactiveTrackColor: Colors.grey,
                                                  thumbColor: WidgetStatePropertyAll(Colors.white),
                                                  trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              //زر حذف المريض من المركز
                                              MyButton(
                                                  onPressed: (){
                                                    //عند الضغط على الزر سيظهر dialog لتأكيد الجذف
                                                    Navigator.of(dialogContext).pop();
                                                    AwesomeDialog(
                                                      context: parentContext,
                                                      title: "هل أنت متأكد من حذف المريض",
                                                      dialogType: DialogType.warning,
                                                      animType: AnimType.rightSlide,
                                                      btnOkOnPress: (){},
                                                      btnCancelOnPress: (){},
                                                      btnOkText: "حذف",
                                                      btnCancelText: "إلغاء",
                                                      btnCancelColor: Colors.green,
                                                      btnOkColor: Colors.red
                                                    ).show();
                                                  },
                                                  label: "حذف المريض",
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                  fontSize: 16,
                                                  btnColor: Colors.redAccent
                                              ),
                                              SizedBox(height: 10,),
                                              //أزرار حفظ التعديل والإلغاء
                                              Row(
                                                children: [
                                                  //زر حفظ التغييرات
                                                  Expanded(child: TextButton(
                                                      onPressed: (){
                                                        //عند الضغط عليه سيظهر dialog لتأكيد التعديل
                                                        Navigator.of(dialogContext).pop();
                                                        AwesomeDialog(
                                                            context: parentContext,
                                                            title: "هل أنت متأكد من التعديل",
                                                            dialogType: DialogType.warning,
                                                            animType: AnimType.rightSlide,
                                                            btnOkOnPress: (){},
                                                            btnCancelOnPress: (){},
                                                            btnOkText: "تعديل",
                                                            btnCancelText: "إلغاء",
                                                            btnCancelColor: Colors.green,
                                                            btnOkColor: Colors.red
                                                        ).show();
                                                      },
                                                      child: Text(
                                                        "حفظ التغييرات",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 14,
                                                          color: Colors.red,
                                                        ),
                                                      )
                                                  )),
                                                  //زر الإلغاء عند الضغط عليه سيتم إزالة الاليرت وعد التعديل
                                                  Expanded(child: TextButton(
                                                      onPressed: (){
                                                        Navigator.of(dialogContext).pop();
                                                      },
                                                      child: Text(
                                                        "إلغاء",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 14,
                                                          color: Colors.green,
                                                        ),
                                                      )
                                                  )),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )

                                );
                              });
                            }
                        );
                      },
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
//حقل البحث
class MySearch extends SearchDelegate {
  @override
  //النص التوضيحي للحقل
  String get searchFieldLabel => "أدخل اسم المريض";
  @override
  //تنسيقات النص التوضيحي
  TextStyle? get searchFieldStyle => TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.grey
  );
  //نوع الkeyboard الذي سيظهر للحقل
  @override
  TextInputType? get keyboardType => TextInputType.name;
  //زر الرجوع والخروج من الحقل
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
  //زر خذف المدخلات للحقل
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.close, color: Colors.red,));
  }
  //النتائج التي ستظهر عند البحث
  @override
  Widget buildResults(BuildContext context) {
    return Text("");
  }
  //المقترحات التي ستظهر عند البحث والتي هي MyCard لكل مريض
  //أيضا عند الضغط عليها سيظهر نفس الأليرت الذي يظهر بالصفحة الرئيسية
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
                  onTap: () {
                    final parentContext = context;
                    showDialog(
                        context: context,
                        builder: (dialogContext){
                          return StatefulBuilder(builder: (context,setDialogState){
                            //الاليرت
                            return Dialog(
                                child:  Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(color: Colors.black,offset: Offset(-5, 5),blurRadius: 5)
                                          ],
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Column(
                                        textDirection: TextDirection.rtl,
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          //عنوان الاليرت والذي هو اسم المريض
                                          Text(
                                            patients[index]["patientName"],
                                            style: Theme.of(context).textTheme.titleMedium,
                                          ),
                                          SizedBox(height: 20,),
                                          //سطر عمر المريض
                                          Row(
                                            children: [
                                              //حقل العمر ولكن سيكون disabled بالبداية
                                              Expanded(
                                                flex : 3,
                                                child: InputField(
                                                    hint: "${patients[index]["patientAge"]}",
                                                    icon: Icon(Icons.elderly),
                                                    isObscure: false,
                                                    controller: controllers[index]["ageController"],
                                                    enabled: controllers[index]["ageEnabled"]
                                                ),
                                              ),
                                              //زر التعديل على حقل العمر والذي سيجعل الحقلenabled
                                              Expanded(
                                                  child: TextButton(
                                                      onPressed: (){
                                                        setDialogState(() {
                                                          controllers[index]["ageEnabled"] = true;
                                                        });
                                                      },
                                                      child: Text(
                                                        "تعديل",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.blueAccent,
                                                        ),
                                                      )
                                                  )
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          //سطر رقم هاتف المريض
                                          Row(
                                            children: [
                                              //حقل رقم الهاتف ولكن سيكون disabled بالبداية
                                              Expanded(
                                                flex : 3,
                                                child: InputField(
                                                    hint: "${patients[index]["phoneNum"]}",
                                                    icon: Icon(Icons.phone),
                                                    isObscure: false,
                                                    controller: controllers[index]["phoneController"],
                                                    enabled: controllers[index]["phoneNumEnabled"]
                                                ),
                                              ),
                                              //زر التعديل على حقل رقم الهاتف والذي سيجعل الحقلenabled
                                              Expanded(
                                                  child: TextButton(
                                                      onPressed: (){
                                                        setDialogState(() {
                                                          controllers[index]["phoneNumEnabled"] = true;
                                                        });
                                                      },
                                                      child: Text(
                                                        "تعديل",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.blueAccent,
                                                        ),
                                                      )
                                                  )
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          //سطر رقم المريض الوطني
                                          Row(
                                            children: [
                                              //حقل الرقم الوطني ولكن سيكون disabled بالبداية
                                              Expanded(
                                                flex : 3,
                                                child: InputField(
                                                    hint: "${patients[index]["nationNum"]}",
                                                    icon: Icon(Icons.numbers),
                                                    isObscure: false,
                                                    controller: controllers[index]["nationNumController"],
                                                    enabled: controllers[index]["nationNumEnabled"]
                                                ),
                                              ),
                                              //زر التعديل على حقل الرقم الوطني والذي سيجعل الحقلenabled
                                              Expanded(
                                                  child: TextButton(
                                                      onPressed: (){
                                                        setDialogState(() {
                                                          controllers[index]["nationNumEnabled"] = true;
                                                        });
                                                      },
                                                      child: Text(
                                                        "تعديل",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.blueAccent,
                                                        ),
                                                      )
                                                  )
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          //زر سويتش لحظر المريض وجعله غير قايل لحجز موعد
                                          Card(
                                            shape: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(20),
                                                borderSide: BorderSide(color: patients[index]["availablity"] ? Colors.red : Colors.blueAccent)
                                            ),
                                            elevation: 7,
                                            shadowColor: Colors.grey,
                                            child: SwitchListTile(
                                              value: !patients[index]["availablity"],
                                              onChanged: (val){
                                                setDialogState((){
                                                  patients[index]["availablity"] = !val;
                                                });
                                              },
                                              title : Text(
                                                "حظر المريض",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              subtitle: Text(
                                                "عند حظر المريض سيصبح غير قادر على حجز موعد",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w300
                                                ),
                                              ),
                                              activeTrackColor: Colors.blueAccent,
                                              inactiveTrackColor: Colors.grey,
                                              thumbColor: WidgetStatePropertyAll(Colors.white),
                                              trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          //زر حذف المريض من المركز
                                          MyButton(
                                              onPressed: (){
                                                //عند الضغط على الزر سيظهر dialog لتأكيد الجذف
                                                Navigator.of(dialogContext).pop();
                                                AwesomeDialog(
                                                    context: parentContext,
                                                    title: "هل أنت متأكد من حذف المريض",
                                                    dialogType: DialogType.warning,
                                                    animType: AnimType.rightSlide,
                                                    btnOkOnPress: (){},
                                                    btnCancelOnPress: (){},
                                                    btnOkText: "حذف",
                                                    btnCancelText: "إلغاء",
                                                    btnCancelColor: Colors.green,
                                                    btnOkColor: Colors.red
                                                ).show();
                                              },
                                              label: "حذف المريض",
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                              fontSize: 16,
                                              btnColor: Colors.redAccent
                                          ),
                                          SizedBox(height: 10,),
                                          //أزرار حفظ التعديل والإلغاء
                                          Row(
                                            children: [
                                              //زر حفظ التغييرات
                                              Expanded(child: TextButton(
                                                  onPressed: (){
                                                    //عند الضغط عليه سيظهر dialog لتأكيد التعديل
                                                    Navigator.of(dialogContext).pop();
                                                    AwesomeDialog(
                                                        context: parentContext,
                                                        title: "هل أنت متأكد من التعديل",
                                                        dialogType: DialogType.warning,
                                                        animType: AnimType.rightSlide,
                                                        btnOkOnPress: (){},
                                                        btnCancelOnPress: (){},
                                                        btnOkText: "تعديل",
                                                        btnCancelText: "إلغاء",
                                                        btnCancelColor: Colors.green,
                                                        btnOkColor: Colors.red
                                                    ).show();
                                                  },
                                                  child: Text(
                                                    "حفظ التغييرات",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 14,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                              )),
                                              //زر الإلغاء عند الضغط عليه سيتم إزالة الاليرت وعد التعديل
                                              Expanded(child: TextButton(
                                                  onPressed: (){
                                                    Navigator.of(dialogContext).pop();
                                                  },
                                                  child: Text(
                                                    "إلغاء",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 14,
                                                      color: Colors.green,
                                                    ),
                                                  )
                                              )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )

                            );
                          });
                        }
                    );
                  },
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
                onTap: () {
                  final parentContext = context;
                  showDialog(
                      context: context,
                      builder: (dialogContext){
                        return StatefulBuilder(builder: (context,setDialogState){
                          //الاليرت
                          return Dialog(
                              child:  Directionality(
                                textDirection: TextDirection.rtl,
                                child: SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(color: Colors.black,offset: Offset(-5, 5),blurRadius: 5)
                                        ],
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Column(
                                      textDirection: TextDirection.rtl,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        //عنوان الاليرت والذي هو اسم المريض
                                        Text(
                                          patients[index]["patientName"],
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                        SizedBox(height: 20,),
                                        //سطر عمر المريض
                                        Row(
                                          children: [
                                            //حقل العمر ولكن سيكون disabled بالبداية
                                            Expanded(
                                              flex : 3,
                                              child: InputField(
                                                  hint: "${patients[index]["patientAge"]}",
                                                  icon: Icon(Icons.elderly),
                                                  isObscure: false,
                                                  controller: controllers[index]["ageController"],
                                                  enabled: controllers[index]["ageEnabled"]
                                              ),
                                            ),
                                            //زر التعديل على حقل العمر والذي سيجعل الحقلenabled
                                            Expanded(
                                                child: TextButton(
                                                    onPressed: (){
                                                      setDialogState(() {
                                                        controllers[index]["ageEnabled"] = true;
                                                      });
                                                    },
                                                    child: Text(
                                                      "تعديل",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.blueAccent,
                                                      ),
                                                    )
                                                )
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        //سطر رقم هاتف المريض
                                        Row(
                                          children: [
                                            //حقل رقم الهاتف ولكن سيكون disabled بالبداية
                                            Expanded(
                                              flex : 3,
                                              child: InputField(
                                                  hint: "${patients[index]["phoneNum"]}",
                                                  icon: Icon(Icons.phone),
                                                  isObscure: false,
                                                  controller: controllers[index]["phoneController"],
                                                  enabled: controllers[index]["phoneNumEnabled"]
                                              ),
                                            ),
                                            //زر التعديل على حقل رقم الهاتف والذي سيجعل الحقلenabled
                                            Expanded(
                                                child: TextButton(
                                                    onPressed: (){
                                                      setDialogState(() {
                                                        controllers[index]["phoneNumEnabled"] = true;
                                                      });
                                                    },
                                                    child: Text(
                                                      "تعديل",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.blueAccent,
                                                      ),
                                                    )
                                                )
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        //سطر رقم المريض الوطني
                                        Row(
                                          children: [
                                            //حقل الرقم الوطني ولكن سيكون disabled بالبداية
                                            Expanded(
                                              flex : 3,
                                              child: InputField(
                                                  hint: "${patients[index]["nationNum"]}",
                                                  icon: Icon(Icons.numbers),
                                                  isObscure: false,
                                                  controller: controllers[index]["nationNumController"],
                                                  enabled: controllers[index]["nationNumEnabled"]
                                              ),
                                            ),
                                            //زر التعديل على حقل الرقم الوطني والذي سيجعل الحقلenabled
                                            Expanded(
                                                child: TextButton(
                                                    onPressed: (){
                                                      setDialogState(() {
                                                        controllers[index]["nationNumEnabled"] = true;
                                                      });
                                                    },
                                                    child: Text(
                                                      "تعديل",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.blueAccent,
                                                      ),
                                                    )
                                                )
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        //زر سويتش لحظر المريض وجعله غير قايل لحجز موعد
                                        Card(
                                          shape: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              borderSide: BorderSide(color: patients[index]["availablity"] ? Colors.red : Colors.blueAccent)
                                          ),
                                          elevation: 7,
                                          shadowColor: Colors.grey,
                                          child: SwitchListTile(
                                            value: !patients[index]["availablity"],
                                            onChanged: (val){
                                              setDialogState((){
                                                patients[index]["availablity"] = !val;
                                              });
                                            },
                                            title : Text(
                                              "حظر المريض",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            subtitle: Text(
                                              "عند حظر المريض سيصبح غير قادر على حجز موعد",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w300
                                              ),
                                            ),
                                            activeTrackColor: Colors.blueAccent,
                                            inactiveTrackColor: Colors.grey,
                                            thumbColor: WidgetStatePropertyAll(Colors.white),
                                            trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        //زر حذف المريض من المركز
                                        MyButton(
                                            onPressed: (){
                                              //عند الضغط على الزر سيظهر dialog لتأكيد الجذف
                                              Navigator.of(dialogContext).pop();
                                              AwesomeDialog(
                                                  context: parentContext,
                                                  title: "هل أنت متأكد من حذف المريض",
                                                  dialogType: DialogType.warning,
                                                  animType: AnimType.rightSlide,
                                                  btnOkOnPress: (){},
                                                  btnCancelOnPress: (){},
                                                  btnOkText: "حذف",
                                                  btnCancelText: "إلغاء",
                                                  btnCancelColor: Colors.green,
                                                  btnOkColor: Colors.red
                                              ).show();
                                            },
                                            label: "حذف المريض",
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                            fontSize: 16,
                                            btnColor: Colors.redAccent
                                        ),
                                        SizedBox(height: 10,),
                                        //أزرار حفظ التعديل والإلغاء
                                        Row(
                                          children: [
                                            //زر حفظ التغييرات
                                            Expanded(child: TextButton(
                                                onPressed: (){
                                                  //عند الضغط عليه سيظهر dialog لتأكيد التعديل
                                                  Navigator.of(dialogContext).pop();
                                                  AwesomeDialog(
                                                      context: parentContext,
                                                      title: "هل أنت متأكد من التعديل",
                                                      dialogType: DialogType.warning,
                                                      animType: AnimType.rightSlide,
                                                      btnOkOnPress: (){},
                                                      btnCancelOnPress: (){},
                                                      btnOkText: "تعديل",
                                                      btnCancelText: "إلغاء",
                                                      btnCancelColor: Colors.green,
                                                      btnOkColor: Colors.red
                                                  ).show();
                                                },
                                                child: Text(
                                                  "حفظ التغييرات",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: Colors.red,
                                                  ),
                                                )
                                            )),
                                            //زر الإلغاء عند الضغط عليه سيتم إزالة الاليرت وعد التعديل
                                            Expanded(child: TextButton(
                                                onPressed: (){
                                                  Navigator.of(dialogContext).pop();
                                                },
                                                child: Text(
                                                  "إلغاء",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: Colors.green,
                                                  ),
                                                )
                                            )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )

                          );
                        });
                      }
                  );
                },
                trailingColor: Colors.green
            );
          },
        ),
      );
    }
  }
}
