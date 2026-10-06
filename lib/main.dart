import 'package:easy_localization/easy_localization.dart';
import 'package:easygold_app_v3/core/services/asset_loader_service.dart';
import 'package:easygold_app_v3/my_app.dart';
import 'package:material_ui/material_ui.dart';

import 'core/DI/service_locator.dart';

void main() async {
  await configureDependencies();
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale("lo", "LA"),
        Locale("en", "US"),
        Locale("zh", "CN"),
        Locale("vi", "VN"),
        Locale("ko", "KR"),
      ],
      path: 'assets/translations',
      assetLoader: getIt<S3AssetLoaderService>(),
      child: const MyApp(),
    ),
  );
}
