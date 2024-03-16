import 'package:flutter/material.dart';
import 'package:proclinic_document_scanner/constants/uuid.dart';

class PxCheckUuid extends ChangeNotifier {
  String? _uuid;
  String? get uuid => _uuid;

  UuidState _state = UuidState.isNull;
  UuidState get state => _state;

  bool checkUuid(String? value) {
    if (value == UUID) {
      _uuid = value;
      _state = UuidState.isCorrect;
      notifyListeners();
      return true;
    } else {
      _uuid = value;
      _state = UuidState.isWrong;
      notifyListeners();
      return false;
    }
  }
}

enum UuidState { isNull, isCorrect, isWrong }
