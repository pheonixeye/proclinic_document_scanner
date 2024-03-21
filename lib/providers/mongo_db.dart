library mymongo;

import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:proclinic_document_scanner/errors/mongo_connection.dart';
import 'package:proclinic_document_scanner/providers/network_settings.dart';

class PxDatabase extends ChangeNotifier {
  PxDatabase() {
    settings = PxNetworkSettings();
  }

  late final PxNetworkSettings settings;

  MongoState _state = MongoState.notConnected;
  MongoState get state => _state;

  // late Db _mongo;
  Db get mongo => Db(
      'mongodb://${settings.storage.get('ip')}:${settings.storage.get('port')}/proclinic');

  // Db _mongo() {
  //   try {
  //     return Db(
  //         'mongodb://${settings.storage.get('ip')}:${settings.storage.get('port')}/proclinic');
  //     // print(_mongo.masterConnection.serverConfig.host);
  //   } catch (e) {
  //     throw MongoDbConnectionException(e.toString());
  //   }
  // }

  late final DbCollection allPatients = mongo.collection('patients');
  late final DbCollection visitData = mongo.collection('visitdata');
  late final DbCollection allDoctors = mongo.collection('allDoctors');
  late final DbCollection appOrganizer = mongo.collection('apporganizer');

  Future<void> openYaMongo() async {
    if (mongo.state == State.opening) {
      await mongo.close();
    }
    if (mongo.state == State.init) {
      await mongo.close();
    }
    try {
      await mongo.open();
      if (!mongo.masterConnection.connected) {
        await mongo.masterConnection.connect();
      }
      _state = MongoState.connected;
      notifyListeners();
      if (kDebugMode) {
        print('shobeek lobeek El _mongo been eidek, totlob eih??');
      }
    } catch (e) {
      throw MongoDbConnectionException(e.toString());
      // return false;
    }
    // await _checkforkeys();
  }

  // DbCollection get allPatients => Database._allPatients;
  // DbCollection get visitData => Database._visitData;
  // DbCollection get allDoctors => Database._allDoctors;
  // DbCollection get appOrganizer => Database._appOrganizer;
}

enum MongoState {
  connected,
  notConnected,
}
