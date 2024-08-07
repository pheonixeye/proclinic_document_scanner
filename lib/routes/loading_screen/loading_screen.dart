import 'dart:async' show FutureOr, Timer;
import 'dart:async' show Timer, FutureOr;

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:proclinic_document_scanner/providers/mongo_db.dart';
import 'package:proclinic_document_scanner/routes/login_page/login_page.dart';
import 'package:proclinic_document_scanner/routes/newtork_settings/network_settings.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with AfterLayoutMixin {
  Timer? timer;
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    try {
      await context.read<PxDatabase>().openYaMongo();
      timer = Timer(const Duration(seconds: 3), () {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        }
      });
    } catch (e) {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NetworkSettingsPage(),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[500],
      body: Container(
        alignment: Alignment.center,
        color: Colors.white70.withOpacity(0.3),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/color.png'),
              width: 300,
              height: 300,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Custom Integrated\nClinic Management Systems:\nProClinic v1.5',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text('\n \n \n by Dr.Kareem Zaher'),
            Image(
              image: AssetImage('assets/images/loading.gif'),
              width: 250,
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
