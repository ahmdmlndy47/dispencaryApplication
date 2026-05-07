import 'package:flutter/material.dart';
class Speciality extends StatefulWidget {
  final String specialityName;
  final String doctorName;
  const Speciality({super.key, required this.specialityName, required this.doctorName});

  @override
  State<Speciality> createState() => _SpecialityState();
}

class _SpecialityState extends State<Speciality> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.grey,blurRadius: 5,offset: Offset(-5, 5))
            ],
          ),
          child: Column(
            textDirection: TextDirection.rtl,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    "عيادة ${widget.specialityName}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),),
                  CircleAvatar(
                    backgroundImage: AssetImage("images/clinic_icon2.png"),
                    radius: 15,
                  )
                ],
              ),
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "د. ${widget.doctorName}",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey
                  ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
