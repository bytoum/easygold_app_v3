import 'package:easygold_app_v3/config/themes/app_bar_theme.dart';
import 'package:easygold_app_v3/config/themes/app_text_theme.dart';
import 'package:easygold_app_v3/config/themes/app_theme.dart';
import 'package:easygold_app_v3/core/constants/app_colors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('appTextTheme', () {
    test('defines body sizes 16/14/12 at regular weight', () {
      expect(appTextTheme.bodyLarge?.fontSize, 16);
      expect(appTextTheme.bodyMedium?.fontSize, 14);
      expect(appTextTheme.bodySmall?.fontSize, 12);
      for (final style in [
        appTextTheme.bodyLarge,
        appTextTheme.bodyMedium,
        appTextTheme.bodySmall,
      ]) {
        expect(style?.fontWeight, FontWeight.w400);
      }
    });
  });

  group('appBarTheme', () {
    for (final brightness in Brightness.values) {
      test('is flat, centered and primary-colored in $brightness', () {
        final theme = appBarTheme(brightness);
        final colors = ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          primary: AppColors.primaryColor,
          brightness: brightness,
        );

        expect(theme.backgroundColor, AppColors.primaryColor);
        expect(theme.foregroundColor, colors.onPrimary);
        expect(theme.elevation, 0);
        expect(theme.centerTitle, isTrue);
        expect(theme.titleTextStyle?.fontSize, 18);
        expect(theme.titleTextStyle?.fontWeight, FontWeight.bold);
        expect(theme.titleTextStyle?.color, colors.surface);
      });
    }
  });

  group('buildTheme', () {
    for (final brightness in Brightness.values) {
      test('builds a Material 3 theme for $brightness', () {
        final theme = buildTheme(brightness);

        expect(theme.useMaterial3, isTrue);
        expect(theme.colorScheme.brightness, brightness);
        expect(theme.textTheme.bodyLarge?.fontSize, 16);
        expect(theme.appBarTheme.centerTitle, isTrue);
        expect(theme.appBarTheme.backgroundColor, AppColors.primaryColor);
      });
    }

    test('uses NotoSansLao with Roboto fallback', () {
      final theme = buildTheme(Brightness.light);

      expect(theme.textTheme.bodyLarge?.fontFamily, 'NotoSansLao');
      expect(theme.textTheme.bodyLarge?.fontFamilyFallback, [
        'Roboto',
        'NotoSansLao',
      ]);
    });

    test('light and dark color schemes differ', () {
      expect(
        buildTheme(Brightness.light).colorScheme.surface,
        isNot(buildTheme(Brightness.dark).colorScheme.surface),
      );
    });
  });
}
