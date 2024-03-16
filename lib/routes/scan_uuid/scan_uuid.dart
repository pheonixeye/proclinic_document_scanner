import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:proclinic_document_scanner/providers/check_uuid.dart';
import 'package:provider/provider.dart';

class ScanUUIDPage extends StatefulWidget {
  const ScanUUIDPage({super.key});

  @override
  State<ScanUUIDPage> createState() => _ScanUUIDPageState();
}

class _ScanUUIDPageState extends State<ScanUUIDPage> {
  late final MobileScannerController controller;

  @override
  void initState() {
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      formats: [
        BarcodeFormat.qrCode,
      ],
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect App'),
      ),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Center(
          child: Consumer<PxCheckUuid>(
            builder: (context, u, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: MobileScanner(
                      controller: controller,
                      onDetect: (capture) {
                        try {
                          u.checkUuid(capture.barcodes[0].rawValue);
                          controller.stop().whenComplete(() {
                            controller.dispose();
                          });
                          Navigator.pop(context);
                        } catch (e) {
                          EasyLoading.showError("Serial Number Check Failed.");
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  switch (u.state) {
                    UuidState.isNull =>
                      const Icon(Icons.info, color: Colors.yellow),
                    UuidState.isCorrect =>
                      const Icon(Icons.check, color: Colors.green),
                    UuidState.isWrong =>
                      const Icon(Icons.close, color: Colors.red),
                  },
                  const SizedBox(
                    height: 100,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.dispose();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                    label: const Text("back"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
