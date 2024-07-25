import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:proclinic_document_scanner/providers/visit_details.dart';
import 'package:proclinic_document_scanner/providers/visits_provider.dart';
import 'package:proclinic_document_scanner/routes/visit_details_page/visit_details_page.dart';
import 'package:provider/provider.dart';

class FindPatients extends StatefulWidget {
  const FindPatients({super.key});

  @override
  State<FindPatients> createState() => _FindPatientsState();
}

class _FindPatientsState extends State<FindPatients> {
  late final TextEditingController _searchController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PxVisits>(
      builder: (context, v, _) {
        return Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _searchController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kindly Enter Search Parameter.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Search by Name / Phone Number",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      heroTag: 'src-btn',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await EasyLoading.show(status: "loading...");
                          await v.fetchVisits(
                            type: QueryType.Search,
                            query: _searchController.text,
                          );
                          await EasyLoading.dismiss();
                        }
                      },
                      child: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (v.visits.isEmpty) {
                      return const Center(
                        child: Card.outlined(
                          elevation: 6,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "No Visits Matching Search Parameters.",
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
                                        final d =
                                            DateTime.parse(item.visitDate);
                                        return Text(
                                            '${d.day}-${d.month}-${d.year}');
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
                                          builder: (context) =>
                                              const VisitDetailsPage(),
                                        ),
                                      );
                                    });
                                  }
                                  await EasyLoading.dismiss();
                                } catch (e) {
                                  await EasyLoading.showError(
                                      "Unable To Find Visit.");
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
