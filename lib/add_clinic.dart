import 'package:flutter/material.dart';
class AddClinic extends StatefulWidget {
  const AddClinic({super.key});

  @override
  State<AddClinic> createState() => _AddClinicState();
}

class _AddClinicState extends State<AddClinic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("إضافة عيادة"),
        centerTitle: true,
      ),
    );
  }
}
