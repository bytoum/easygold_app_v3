import 'package:easygold_app_v3/core/constants/app_colors.dart';
import 'package:easygold_app_v3/core/constants/local_keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('primary color is the brand blue', () {
    expect(AppColors.primaryColor, const Color(0xff0C5790));
  });

  test('local storage keys keep their persisted names', () {
    expect(LocalKeys.kIsLocalAuth, 'isLocalAuth');
    expect(LocalKeys.kIsLocalAuthPin, 'isLocalAuthPin');
  });
}
