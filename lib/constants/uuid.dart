import 'package:pretty_qr_code/pretty_qr_code.dart';

// ignore: constant_identifier_names
const String UUID = '4C4C4544-0039-4610-804A-B9C04F445331';

final qrCode = QrCode.fromData(
  data: UUID,
  errorCorrectLevel: QrErrorCorrectLevel.H,
);
