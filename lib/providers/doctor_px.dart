// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:proclinic_document_scanner/providers/mongo_db.dart';
import 'package:proclinic_models/proclinic_models.dart';

class PxDoctor extends ChangeNotifier {
  PxDoctor() {
    _fetchAllDoctors();
  }
  List<Doctor>? _doctorList;
  List<Doctor>? get doctorList => _doctorList;

  Future<void> _fetchAllDoctors() async {
    final result = await PxDatabase.doctors.find().toList();
    _doctorList = result.map((e) => Doctor.fromJson(e)).toList();
    notifyListeners();
  }

  Doctor? _doctor;
  Doctor? get doctor => _doctor;

  void selectDoctor(Doctor? value) {
    _doctor = value;
    notifyListeners();
  }
}
