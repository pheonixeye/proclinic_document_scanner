// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:proclinic_document_scanner/providers/mongo_db.dart';
import 'package:proclinic_models/proclinic_models.dart';

class PxVisits extends ChangeNotifier {
  PxVisits({required this.docid});
  final int docid;

  List<Visit> _visits = [];

  List<Visit> get visits => _visits;

  DateTime _date = DateTime.now();
  DateTime get date => _date;

  DateTime _secondDate = DateTime.now();
  DateTime get secondDate => _secondDate;

  final DateTime _today = DateTime.now();
  DateTime get today => DateTime(_today.year, _today.month, _today.day);

  bool _forRange = false;
  bool get forRange => _forRange;

  void setForRange(bool val) {
    _forRange = val;
    notifyListeners();
  }

  void setDate({int? day, int? month, int? year}) {
    _date = DateTime(
      year ?? _date.year,
      month ?? _date.month,
      day ?? _date.day,
    );
    notifyListeners();
  }

  void setSecondDate({int? day, int? month, int? year}) {
    _secondDate = DateTime(
      year ?? _secondDate.year,
      month ?? _secondDate.month,
      day ?? _secondDate.day,
    );
    notifyListeners();
  }

  Future<void> fetchVisits({
    required QueryType type,
    String? query,
  }) async {
    switch (type) {
      case QueryType.Today:
        final result = await PxDatabase.visits
            .find(where.eq(SxVisit.DOCID, docid).eq(
                  SxVisit.VISITDATE,
                  today.toIso8601String(),
                ))
            .toList();

        _visits = Visit.visitList(result);
        notifyListeners();

      case QueryType.Date:
        final result = await PxDatabase.visits
            .find(where.eq(SxVisit.DOCID, docid).eq(
                  SxVisit.VISITDATE,
                  date.toIso8601String(),
                ))
            .toList();

        _visits = Visit.visitList(result);
        notifyListeners();

      case QueryType.Range:
        //todo: FIX QUERY
        final result = await PxDatabase.visits
            .find(
              where
                  .eq(SxVisit.DOCID, docid)
                  .gte(SxVisit.VISITDATE, date.toIso8601String())
                  .lte(SxVisit.VISITDATE, secondDate.toIso8601String())
                  .sortBy(
                    SxVisit.VISITDATE,
                    descending: true,
                  ),
            )
            .toList();
        _visits = Visit.visitList(result);
        notifyListeners();

      case QueryType.Search:
        final result = await PxDatabase.visits
            .find(where.eq(SxVisit.DOCID, docid).and(where
                .match(SxVisit.PTNAME, query ?? '')
                .or(where.match(SxVisit.PHONE, query ?? ''))
                .sortBy(
                  SxVisit.VISITDATE,
                  descending: false,
                )))
            .toList();
        _visits = Visit.visitList(result);
        notifyListeners();

      case QueryType.All:
        final result = await PxDatabase.visits
            .find(where
                .eq(SxVisit.DOCID, docid)
                .sortBy(
                  SxVisit.VISITDATE,
                  descending: true,
                )
                .limit(25))
            .toList();

        _visits = Visit.visitList(result);
        notifyListeners();
    }
  }

  Future<void> updateVisitDetails(
    ObjectId id,
    String attribute,
    dynamic value,
  ) async {
    await PxDatabase.visits.updateOne(
      where.eq("_id", id),
      {
        r'$set': {
          attribute: value,
        },
      },
    );
    await fetchVisits(type: QueryType.Today);
  }
}

enum QueryType {
  Today,
  Date,
  Range,
  Search,
  All,
}
