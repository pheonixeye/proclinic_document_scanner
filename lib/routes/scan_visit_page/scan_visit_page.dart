import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:proclinic_document_scanner/providers/visit_details.dart';
import 'package:proclinic_document_scanner/routes/visit_details_page/visit_details_page.dart';
import 'package:provider/provider.dart';

class ScanVisitPage extends StatefulWidget {
  const ScanVisitPage({super.key});

  @override
  State<ScanVisitPage> createState() => _ScanVisitPageState();
}

class _ScanVisitPageState extends State<ScanVisitPage> {
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
                        child: MobileScanner(
                          controller: controller,
                          onDetect: (capture) async {
                            final bc = capture.barcodes[0].rawValue;
                            print(bc);
                            try {
                              await v.fetchVisitDetailsById(
                                  capture.barcodes[0].rawValue!);
                              controller.stop();
                              EasyLoading.showSuccess("Visit Found.");
                            } catch (e) {
                              EasyLoading.showError("Visit Not Found.");
                            }
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
                            controller.dispose();
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
