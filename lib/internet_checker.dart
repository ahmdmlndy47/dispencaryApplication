import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetChecker extends StatefulWidget {
  final Widget child;

  const InternetChecker({
    super.key,
    required this.child,
  });

  @override
  State<InternetChecker> createState() => _InternetCheckerState();
}

class _InternetCheckerState extends State<InternetChecker> {
  StreamSubscription<List<ConnectivityResult>>? subscription;

  bool hasInternet = true;

  @override
  void initState() {
    super.initState();

    checkInternet();

    subscription = Connectivity().onConnectivityChanged.listen((results) {
      checkInternet();
    });
  }

  Future<void> checkInternet() async {
    final results = await Connectivity().checkConnectivity();

    setState(() {
      hasInternet = !results.contains(ConnectivityResult.none);
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!hasInternet) {
      return const Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 80,
                    color: Colors.red,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "لا يوجد اتصال بالإنترنت",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.red
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "يرجى الاتصال بالإنترنت لاستخدام التطبيق",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.black
                    ),
                  ),
                ],
              ),
            ),
        ),

      );
    }

    return widget.child;
  }
}