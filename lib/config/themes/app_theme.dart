import 'package:easygold_app_v3/config/themes/app_bar_theme.dart';
import 'package:easygold_app_v3/config/themes/app_text_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:easygold_app_v3/core/constants/app_colors.dart';

ThemeData buildTheme(Brightness brightness) {
  final colors = ColorScheme.fromSeed(
    seedColor: AppColors.primaryColor,
    brightness: brightness,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: colors,
    textTheme: appTextTheme,
    fontFamily: 'NotoSansLao',
    fontFamilyFallback: ['Roboto', 'NotoSansLao'],
    appBarTheme: appBarTheme(brightness),
  );
}
