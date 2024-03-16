import 'dart:core';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:proclinic_document_scanner/errors/connection_settings.dart';

class PxNetworkSettings extends ChangeNotifier {
  static Box? storage;

  String? _ip;
  String? get ip => _ip;

  String? _port;
  String? get port => _port;

  static Future<void> init() async {
    Hive.init('assets\\network.hive');
    storage = await Hive.openBox('network');
  }

  Future<void> adddatatonetwork(
      {required String ip, required String port}) async {
    await storage?.put('ip', ip);
    await storage?.put('port', port);
  }

  Future<void> resetnetwork() async {
    await storage?.delete('ip');
    await storage?.delete('port');
  }

  Future<ConnectionSettings> getSettings() async {
    try {
      _ip = await storage?.get('ip');
      _port = await storage?.get('port');
      notifyListeners();
      return ConnectionSettings(ip: ip!, port: port!);
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
