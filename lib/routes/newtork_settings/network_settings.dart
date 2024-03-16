import 'package:flutter/material.dart';

class NetworkSettingsPage extends StatefulWidget {
  const NetworkSettingsPage({super.key});

  @override
  State<NetworkSettingsPage> createState() => _NetworkSettingsPageState();
}

class _NetworkSettingsPageState extends State<NetworkSettingsPage> {
  TextEditingController ipController = TextEditingController();
  TextEditingController portController = TextEditingController();

  final formKey = GlobalKey<FormState>();

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
                  if (formKey.currentState!.validate()) {}
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
