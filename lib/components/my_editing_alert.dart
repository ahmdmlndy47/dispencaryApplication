import 'package:dispensary/components/input_field.dart';
import 'package:flutter/material.dart';
class MyEditingAlert extends StatelessWidget {
  final void Function() onVerifyPressed;
  final String doctorHint;
  final Icon iconHint;
  final TextEditingController fieldController;
  final bool isFieldSecure;
  final bool enabledField;
  const MyEditingAlert({super.key, required this.doctorHint, required this.fieldController, required this.isFieldSecure, required this.enabledField, required this.iconHint, required this.onVerifyPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Directionality(
        textDirection: TextDirection.ltr,
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
                        validator: (val){},
                        hint:doctorHint,
                        icon: iconHint,
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