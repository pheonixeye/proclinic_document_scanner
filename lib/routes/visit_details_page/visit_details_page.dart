import 'package:flutter/material.dart';
import 'package:proclinic_document_scanner/models/visit_data/visit_data.dart';
import 'package:proclinic_document_scanner/providers/image_handler.dart';
import 'package:proclinic_document_scanner/providers/visit_details.dart';
import 'package:proclinic_document_scanner/routes/visit_details_page/picked_image_page.dart';
import 'package:provider/provider.dart';

class VisitDetailsPage extends StatefulWidget {
  const VisitDetailsPage({super.key});

  @override
  State<VisitDetailsPage> createState() => _VisitDetailsPageState();
}

class _VisitDetailsPageState extends State<VisitDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visit Details"),
      ),
      body: Consumer<PxVisitDetails>(
        builder: (context, v, _) {
          while (v.details == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Spacer(),
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
                    const Spacer(),
                    ...VisitData.paperData.entries.map((e) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await context
                                      .read<PxImageHandler>()
                                      .pickImage()
                                      .whenComplete(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PickedImagePage(
                                          data: e,
                                        ),
                                      ),
                                    );
                                  });
                                },
                                child: Text('Add "${e.key}"'),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              label: const Text("Back"),
                              icon: const Icon(Icons.arrow_back_ios),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
