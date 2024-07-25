import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:proclinic_document_scanner/providers/visit_details.dart';
import 'package:proclinic_document_scanner/providers/visits_provider.dart';
import 'package:proclinic_document_scanner/routes/visit_details_page/visit_details_page.dart';
import 'package:provider/provider.dart';

class TodayPatients extends StatefulWidget {
  const TodayPatients({super.key});

  @override
  State<TodayPatients> createState() => _TodayPatientsState();
}

class _TodayPatientsState extends State<TodayPatients> with AfterLayoutMixin {
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    if (context.mounted) {
      await context.read<PxVisits>().fetchVisits(type: QueryType.Today);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PxVisits>(
      builder: (context, v, _) {
        if (v.visits.isEmpty) {
          return const Center(
            child: Card.outlined(
              elevation: 6,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "No Visits For Today Yet.",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: v.visits.length,
          itemBuilder: (context, index) {
            final item = v.visits[index];
            return Card.outlined(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item.ptName),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item.visitType),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Builder(
                          builder: (context) {
                            final d = DateTime.parse(item.visitDate);
                            return Text('${d.day}-${d.month}-${d.year}');
                          },
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    try {
                      await EasyLoading.show(status: "loading...");
                      if (context.mounted) {
                        await context
                            .read<PxVisitDetails>()
                            .fetchVisitDetailsById(item.id.oid)
                            .whenComplete(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VisitDetailsPage(),
                            ),
                          );
                        });
                      }
                      await EasyLoading.dismiss();
                    } catch (e) {
                      await EasyLoading.showError("Unable To Find Visit.");
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
