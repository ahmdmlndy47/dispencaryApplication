import 'package:flutter/material.dart';
class MyButton extends StatelessWidget {
  final void Function() onPressed;
  final Color btnColor;
  final String label;
  final ShapeBorder shape;
  final double fontSize;
  const MyButton({super.key, required this.onPressed, required this.label, required this.shape, required this.fontSize,required this.btnColor});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      shape: shape,
      onPressed: onPressed,
      elevation: 7,
      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
      color: btnColor,
      child: Text(
        label,
        style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w300
        ),
      ),
    );
  }
}
