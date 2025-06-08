import 'package:proclinic_document_scanner/providers/doctor_px.dart';
import 'package:proclinic_document_scanner/providers/image_handler.dart';
import 'package:proclinic_document_scanner/providers/mongo_db.dart';
import 'package:proclinic_document_scanner/providers/network_settings.dart';
import 'package:proclinic_document_scanner/providers/visit_details.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider;
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (context) => PxNetworkSettings()),
  ChangeNotifierProvider(create: (context) => PxDatabase()),
  ChangeNotifierProvider(create: (context) => PxDoctor()),
  ChangeNotifierProvider(create: (context) => PxVisitDetails()),
  ChangeNotifierProvider(create: (context) => PxImageHandler()),
];
