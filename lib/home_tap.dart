import 'package:dispensary/countries.dart';
import 'package:flutter/material.dart';
class HomeTap extends StatefulWidget {
  const HomeTap({super.key});

  @override
  State<HomeTap> createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings){
        return MaterialPageRoute(builder: (context) => Countries());
      },
    );
  }
}
