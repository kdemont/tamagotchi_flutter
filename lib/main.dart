import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'gen/strings.g.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LocaleSettings.useDeviceLocale(); // add this line

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(TranslationProvider(child: MyApp({}))); // Wrap your app with TranslationProvider
}
