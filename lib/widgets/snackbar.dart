import 'package:flutter/material.dart';

SnackBar infoSnackbar(String message) {
  return SnackBar(
    content: Row(
      children: [
        Text(message),
        const SizedBox(width: 50),
        const Icon(Icons.info),
      ],
    ),
  );
}
