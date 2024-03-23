library mymongo;

import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:proclinic_document_scanner/errors/mongo_connection.dart';
// import 'package:proclinic_document_scanner/errors/mongo_connection.dart';
import 'package:proclinic_document_scanner/providers/network_settings.dart';

class PxDatabase extends ChangeNotifier {
  static final PxNetworkSettings settings = PxNetworkSettings();

  MongoState _state = MongoState.notConnected;
  MongoState get state => _state;

  static final Db mongo = Db(
      'mongodb://${settings.storage.get('ip')}:${settings.storage.get('port')}/proclinic');

  static final DbCollection allPatients = mongo.collection('patients');
  static final DbCollection visitData = mongo.collection('visitdata');
  static final DbCollection allDoctors = mongo.collection('allDoctors');
  static final DbCollection appOrganizer = mongo.collection('apporganizer');
  static final GridFS gridFS = GridFS(mongo);

  Future<void> openYaMongo() async {
    await mongo.open().catchError((e) {
      throw MongoDbConnectionException(e.toString());
    }).whenComplete(() {
      _state = MongoState.connected;
      notifyListeners();
      if (kDebugMode) {
        print('shobeek lobeek El _mongo been eidek, totlob eih??');
      }
    });
  }
}

enum MongoState {
  connected,
  notConnected,
}
