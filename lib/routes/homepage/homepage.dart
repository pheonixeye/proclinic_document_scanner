import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:proclinic_document_scanner/providers/check_uuid.dart';
import 'package:proclinic_document_scanner/routes/newtork_settings/network_settings.dart';
import 'package:proclinic_document_scanner/routes/scan_uuid/scan_uuid.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ProClinic Scanner"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.connected_tv),
                label: const Text("Connect App"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScanUUIDPage(),
                    ),
                  );
                },
              ),
              const Spacer(),
              Consumer<PxCheckUuid>(
                builder: (context, u, _) {
                  switch (u.state) {
                    case UuidState.isNull:
                      return const Icon(Icons.info, color: Colors.yellow);
                    case UuidState.isCorrect:
                      return const Icon(Icons.check, color: Colors.green);
                    case UuidState.isWrong:
                      return const Icon(Icons.close, color: Colors.red);
                  }
                },
              ),
              const SizedBox(
                width: 30,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer<PxCheckUuid>(
                builder: (context, u, _) {
                  return ElevatedButton.icon(
                    icon: const Icon(Icons.settings),
                    label: const Text("Network Settings"),
                    onPressed: () async {
                      switch (u.state) {
                        case UuidState.isNull:
                          await EasyLoading.showInfo('Connect Your App First.');
                        case UuidState.isWrong:
                          await EasyLoading.showError(
                              'Wrong Application Serial Number. Contact Adminstrator.');
                        case UuidState.isCorrect:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NetworkSettingsPage(),
                            ),
                          );
                      }
                    },
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.scanner),
                label: const Text("Scan Document"),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}