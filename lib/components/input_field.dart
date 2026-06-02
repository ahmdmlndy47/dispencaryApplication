import 'package:flutter/material.dart';
class InputField extends StatefulWidget {
  final String? Function(String?)? validator;
  final String hint;
  final Icon icon;
  final  bool isObscure;
  final TextEditingController controller;
  final bool enabled;
  const InputField({super.key, required this.hint, required this.icon, required this.isObscure, required this.controller, required this.enabled,  this.validator});

  @override
  State<InputField> createState() => _InputFieldState();
}
bool secure = true;
class _InputFieldState extends State<InputField> {
  @override
  void initState() {
    super.initState();
    secure = widget.isObscure;
  }
  @override
  Widget build(BuildContext context) {
    if (widget.isObscure){
      return  TextFormField(
        validator: widget.validator,
        enabled: widget.enabled,
        controller: widget.controller,
        textAlign: TextAlign.right,
        obscureText: secure,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          filled: true,
          fillColor: Colors.blue[50],
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Colors.black54),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Colors.grey),
          ),
          suffixIcon: widget.icon,
          prefixIcon: IconButton(
            icon: Icon(
              secure ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                secure = !secure;
              });
            },
          ),
        ),
      );
    }else {
      return TextFormField(
        validator: widget.validator,
          enabled: widget.enabled,
      controller: widget.controller,
      textAlign: TextAlign.right,
      keyboardType:TextInputType.emailAddress,
      decoration: InputDecoration(
      hintText: widget.hint,
      hintStyle: TextStyle(
      fontSize: 13,
      color: Colors.grey,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
      filled:true,
      fillColor: Colors.blue[50],
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide(color: Colors.black54),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(color: Colors.blue),
      ),
      enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(40),
    borderSide: BorderSide(color: Colors.grey),
    ),
    suffixIcon:widget.icon,
    prefixIcon:IconButton(
    icon: Icon(Icons.close),
    onPressed: () => widget.controller.clear(),
    ),
    )
    );
    }
  }
}
