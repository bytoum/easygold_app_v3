import 'package:easygold_app_v3/config/routes/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('route paths are stable', () {
    expect(Routes.splash, '/');
    expect(Routes.home, '/home');
    expect(Routes.signIn, '/sign-in');
    expect(Routes.signUp, '/sign-up');
  });

  test('route paths are unique and absolute', () {
    final paths = [Routes.splash, Routes.home, Routes.signIn, Routes.signUp];
    expect(paths.toSet(), hasLength(paths.length));
    expect(paths.every((p) => p.startsWith('/')), isTrue);
  });
}
