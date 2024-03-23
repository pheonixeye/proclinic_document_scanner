import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:proclinic_document_scanner/providers/image_handler.dart';
import 'package:proclinic_document_scanner/providers/visit_details.dart';
import 'package:provider/provider.dart';

class PickedImagePage extends StatefulWidget {
  const PickedImagePage({super.key, required this.data});
  final MapEntry<String, String> data;

  @override
  State<PickedImagePage> createState() => _PickedImagePageState();
}

class _PickedImagePageState extends State<PickedImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.key),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Consumer2<PxVisitDetails, PxImageHandler>(
            builder: (context, v, h, _) {
              return Column(
                children: [
                  const Divider(),
                  Text(
                    v.details!.ptname,
                    textAlign: TextAlign.center,
                  ),
                  Builder(
                    builder: (context) {
                      final d = DateTime.parse(v.details!.visitdate);
                      return Text(
                        "${d.day}-${d.month}-${d.year}",
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  Text(
                    v.details!.visittype,
                    textAlign: TextAlign.center,
                  ),
                  const Divider(),
                  Expanded(
                    child: FutureBuilder<Uint8List?>(
                      future: h.imgFile?.readAsBytes(),
                      builder: (context, snapshot) {
                        while (!snapshot.hasData || snapshot.data == null) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        return Image.memory(
                          snapshot.data!,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        //todo: generate pdf file
                        await EasyLoading.show(status: "Generating Pdf File.");
                        final d = DateTime.parse(v.details!.visitdate);
                        await h.generatePdfFile(
                            "${v.details!.ptname}-${d.day}${d.month}${d.year}-${widget.data.value}");

                        //todo: update visit details with file id in corresponding lists
                        await h.updateVisitEntry(
                          v.details!.visitid,
                          widget.data.value,
                        );
                        await EasyLoading.showSuccess(
                            "Generating Pdf File Complete.");
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: const Text("Save"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                      label: const Text("Back"),
                    ),
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
