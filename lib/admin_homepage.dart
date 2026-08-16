import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispensary/components/card_widget.dart';
import 'package:dispensary/components/main_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}
// الصفحة الرئيسية للآدمن
class _AdminHomepageState extends State<AdminHomepage> {
  List<QueryDocumentSnapshot> doctors = [];
  final Stream<QuerySnapshot> stream =
      FirebaseFirestore.instance.collectionGroup("dispensaries")
      .where("admins",arrayContains: FirebaseAuth.instance.currentUser!.uid)
      .limit(1).snapshots();
  String? selectedDoc;
  final TextEditingController addingClinicController = TextEditingController();
  final Icon clinicIcon = Icon(Icons.medical_information);
  final Icon doctorIcon = Icon(Icons.person);
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  TextEditingController editingController = TextEditingController();
  getDoctors() async{
    final snapshot =await FirebaseFirestore.instance.collectionGroup("dispensaries").where("admins",arrayContains: FirebaseAuth.instance.currentUser!.uid).limit(1).get();
    if (snapshot.docs.isEmpty) {
      return;
    }
    final docsSnapshot = await snapshot.docs.first.reference.collection("doctors").get();
    if(!mounted) return;
    setState(() {
      doctors = docsSnapshot.docs;
    });
  }
  @override
  void initState() {
    super.initState();
    getDoctors();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("المدير",),
        //زر تسجيل الخروج
        actions: [
          ElevatedButton.icon(
            onPressed: (){
              AwesomeDialog(
                  context: context,
                  title: "تسجيل الخروج",
                  desc: "هل أنت متأكد من تسجيل الخروج",
                  dialogType: DialogType.question,
                  showCloseIcon: true,
                  animType: AnimType.rightSlide,
                  btnOkOnPress: (){
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil("logOrSignPage", (route)=>false);
                  },
                  btnCancelOnPress: (){},
                  btnOkText: "نعم",
                  btnCancelText: "لا"
              ).show();
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
      ),
      //جسم الصفحة
      body: StreamBuilder(
          stream: stream,
          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
            //في حال مازال يتم تحميل البيانات ستظهر دائرة الloading
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            //في حال لم يتم الحصول على اي بيانات لعرضها سيتم إظهار رسالة توضيحية
            if(!snapshot.hasData || snapshot.data!.docs.length == 0){
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(-5, 5),
                                  blurRadius: 5
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Text(
                          "لا يوجد بيانات لعرضها",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent
                          ),
                        ),
                      ),
                    ),),
                ),
              );
            }
            //عندما نصل الى هنا هذا يعني اننا حصلنا على البيانات بشكل صحيح
            return Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                children: [
                  //أزرار الإضافة والتعديل على المرضى والأطباء
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              offset: Offset(-5, 5))
                        ]
                    ),
                    child: Column(
                      children: [
                        //زر لإضافة عيادة
                        MyButton(
                            onPressed: (){
                              Navigator.of(context).pushNamed("addClinic");
                            },
                            label: "إضافة عيادة",
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)
                            ),
                            fontSize: 18,
                            btnColor: Colors.blueAccent),
                        SizedBox(height: 20,),
                        //أزرار إضافة المستخدمين
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //زر إضافة مريض
                            Expanded(
                              child: MyButton(
                                  onPressed: (){
                                    Navigator.of(context).pushNamed("addPatientPage");
                                  },
                                  btnColor: Colors.blueAccent,
                                  fontSize: 18,
                                  label: "إضافة مريض",
                                  shape: RoundedRectangleBorder()),
                            ),
                            SizedBox(width: 20,),
                            // زر إضافة طبيب
                            Expanded(
                              child: MyButton(
                                  onPressed: (){
                                    Navigator.of(context).pushNamed("addDoctorPage");
                                  },
                                  btnColor: Colors.blueAccent,
                                  fontSize: 18,
                                  label: "إضافة طبيب",
                                  shape: RoundedRectangleBorder()),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        //أزرار التعديل على المستخدمين
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //زر لعرض قائمة المرضى المسجلين بالتطبيق
                            Expanded(
                              child: MyButton(
                                  onPressed: (){
                                    Navigator.of(context).pushNamed("patientList");
                                  },
                                  btnColor: Colors.blueAccent,
                                  fontSize: 18,
                                  label: "مرضى المستوصف",
                                  shape: RoundedRectangleBorder()),
                            ),
                            SizedBox(width: 20,),
                            // زر لعرض قائمة أطباء المستوصف
                            Expanded(
                              child:MyButton(
                                  onPressed: (){
                                    Navigator.of(context).pushNamed("doctorsList");
                                  },
                                  btnColor: Colors.blueAccent,
                                  fontSize: 18,
                                  label: "أطباء المستوصف",
                                  shape: RoundedRectangleBorder()),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  //قائمة عيادات المستوصف للتعديل عليها من قبل الآدمن
                  Text(
                    "عيادات المستوصف",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 10,),
                  StreamBuilder(
                      stream: snapshot.data!.docs.first.reference.collection("clinics").snapshots(),
                      builder: (context,AsyncSnapshot<QuerySnapshot> clinics){
                        //في حال مازال يتم تحميل البيانات ستظهر دائرة الloading
                        if(clinics.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        //في حال لم يتم الحصول على اي بيانات لعرضها سيتم إظهار رسالة توضيحية
                        if(!clinics.hasData || clinics.data!.docs.length == 0){
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(-5, 5),
                                              blurRadius: 5
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Text(
                                      "لا يوجد بيانات لعرضها",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent
                                      ),
                                    ),
                                  ),
                                ),),
                            ),
                          );
                        }
                        //إذا وصلنا لهنا فنحن جلبنا العيادات بشكل صحيح وسيتم عرضها
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: clinics.data!.docs.length,
                            itemBuilder: (context,index){
                              //كل عيادة سيتم عرضها من خلال card
                            return MyCard(
                                title: clinics.data!.docs[index]["clinicName"],
                                subtitle: clinics.data!.docs[index]["docName"],
                                trailing: "انقر للتعديل",
                                trailingColor: Colors.red,
                                onTap: (){
                                  selectedDoc = clinics.data!.docs[index]["docName"];
                                  final parentContext = context;
                                  //عند الضغط على العيادة سيظهر بوب اب التعديل
                                  showDialog(
                                      context: context,
                                      builder: (dialogContext){
                                        //البوب اب الذي سيظهر
                                        return Dialog(
                                          child: SingleChildScrollView(
                                            child: Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: Padding(
                                                padding: const EdgeInsets.all(20.0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    //عتوان بوب اب التعديل
                                                    Text(
                                                      "التعديل على العيادة",
                                                      style: TextStyle(
                                                        fontSize: 26,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 30,),
                                                    //السيليكشن الخاصة باسماء الأطباء
                                                    Form(
                                                      child: Directionality(
                                                        textDirection: TextDirection.rtl,
                                                        child: Column(
                                                          children: [
                                                            DropdownButtonFormField(
                                                                decoration: InputDecoration(
                                                                  prefixIcon: Icon(Icons.person),
                                                                  border: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(20)
                                                                  ),
                                                                  hintText: "اسم الطبيب",
                                                                ),
                                                                //سيظهر فقط الأطباء الموجودين ضمن هذا المستوصف
                                                                items: doctors.map<DropdownMenuItem<String>>((doctor){
                                                                  return DropdownMenuItem(
                                                                    value: "${doctor["firstName"]} ${doctor["lastName"]}",
                                                                    child: Text(
                                                                      "${doctor["firstName"]} ${doctor["lastName"]}",
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                onChanged: (val){
                                                                  setState(() {
                                                                    selectedDoc = val;
                                                                  });
                                                                }),
                                                            SizedBox(height: 20,),
                                                            //زر إيقاف العيادة
                                                            MyButton(
                                                                onPressed: () async{
                                                                  final messenger = ScaffoldMessenger.of(parentContext);
                                                                  Navigator.of(dialogContext).pop();
                                                                  //عند الضغط عليه سيتم إظهار dialog لتأكيد الإيقاف
                                                                  AwesomeDialog(
                                                                      context: parentContext,
                                                                      title: "إيقاف العيادة",
                                                                      desc: "هل انت متأكد من إيقاف العيادة",
                                                                      dialogType: DialogType.warning,
                                                                      animType: AnimType.rightSlide,
                                                                      btnCancelText: "لا",
                                                                      btnOkText: "نعم",
                                                                      showCloseIcon: true,
                                                                      btnCancelOnPress: (){},
                                                                      btnOkOnPress: () async{
                                                                        //يتم الاختبار اولا في حال كانت العيادة تم إيقافها أم لا
                                                                        if(clinics.data!.docs[index]["available"]) {
                                                                          //عند التأكيد و العيادة غير موقفة سيتم تعديل بيانات العيادة لجعلها غير متاحة
                                                                         await clinics
                                                                              .data!
                                                                              .docs[index]
                                                                              .reference
                                                                              .update(
                                                                              {
                                                                                "available": false,
                                                                              });
                                                                          //وثم إظهار رسالة لتوضيح الإيقاف
                                                                          messenger
                                                                              .showSnackBar(
                                                                              SnackBar(
                                                                                content: Text(
                                                                                    "تم الإيقاف"),
                                                                                duration: Duration(
                                                                                    seconds: 1),
                                                                              )
                                                                          );
                                                                        }
                                                                        //في حال التأكيد وتم إيقاف العيادة سيتم إظهار dialog لتوضيح الخطأ
                                                                        else{
                                                                          AwesomeDialog(
                                                                            context: parentContext,
                                                                            dialogType: DialogType.error,
                                                                            title: "خطأ",
                                                                            desc: "تم إيقاف العيادة مسبقا",
                                                                            titleTextStyle: TextStyle(
                                                                              fontSize: 20,
                                                                              color: Colors.red,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                            descTextStyle: TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 16,
                                                                              color: Colors.red
                                                                            )
                                                                          ).show();
                                                                        }
                                                                      }
                                                                  ).show();
                                                                },
                                                                label: "إيقاف العيادة",
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20)
                                                                ),
                                                                fontSize: 18,
                                                                btnColor: Colors.red
                                                            ),
                                                            SizedBox(height: 20,),
                                                            //زر تشغيل العيادة
                                                            MyButton(
                                                                onPressed: () async{
                                                                  final messenger = ScaffoldMessenger.of(parentContext);
                                                                  Navigator.of(dialogContext).pop();
                                                                  //عند الضغط عليه سيتم إظهار dialog لتأكيد الإيقاف
                                                                  AwesomeDialog(
                                                                      context: parentContext,
                                                                      title: "إيقاف العيادة",
                                                                      desc: "هل انت متأكد من إيقاف العيادة",
                                                                      dialogType: DialogType.warning,
                                                                      animType: AnimType.rightSlide,
                                                                      btnCancelText: "لا",
                                                                      btnOkText: "نعم",
                                                                      showCloseIcon: true,
                                                                      btnCancelOnPress: (){},
                                                                      btnOkOnPress: () async{
                                                                        //يتم الاختبار اولا في حال كانت العيادة تم إيقافها أم لا
                                                                        if(!clinics.data!.docs[index]["available"]) {
                                                                          //عند التأكيد و العيادة  موقفة سيتم تعديل بيانات العيادة لجعلها  متاحة
                                                                          await clinics
                                                                              .data!
                                                                              .docs[index]
                                                                              .reference
                                                                              .update(
                                                                              {
                                                                                "available": true,
                                                                              });
                                                                          //وثم إظهار رسالة لتوضيح التفعيل
                                                                          messenger
                                                                              .showSnackBar(
                                                                              SnackBar(
                                                                                content: Text(
                                                                                    "تم التفعيل"),
                                                                                duration: Duration(
                                                                                    seconds: 1),
                                                                              )
                                                                          );
                                                                        }
                                                                        //في حال التأكيد ولم يتم إيقاف العيادة سيتم إظهار dialog لتوضيح الخطأ
                                                                        else{
                                                                          AwesomeDialog(
                                                                              context: parentContext,
                                                                              dialogType: DialogType.error,
                                                                              title: "خطأ",
                                                                              desc: " لم يتم إيقاف العيادة مسبقا",
                                                                              titleTextStyle: TextStyle(
                                                                                fontSize: 20,
                                                                                color: Colors.red,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                              descTextStyle: TextStyle(
                                                                                  fontWeight: FontWeight.w400,
                                                                                  fontSize: 16,
                                                                                  color: Colors.red
                                                                              )
                                                                          ).show();
                                                                        }
                                                                      }
                                                                  ).show();
                                                                },
                                                                label: "تفعيل العيادة",
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(20)
                                                                ),
                                                                fontSize: 18,
                                                                btnColor: Colors.green
                                                            ),
                                                            SizedBox(height: 20,),
                                                            //زر حذف العيادة
                                                            MyButton(
                                                                onPressed: () async{
                                                                  final messenger = ScaffoldMessenger.of(parentContext);
                                                                  Navigator.of(dialogContext).pop();
                                                                  //عند الضغط عليه سيظهر ديالوغ لتأكيد الحذف
                                                                  AwesomeDialog(
                                                                      context: parentContext,
                                                                      title: "حذف عيادة",
                                                                      desc: "هل انت متأكد من حذف العيادة",
                                                                      dialogType: DialogType.warning,
                                                                      animType: AnimType.rightSlide,
                                                                      btnCancelText: "لا",
                                                                      btnOkText: "نعم",
                                                                      showCloseIcon: true,
                                                                      btnCancelOnPress: (){},
                                                                      btnOkOnPress: () async{
                                                                        //عند تأكيد الحذف سيتم إزالة العيادة من قاعدة بيانات المستوصف
                                                                        await clinics.data!.docs[index].reference.delete();
                                                                        //وثم إظهار رسالة لتوضيح الحذف
                                                                        messenger.showSnackBar(
                                                                            SnackBar(
                                                                              content: Text("تم الحذف"),
                                                                              duration: Duration(seconds: 1),
                                                                            )
                                                                        );
                                                                      }
                                                                  ).show();
                                                                },
                                                                btnColor: Colors.red,
                                                                label: "حذف العيادة",
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20),
                                                                ),
                                                                fontSize: 18)
                                                          ],
                                                        ),
                                                      ),),
                                                    SizedBox(height: 20,),
                                                    //أزرار التأكيد و الإلغاء
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        //زر الإلغاء
                                                        Expanded(
                                                          child: TextButton(
                                                              onPressed: (){
                                                                Navigator.of(dialogContext).pop();
                                                              },
                                                              child: Text(
                                                                "إلغاء",
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w300,
                                                                    color: Colors.red
                                                                ),)),
                                                        ),
                                                        //زر التأكيد
                                                        Expanded(
                                                          child: TextButton(
                                                              onPressed: (){
                                                                //عند الضغط عليه سيظهر ديالوغ لتأكيد التعديل
                                                                AwesomeDialog(
                                                                    context: parentContext,
                                                                    title: "تعديل العيادة",
                                                                    desc: "هل انت متأكد من التعديل",
                                                                    dialogType: DialogType.warning,
                                                                    animType: AnimType.rightSlide,
                                                                    btnCancelText: "لا",
                                                                    btnOkText: "نعم",
                                                                    showCloseIcon: true,
                                                                    btnCancelOnPress: (){},
                                                                    btnOkOnPress: ()async{
                                                                      //عند التأكيد سيتحقق اولا فيما إذا تم اختيار طبيب
                                                                      if (selectedDoc == null) {
                                                                        //في حال لم يتم اختيار طبيب سيظهرsnackbar يوضح أنه يجب اختيار طبيب
                                                                        ScaffoldMessenger.of(parentContext).showSnackBar(
                                                                          const SnackBar(content: Text("اختر الطبيب أولاً")),
                                                                        );
                                                                        return;
                                                                      }
                                                                      //إذا وصلنا لهنا هذا يعني أنه تم التأكيد وتم اختيار طبيب
                                                                      //لذلك سيتم تعديل بيانات العيادة للبيانات الجديدة
                                                                     await clinics.data!.docs[index].reference.update(
                                                                          {"docName" : selectedDoc});
                                                                      Navigator.of(dialogContext).pop();
                                                                     if(!mounted) return;
                                                                    }
                                                                ).show();
                                                              },
                                                              child: Text(
                                                                "تعديل",
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w300,
                                                                    color: Colors.red
                                                                ),)),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                }
                            );
                            }
                        );
                      }
                  ),
                  SizedBox(height: 20,),
                  //قائمة المرضى الذين قد تخلفو عن مواعيدهم
                  Text(
                    "المرضى المتخلفين عن موعد",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  StreamBuilder(
                      stream: snapshot.data!.docs.first.reference.collection("patients").where("missedAnApp",isEqualTo: true).snapshots(),
                      //في حال مازال يتم تحميل البيانات ستظهر دائرة الloading
                      builder: (context,AsyncSnapshot<QuerySnapshot> patients){
                        if(patients.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        if(patients.hasError){
                          return Text(
                            "ERROR: ${snapshot.error}",
                            style: const TextStyle(color: Colors.red),
                          );
                        }
                        //في حال لم يتم الحصول على اي بيانات لعرضها سيتم إظهار رسالة توضيحية
                        if(!patients.hasData || patients.data!.docs.length == 0){
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(-5, 5),
                                              blurRadius: 5
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Text(
                                      "لا يوجد بيانات لعرضها",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent
                                      ),
                                    ),
                                  ),
                                ),),
                            ),
                          );
                        }
                        //عند الوصول لهنا هذا يعني أننا حصلنا على مرضى
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: patients.data!.docs.length,
                            itemBuilder: (context,index){
                              //كل مريض عبارة عن card
                              return MyCard(
                                  title: "${patients.data!.docs[index]["firstName"]} ${patients.data!.docs[index]["lastName"]}",
                                  subtitle: "${patients.data!.docs[index]["phone"]}",
                                  trailing: "انقر للتعديل",
                                  //عند الضغط عليها سيظهر dialog لحظر المريض بما انه قد تخلف عن موعد
                                  onTap: ()async{
                                    final parentContext = context;
                                    showDialog(
                                        context: context,
                                        builder: (dialogContext){
                                          //الdialog الذي سيظهر
                                          return Dialog(
                                            child: Directionality(
                                                textDirection: TextDirection.rtl,
                                                child: Container(
                                                  padding: EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey,
                                                        blurRadius: 5,
                                                        offset: Offset(-5, 5)
                                                      ),
                                                    ],
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      //عنوان الdialog والذي هو اسم المريض
                                                      Text(
                                                        "${patients.data!.docs[index]["firstName"]} ${patients.data!.docs[index]["lastName"]}",
                                                        style: Theme.of(context).textTheme.titleMedium,
                                                      ),
                                                      SizedBox(height: 30,),
                                                      //زر حظر المريض
                                                      MyButton(
                                                          onPressed: () async{
                                                            final messenger = ScaffoldMessenger.of(parentContext);
                                                            //عند الضغط عليه سيتم إزالة الdialog أولا
                                                            Navigator.of(dialogContext).pop();
                                                            //ثم سيتم إظهار dialog لتأكيد الحظر
                                                            AwesomeDialog(
                                                              context: parentContext,
                                                              title: "هل انت متأكد من حظر المريض",
                                                              titleTextStyle: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.red
                                                              ),
                                                              btnOkText: "نعم",
                                                              btnCancelText: "لا",
                                                              btnOkColor: Colors.green,
                                                              btnCancelColor: Colors.red,
                                                              dialogType: DialogType.question,
                                                              btnOkOnPress: ()async{
                                                                //عند تأكيد الحظر
                                                                //أولا سيتم تعديل بيانات المريض لكي يصبح محظور
                                                                //وأيضا بعد حظره يتم إزالته من القائمة عن طريق تعديل الmissedAnApp إلى false
                                                                await patients.data!.docs[index].reference.update(
                                                                    {
                                                                      "missedAnApp" : false,
                                                                      "available" : false,
                                                                    });
                                                                //ثم يتم إظهار snackbar يؤكد أنه تم الحظر

                                                                messenger.showSnackBar(
                                                                  SnackBar(
                                                                    content: Text("تم حظر المريض"),
                                                                    duration: Duration(seconds: 1),
                                                                  )
                                                                );
                                                              },
                                                              btnCancelOnPress: (){}
                                                            ).show();
                                                          },
                                                          label: "حظر المريض",
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                          fontSize: 18,
                                                          btnColor: Colors.red
                                                      ),
                                                    ],
                                                  ),
                                                )
                                            ),
                                          );
                                        });
                                  },
                                  trailingColor: Colors.red
                              );
                            }
                        );
                      }
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}
