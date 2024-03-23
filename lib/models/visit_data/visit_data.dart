// ignore_for_file: constant_identifier_names

import 'package:mongo_dart/mongo_dart.dart';
import 'package:proclinic_document_scanner/models/drug/drug_model.dart';

class VisitData {
  final int docid;
  final ObjectId visitid;
  final String ptname;
  final String phone;
  final String visittype;
  final String visitdate;
  final Map<String, dynamic> data;
  final List<String> labs;
  final List<String> rads;
  final List<Drug> drugs;
  final List<String> sheetpapers;
  final List<String> labpapers;
  final List<String> radpapers;
  final List<String> drugpapers;
  final List<String> commentspapers;

  VisitData({
    required this.docid,
    required this.visitid,
    required this.ptname,
    required this.phone,
    required this.visittype,
    required this.visitdate,
    required this.data,
    required this.labs,
    required this.rads,
    required this.drugs,
    required this.sheetpapers,
    required this.labpapers,
    required this.radpapers,
    required this.drugpapers,
    required this.commentspapers,
  });

  factory VisitData.fromJson(dynamic json) {
    return VisitData(
      docid: json[SxVD.DOCID],
      visitid: json[SxVD.VISITID],
      ptname: json[SxVD.PTNAME],
      phone: json[SxVD.PHONE],
      visittype: json[SxVD.VISITTYPE],
      visitdate: json[SxVD.VISITDATE],
      data: json[SxVD.DATA],
      labs: stringifyList(json[SxVD.LABS]),
      rads: stringifyList(json[SxVD.RADS]),
      drugs: (json[SxVD.DRUGS] as List<dynamic>)
          .map((e) => Drug.fromJson(e))
          .toList(),
      sheetpapers: stringifyList(json[SxVD.SHEETSPAPERS]),
      labpapers: stringifyList(json[SxVD.LABSPAPERS]),
      radpapers: stringifyList(json[SxVD.RADSPAPERS]),
      drugpapers: stringifyList(json[SxVD.DRUGPAPERS]),
      commentspapers: stringifyList(json[SxVD.COMMENTSPAPERS]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      SxVD.DOCID: docid,
      SxVD.VISITID: visitid,
      SxVD.PTNAME: ptname,
      SxVD.PHONE: phone,
      SxVD.VISITTYPE: visittype,
      SxVD.VISITDATE: visitdate,
      SxVD.DATA: data,
      SxVD.DRUGS: drugs.map((e) => e.toJson()).toList(),
      SxVD.LABS: labs,
      SxVD.RADS: rads,
      SxVD.SHEETSPAPERS: sheetpapers,
      SxVD.LABSPAPERS: labpapers,
      SxVD.RADSPAPERS: radpapers,
      SxVD.DRUGPAPERS: drugpapers,
      SxVD.COMMENTSPAPERS: commentspapers,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  static List<String> stringifyList(List<dynamic> ld) {
    return ld.map((dynamic e) => e.toString()).toList();
  }

  static const Map<String, String> paperData = {
    "Sheet Documents": SxVD.SHEETSPAPERS,
    "Lab Results": SxVD.LABSPAPERS,
    "Radiology Results": SxVD.RADSPAPERS,
    "Perscriptions": SxVD.DRUGPAPERS,
    "Miscellaneous": SxVD.COMMENTSPAPERS,
  };
}

class SxVD {
  static const String DOCID = "docid";
  static const String VISITID = "visitid";
  static const String PTNAME = 'ptname';
  static const String PHONE = "phone";
  static const String VISITTYPE = "visittype";
  static const String VISITDATE = "visitdate";
  static const String DATA = "medicaldata";
  static const String DRUGS = "drugs";
  static const String LABS = "labs";
  static const String RADS = "rads";
  static const String SHEETSPAPERS = "sheetpapers";
  static const String LABSPAPERS = "labpapers";
  static const String RADSPAPERS = "radpapers";
  static const String DRUGPAPERS = "drugpapers";
  static const String COMMENTSPAPERS = "commentpapers";
}
