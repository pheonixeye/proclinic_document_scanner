import 'package:proclinic_document_scanner/providers/check_uuid.dart';
import 'package:proclinic_document_scanner/providers/network_settings.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider;
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (context) => PxCheckUuid()),
  ChangeNotifierProvider(create: (context) => PxNetworkSettings()),
];
