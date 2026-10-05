import 'package:easygold_app_v3/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

AppBarTheme appBarTheme(Brightness brightness) {
  final colors = ColorScheme.fromSeed(
    seedColor: AppColors.primaryColor,
    primary: AppColors.primaryColor,
    brightness: brightness,
  );
  return AppBarTheme(
    backgroundColor: colors.primary,
    foregroundColor: colors.onPrimary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: colors.surface,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );
}
