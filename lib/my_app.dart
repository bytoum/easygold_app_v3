import 'package:easy_localization/easy_localization.dart';
import 'package:easygold_app_v3/config/routes/app_router.dart';
import 'package:easygold_app_v3/config/themes/app_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:overlay_kit/overlay_kit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlayKit(
      child: MaterialApp.router(
        routerConfig: appRouter,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        // theme: Themes.lightTheme
      ),
    );
  }
}
