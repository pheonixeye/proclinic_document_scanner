import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:proclinic_document_scanner/providers/network_settings.dart';
import 'package:proclinic_document_scanner/routes/login_page/login_page.dart';
import 'package:provider/provider.dart';

class NetworkSettingsPage extends StatefulWidget {
  const NetworkSettingsPage({super.key});

  @override
  State<NetworkSettingsPage> createState() => _NetworkSettingsPageState();
}

class _NetworkSettingsPageState extends State<NetworkSettingsPage> {
  late final TextEditingController ipController;
  late final TextEditingController portController;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    ipController = TextEditingController();
    portController = TextEditingController();
  }

  @override
  void dispose() {
    ipController.dispose();
    portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: TextFormField(
                  controller: ipController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter IP Address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Invalid Ip Address.";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Card(
                child: TextFormField(
                  controller: portController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Port Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Invalid Port Number.";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await EasyLoading.show(status: "Loading...");
                    if (context.mounted) {
                      await context.read<PxNetworkSettings>().addDataToNetwork(
                            ip: ipController.text,
                            port: portController.text,
                          );
                    }
                    await EasyLoading.dismiss();
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
