import 'package:easygold_app_v3/config/routes/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Routes', () {
    test('exposes the expected application locations', () {
      expect(Routes.splash, '/');
      expect(Routes.home, '/home');
      expect(Routes.signIn, '/sign-in');
      expect(Routes.signUp, '/sign-up');
    });
  });
}
