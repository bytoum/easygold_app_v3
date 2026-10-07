import 'package:easygold_app_v3/config/themes/app_text_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('body styles step down in size at regular weight', () {
    final sizes = [
      appTextTheme.bodyLarge,
      appTextTheme.bodyMedium,
      appTextTheme.bodySmall,
    ].map((s) => s?.fontSize).toList();

    expect(sizes, [16, 14, 12]);
    for (final style in [
      appTextTheme.bodyLarge,
      appTextTheme.bodyMedium,
      appTextTheme.bodySmall,
    ]) {
      expect(style?.fontWeight, FontWeight.w400);
    }
  });
}
