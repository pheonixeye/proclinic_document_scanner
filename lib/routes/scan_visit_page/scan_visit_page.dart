import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:proclinic_document_scanner/providers/visit_details.dart';
import 'package:proclinic_document_scanner/routes/visit_details_page/visit_details_page.dart';
import 'package:proclinic_document_scanner/widgets/snackbar.dart';
import 'package:provider/provider.dart';

class ScanVisitPage extends StatefulWidget {
  const ScanVisitPage({super.key});

  @override
  State<ScanVisitPage> createState() => _ScanVisitPageState();
}

class _ScanVisitPageState extends State<ScanVisitPage>
    with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    formats: [BarcodeFormat.qrCode],
    detectionTimeoutMs: 1000,
    returnImage: false,
  );

  Barcode? _barcode;
  StreamSubscription<Object?>? _subscription;

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (mounted) {
      _barcode = barcodes.barcodes.firstOrNull;
      if (_barcode != null) {
        if (kDebugMode) {
          print("QR Code Capture Complete.");
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(infoSnackbar("QR Code Capture Complete."));
        controller.stop();
        try {
          if (context.mounted) {
            await context
                .read<PxVisitDetails>()
                .fetchVisitDetailsById(_barcode!.rawValue!);
          }
          await EasyLoading.showSuccess("Visit Found.");
        } catch (e) {
          await EasyLoading.showError("Visit Not Found.");
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

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
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Visit'),
      ),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<PxVisitDetails>(
                builder: (context, v, _) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: ValueListenableBuilder(
                          valueListenable: controller,
                          builder: (context, state, _) {
                            if (!state.isInitialized || !state.isRunning) {
                              return IconButton(
                                color: Colors.white,
                                icon: const Icon(Icons.play_arrow),
                                iconSize: 32.0,
                                onPressed: () async {
                                  await controller.start();
                                },
                              );
                            }
                            return Stack(
                              children: [
                                MobileScanner(
                                  controller: controller,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: FloatingActionButton.small(
                                    heroTag: 'stop-controller',
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Icon(Icons.stop),
                                    onPressed: () async {
                                      await controller.stop();
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      if (v.details != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const VisitDetailsPage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.desktop_mac),
                            label: const Text("Visit Details"),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            v.nullifyVisit();
                            controller.start();
                          },
                          icon: const Icon(Icons.scanner),
                          label: const Text("Scan New Visit"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios),
                          label: const Text("back"),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
