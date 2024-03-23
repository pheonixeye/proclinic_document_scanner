import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:proclinic_document_scanner/providers/check_uuid.dart';
import 'package:proclinic_document_scanner/providers/mongo_db.dart';
import 'package:proclinic_document_scanner/providers/network_settings.dart';
import 'package:proclinic_document_scanner/routes/newtork_settings/network_settings.dart';
import 'package:proclinic_document_scanner/routes/scan_uuid/scan_uuid.dart';
import 'package:proclinic_document_scanner/routes/scan_visit_page/scan_visit_page.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
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
                    ),
                    const SizedBox(
                      width: 30,
                    ),
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
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Consumer<PxCheckUuid>(
                        builder: (context, u, _) {
                          return ElevatedButton.icon(
                            icon: const Icon(Icons.settings),
                            label: const Text("Network Settings"),
                            onPressed: () async {
                              switch (u.state) {
                                case UuidState.isNull:
                                  await EasyLoading.showInfo(
                                      'Connect Your App First.');
                                case UuidState.isWrong:
                                  await EasyLoading.showError(
                                      'Wrong Application Serial Number. Contact Adminstrator.');
                                case UuidState.isCorrect:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NetworkSettingsPage(),
                                    ),
                                  );
                              }
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Consumer<PxNetworkSettings>(
                      builder: (context, n, _) {
                        if (n.ip == null) {
                          return const Icon(
                            Icons.info,
                            color: Colors.yellow,
                          );
                        } else {
                          return const Icon(
                            Icons.check,
                            color: Colors.green,
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Consumer<PxCheckUuid>(
                        builder: (context, u, _) {
                          return ElevatedButton.icon(
                            icon: const Icon(Icons.scanner),
                            label: const Text("Connect Database"),
                            onPressed: () async {
                              switch (u.state) {
                                case UuidState.isNull:
                                  await EasyLoading.showInfo(
                                      'Connect Your App First.');
                                case UuidState.isWrong:
                                  await EasyLoading.showError(
                                      'Wrong Application Serial Number. Contact Adminstrator.');
                                case UuidState.isCorrect:
                                  final db = context.read<PxDatabase>();
                                  try {
                                    await EasyLoading.show(
                                        status: "Connecting...");
                                    await db.openYaMongo();
                                    await EasyLoading.showInfo(
                                        db.state.toString());
                                  } catch (e) {
                                    await EasyLoading.showInfo(
                                        db.state.toString());
                                  }
                              }
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Consumer<PxDatabase>(
                      builder: (context, d, _) {
                        switch (d.state) {
                          case MongoState.connected:
                            return const Icon(
                              Icons.check,
                              color: Colors.green,
                            );
                          case MongoState.notConnected:
                            return const Icon(
                              Icons.close,
                              color: Colors.red,
                            );
                        }
                      },
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child:
                          Consumer3<PxCheckUuid, PxNetworkSettings, PxDatabase>(
                        builder: (context, u, n, d, _) {
                          return ElevatedButton.icon(
                            onPressed: () async {
                              if (u.state == UuidState.isCorrect &&
                                  n.ip != null &&
                                  d.state == MongoState.connected) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ScanVisitPage(),
                                  ),
                                );
                              } else {
                                if (u.state != UuidState.isCorrect) {
                                  await EasyLoading.showError(
                                      "Missing Application Connection.");
                                }
                                if (n.ip == null) {
                                  await EasyLoading.showError(
                                      "Missing Network Configuration.");
                                }
                                if (d.state != MongoState.connected) {
                                  await EasyLoading.showError(
                                      "Missing Database Connection.");
                                }
                              }
                            },
                            icon: const Icon(Icons.camera),
                            label: const Text('Scan Document'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
