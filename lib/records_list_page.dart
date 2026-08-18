import 'package:flutter/material.dart';
//صفحة البحث عن  سجل
class RecordsListPage extends StatefulWidget {
  const RecordsListPage({super.key});

  @override
  State<RecordsListPage> createState() => _RecordsListPageState();
}

class _RecordsListPageState extends State<RecordsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //عنوان الصفحة
      appBar: AppBar(
        title: Text("صفحة السجلات الطبية"),
        centerTitle: true,
      ),
    );
  }
}
