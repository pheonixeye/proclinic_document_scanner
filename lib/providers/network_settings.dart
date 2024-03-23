import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proclinic_document_scanner/errors/connection_settings.dart';

class PxNetworkSettings extends ChangeNotifier {
  final Box storage = Hive.box('network');

  PxNetworkSettings() {
    getSettings();
  }

  String? _ip;
  String? get ip => _ip;

  String? _port;
  String? get port => _port;

  Future<void> addDataToNetwork({
    required String ip,
    required String port,
  }) async {
    await storage.put('ip', ip);
    await storage.put('port', port);
  }

  Future<void> resetNetwork() async {
    await storage.delete('ip');
    await storage.delete('port');
  }

  Future<void> getSettings() async {
    try {
      if (await Hive.boxExists("network")) {
        _ip = await storage.get('ip');
        _port = await storage.get('port');
      }
      notifyListeners();
      // print(_ip);
      // print(_port);
    } catch (e) {
      throw ConnectionSettingsException('Wrong Ip Address or Port Format.');
    }
  }
}

class ConnectionSettings {
  final String ip;
  final String port;

  ConnectionSettings({
    required this.ip,
    required this.port,
  });
}
