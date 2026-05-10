import 'package:dispensary/components/input_field.dart';
import 'package:flutter/material.dart';
class MyAlert extends StatelessWidget {
  final void Function() onVerifyPressed;
  final String firstFieldHint;
  final String secondFieldHint;
  final Icon firstFieldIcon;
  final Icon secondFieldIcon;
  final TextEditingController fieldController;
  final bool isFieldSecure;
  final bool enabledField;
  const MyAlert({super.key, required this.firstFieldIcon, required this.fieldController, required this.isFieldSecure, required this.enabledField, required this.firstFieldHint, required this.secondFieldHint, required this.secondFieldIcon, required this.onVerifyPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Text(
                  "التعديل على العيادة",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30,),
              Form(
                  child: Column(
                    children: [
                      InputField(
                          hint: firstFieldHint,
                          icon: firstFieldIcon,
                          isObscure: isFieldSecure,
                          controller: fieldController,
                          enabled: enabledField),
                      SizedBox(height: 20,),
                      InputField(
                          hint: secondFieldHint,
                          icon: secondFieldIcon,
                          isObscure: isFieldSecure,
                          controller: fieldController,
                          enabled: enabledField),
                    ],
                  ),),
              SizedBox(height: 80,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "إلغاء",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.red
                        ),)),
                  TextButton(
                      onPressed: onVerifyPressed,
                      child: Text(
                        "تعديل",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.red
                        ),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
