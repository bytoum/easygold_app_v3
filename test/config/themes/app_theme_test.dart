import 'package:easygold_app_v3/config/themes/app_bar_theme.dart';
import 'package:easygold_app_v3/config/themes/app_theme.dart';
import 'package:easygold_app_v3/core/constants/app_colors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('buildTheme', () {
    for (final brightness in Brightness.values) {
      test('uses the $brightness color scheme and typography', () {
        final theme = buildTheme(brightness);
        final colors = ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          brightness: brightness,
        );

        expect(theme.useMaterial3, isTrue);
        expect(theme.colorScheme.brightness, brightness);
        expect(theme.colorScheme.primary, colors.primary);
        expect(theme.textTheme.bodyLarge?.fontFamily, 'NotoSansLao');
        expect(theme.textTheme.bodyLarge?.fontFamilyFallback, [
          'Roboto',
          'NotoSansLao',
        ]);
        expect(theme.textTheme.bodyLarge?.fontSize, 16);
        expect(theme.textTheme.bodyMedium?.fontSize, 14);
        expect(theme.textTheme.bodySmall?.fontSize, 12);
      });
    }
  });

  group('appBarTheme', () {
    for (final brightness in Brightness.values) {
      test('uses the $brightness primary colors and centered title', () {
        final theme = appBarTheme(brightness);
        final colors = ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          primary: AppColors.primaryColor,
          brightness: brightness,
        );

        expect(theme.backgroundColor, colors.primary);
        expect(theme.foregroundColor, colors.onPrimary);
        expect(theme.elevation, 0);
        expect(theme.centerTitle, isTrue);
        expect(theme.titleTextStyle?.fontSize, 18);
        expect(theme.titleTextStyle?.fontWeight, FontWeight.bold);
      });
    }
  });
}
