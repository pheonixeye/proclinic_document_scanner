import 'dart:async';

import 'package:flutter/foundation.dart';
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

class _ScanUUIDPageState extends State<ScanUUIDPage>
    with WidgetsBindingObserver {
  late final MobileScannerController controller;
  Barcode? _barcode;
  StreamSubscription<Object?>? _subscription;

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      _barcode = barcodes.barcodes.firstOrNull;
      if (_barcode != null) {
        try {
          if (kDebugMode) {
            print("QR Code Found");
          }
          context.read<PxCheckUuid>().checkUuid(_barcode!.rawValue);
          EasyLoading.showSuccess("Serial Number Check Complete.");
          Navigator.pop(context);
        } catch (e) {
          EasyLoading.showError("Serial Number Check Failed.");
        }
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      formats: [BarcodeFormat.qrCode],
      detectionTimeoutMs: 1000,
      returnImage: false,
    );

    _subscription = controller.barcodes.listen(_handleBarcode);

    unawaited(controller.start());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
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
