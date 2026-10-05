import 'package:easy_localization/easy_localization.dart';
import 'package:easygold_app_v3/my_app.dart';
import 'package:flutter/material.dart';
import 'core/DI/service_locator.dart';

void main() async {
  await configureDependencies();
  runApp(EasyLocalization(
    supportedLocales: [
      Locale("lo", "LA"),
      Locale("en", "US"),
      Locale("zh", "CN"),
      Locale("vi", "VN"),
      Locale("ko", "KR")
    ], path: 'assets/translations',
    child: const MyApp(),
  ));
}

