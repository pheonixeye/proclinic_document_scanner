import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:proclinic_document_scanner/localization/app_localizations.dart';
import 'package:proclinic_document_scanner/providers/_main.dart';
import 'package:proclinic_document_scanner/routes/loading_screen/loading_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      builder: (context, _) {
        return MaterialApp(
          title: 'ProClinic Document Scanner',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            useMaterial3: true,
            cardTheme: CardTheme(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          builder: EasyLoading.init(),
          home: const LoadingScreen(),
          locale: const Locale('en'),
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        );
      },
    );
  }
}
