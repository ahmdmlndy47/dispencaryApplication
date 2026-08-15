import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetChecker extends StatefulWidget {
  final Widget child;

  // تابع يتم تنفيذه فقط عندما يصبح الإنترنت متاحًا
  final VoidCallback? onInternetAvailable;

  const InternetChecker({
    super.key,
    required this.child,
    this.onInternetAvailable,
  });

  @override
  State<InternetChecker> createState() => _InternetCheckerState();
}

class _InternetCheckerState extends State<InternetChecker> {

  bool hasInternet = false;

  StreamSubscription<List<ConnectivityResult>>? subscription;

  Timer? internetTimer;

  bool isChecking = false;

  @override
  void initState() {
    super.initState();

    checkInternet();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((results) {
      checkInternet();
    });

    internetTimer = Timer.periodic(
      const Duration(seconds: 3),
          (_) {
        checkInternet();
      },
    );
  }

  // فحص الإنترنت الحقيقي
  Future<bool> hasRealInternet() async {
    try {
      final client = HttpClient();

      final request = await client
          .getUrl(
        Uri.parse(
          'https://www.google.com/generate_204',
        ),
      )
          .timeout(
        const Duration(seconds: 5),
      );

      final response = await request.close().timeout(
        const Duration(seconds: 5),
      );

      client.close();

      return response.statusCode == 204 ||
          response.statusCode == 200;

    } catch (e) {
      return false;
    }
  }

  Future<void> checkInternet() async {
    if (isChecking) return;

    isChecking = true;

    bool internetAvailable = false;

    try {
      final connectivity =
      await Connectivity().checkConnectivity();

      if (!connectivity.contains(ConnectivityResult.none)) {
        internetAvailable = await hasRealInternet();
      }

    } catch (e) {
      internetAvailable = false;
    }

    if (!mounted) {
      isChecking = false;
      return;
    }

    final oldValue = hasInternet;

    setState(() {
      hasInternet = internetAvailable;
    });

    isChecking = false;

    if (!oldValue && internetAvailable) {
      widget.onInternetAvailable?.call();
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    internetTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        if (!hasInternet)
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Card(
                    margin: const EdgeInsets.all(30),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          const Icon(
                            Icons.wifi_off,
                            size: 70,
                            color: Colors.red,
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "لا يوجد اتصال بالإنترنت",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            "يرجى الاتصال بالإنترنت حتى تتمكن من استخدام التطبيق",
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton.icon(
                            onPressed: checkInternet,
                            icon: const Icon(Icons.refresh),
                            label: const Text("إعادة المحاولة"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}