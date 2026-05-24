import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  File? profileImage;

  final ImagePicker picker = ImagePicker();

  Future pickImage() async {

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الملف الشخصي"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Center(
              child: GestureDetector(
                onTap: pickImage,
                child: Stack(
                  children: [
        
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.teal,
        
                      backgroundImage:
                      profileImage != null
                          ? FileImage(profileImage!) as ImageProvider
                          : null,
        
                      child: profileImage == null
                          ? const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      )
                          : null,
                    ),
        
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Text(
                "أحمد ملندي",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Text(
                "حساب مدير",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.grey
                ),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.mail,size: 18,color: Colors.redAccent,),
                SizedBox(width: 10,),
                Text(
                    "ahmdmlndy47@gmail.com",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent
                    ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.phone,size: 18,color: Colors.redAccent,),
                SizedBox(width: 10,),
                Text(
                  "0940456748",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "الإعدادات",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.grey
                  ),
                ),
                SizedBox(width: 10,),
                Icon(Icons.settings,color: Colors.grey,size: 22,),
              ],
            ),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: (){},
                  child: Text(
                    "تغيير كلمة المرور",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent,
                    ),
                  ),
              ),
            ),
            SizedBox(height: 10,),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: (){},
                child: Text(
                  "حول التطبيق",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text("هل أنت متأكد من تسجيل الخروج؟"),
                          actionsAlignment: MainAxisAlignment.spaceBetween,
                          actions: [
                            TextButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "إلغاء",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400
                                  ),
                                )
                            ),
                            TextButton(
                                onPressed: (){
                                  Navigator.of(context).pushNamedAndRemoveUntil("logOrSignPage", (route)=>false);
                                },
                                child: Text(
                                  "تأكيد",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w400
                                  ),
                                )
                            ),
                          ],
                        );
                      }
                      );
                },
                child: Text(
                  "تسجيل الخروج",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
