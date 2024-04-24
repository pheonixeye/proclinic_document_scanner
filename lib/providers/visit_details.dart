import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:proclinic_document_scanner/errors/visit_not_found.dart';
import 'package:proclinic_document_scanner/providers/mongo_db.dart';
import 'package:proclinic_models/proclinic_models.dart';

class PxVisitDetails extends ChangeNotifier {
  VisitData? _details;
  VisitData? get details => _details;

  Future<void> fetchVisitDetailsById(String visitid) async {
    try {
      final result = await PxDatabase.visitData
          .findOne(where.eq("visitid", ObjectId.fromHexString(visitid)));
      _details = VisitData.fromJson(result);
      notifyListeners();
    } catch (e) {
      throw VisitNotFoundException(e.toString());
    }
  }

  void nullifyVisit() {
    _details = null;
    notifyListeners();
  }

  // Future<String> addFileToGrid(Stream<List<int>> input) async {
  //   final result = PxDatabase.gridFS.createFile(input, "test.pdf");
  //   final file = await result.save();
  //   return file.toString();
  // }

  // Future<void> updateVisitDetails({
  //   required String attribute,
  //   required String value,
  // }) async {
  //   final result;
  // }
}
