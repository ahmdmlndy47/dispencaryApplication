import 'package:flutter/material.dart';
class MyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final void Function() onTap;
  const MyCard({super.key, required this.title, required this.subtitle, required this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 5,
      shadowColor: Colors.grey,
      child: ListTile(
        onTap: onTap,
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey),
        ),
        trailing: Text(
          trailing,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w200,
              color: Colors.red
          ),
        ),
      ),
    );
  }
}
