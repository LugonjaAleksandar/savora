import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:savora/app.dart';
import 'package:savora/core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // Loads date symbols for every locale, including sr_Latn used for Serbian dates.
  await initializeDateFormatting();
  await configureDependencies();
  runApp(const SavoraApp());
}
