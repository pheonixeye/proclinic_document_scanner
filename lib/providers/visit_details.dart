import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:proclinic_document_scanner/errors/visit_not_found.dart';
import 'package:proclinic_document_scanner/models/visit_data/visit_data.dart';
import 'package:proclinic_document_scanner/providers/mongo_db.dart';

class PxVisitDetails extends ChangeNotifier {
  VisitData? _details;
  VisitData? get details => _details;

  final db = PxDatabase();

  Future<void> fetchVisitDetailsById(String id) async {
    try {
      final result = await PxDatabase.visitData
          .findOne(where.eq("visitid", ObjectId.fromHexString(id)));
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

  Future<String> addFileToGrid(Stream<List<int>> input) async {
    final result = PxDatabase.gridFS.createFile(input, "test.pdf");
    final file = await result.save();
    return file.toString();
  }

  // Future<void> updateVisitDetails({
  //   required String attribute,
  //   required String value,
  // }) async {
  //   final result;
  // }
}
