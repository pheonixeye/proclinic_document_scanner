import 'package:flutter/material.dart';
import 'package:proclinic_document_scanner/providers/doctor_px.dart';
import 'package:proclinic_document_scanner/providers/visits_provider.dart';
import 'package:proclinic_document_scanner/routes/homepage/homepage.dart';
import 'package:proclinic_document_scanner/routes/newtork_settings/network_settings.dart';
import 'package:proclinic_document_scanner/widgets/central_loading.dart';
import 'package:proclinic_models/proclinic_models.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          textScaler: TextScaler.linear(2.0),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<PxDoctor>(
        builder: (context, d, _) {
          while (d.doctorList == null) {
            return const CentralLoading();
          }
          return Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          title: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Select Doctor'),
                          ),
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<Doctor>(
                                  isExpanded: true,
                                  alignment: Alignment.center,
                                  items: d.doctorList?.map((e) {
                                    return DropdownMenuItem<Doctor>(
                                      alignment: Alignment.center,
                                      value: e,
                                      child: Text(e.docnameEN),
                                    );
                                  }).toList(),
                                  value: d.doctor,
                                  validator: (value) {
                                    if (value == null) {
                                      return "Select Doctor.";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    d.selectDoctor(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ListTile(
                          title: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Password'),
                          ),
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Enter Password.",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Kindly Enter Password.';
                                    } else if (value != d.doctor?.password) {
                                      return 'Wrong Password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          width: 250,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.person),
                                  label: const Text('Login'),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate() &&
                                        context.mounted) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider(
                                            create: (context) =>
                                                PxVisits(docid: d.doctor!.id),
                                            child: const Homepage(),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 250,
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.network_check),
                                  label: const Text('Network Settings'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const NetworkSettingsPage(),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
