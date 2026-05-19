import 'package:dispensary/components/input_field.dart';
import 'package:flutter/material.dart';

import 'components/main_button.dart';
class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
late TextEditingController firstNameController;
late TextEditingController lastNameController;
late TextEditingController ageController;
late TextEditingController phoneNumController;
late TextEditingController nationNumController;

@override
  void initState() {
  firstNameController = TextEditingController();
  lastNameController = TextEditingController();
  ageController = TextEditingController();
  phoneNumController = TextEditingController();
  nationNumController = TextEditingController();
  super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    phoneNumController.dispose();
    nationNumController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //عنوان الصفحة
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "صفحة إضافة مريض",
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //حقل إدخال الاسم الأول
                Text(
                  "الاسم الأول",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                InputField(
                    hint: "أدخل الاسم الأول",
                    icon: Icon(Icons.person),
                    isObscure: false,
                    controller: firstNameController,
                    enabled: true,
                    validator: (val){}
                ),
                SizedBox(height: 20,),
                //حقل إدخال الاسم الأخير
                Text(
                  "الاسم الأخير",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                InputField(
                    hint: "أدخل الاسم الأخير",
                    icon: Icon(Icons.person),
                    isObscure: false,
                    controller: lastNameController,
                    enabled: true,
                    validator: (val){}
                ),
                SizedBox(height: 20,),
                //حقل إدخال العمر
                Text(
                  "العمر",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                InputField(
                    hint: "أدخل العمر",
                    icon: Icon(Icons.elderly),
                    isObscure: false,
                    controller: ageController,
                    enabled: true,
                    validator: (val){}
                ),
                SizedBox(height: 20,),
                //حقل إدخال رقم الهاتف
                Text(
                  "رقم الهاتف",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                InputField(
                    hint: "أدخل رقم الهاتف",
                    icon: Icon(Icons.phone),
                    isObscure: false,
                    controller: phoneNumController,
                    enabled: true,
                    validator: (val){}
                ),
                SizedBox(height: 20,),
                //حقل إدخال الرقم الوطني
                Text(
                  "الرقم الوطني",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                InputField(
                    hint: "أدخل الرقم الوطني",
                    icon: Icon(Icons.numbers),
                    isObscure: false,
                    controller: nationNumController,
                    enabled: true,
                    validator: (val){}
                ),
                SizedBox(height: 20,),
                //زر الإضافة
                MyButton(
                    onPressed: (){},
                    btnColor: Colors.blueAccent,
                    label: "إضافة المريض",
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fontSize: 18
                )
              ],
            )
        ),
      ),
    );
  }
}
