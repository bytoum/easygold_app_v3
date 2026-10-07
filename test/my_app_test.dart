import 'package:easy_localization/easy_localization.dart';
import 'package:easygold_app_v3/config/routes/app_router.dart';
import 'package:easygold_app_v3/core/widgets/not_found_widget.dart';
import 'package:easygold_app_v3/core/widgets/splash_screen.dart';
import 'package:easygold_app_v3/features/home/presentation/pages/home_page.dart';
import 'package:easygold_app_v3/my_app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keeps the test off the network/S3: no translations, keys fall back to text.
class _EmptyAssetLoader extends AssetLoader {
  const _EmptyAssetLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async => {};
}

const _locales = [Locale('en', 'US'), Locale('lo', 'LA')];

Widget _app() => EasyLocalization(
  supportedLocales: _locales,
  path: 'unused',
  assetLoader: const _EmptyAssetLoader(),
  child: const MyApp(),
);

MaterialApp _materialApp(WidgetTester tester) =>
    tester.widget<MaterialApp>(find.byType(MaterialApp));

/// appRouter is a global, so reset it and let the splash timers drain.
Future<void> _drainSplash(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 2300));
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    appRouter.go(Routes.splash);
  });

  testWidgets('starts on the splash screen', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);

    await _drainSplash(tester);
  });

  testWidgets(
    'is configured as a light, banner-free router app inside OverlayKit',
    (tester) async {
      await tester.pumpWidget(_app());
      await tester.pump();

      final app = _materialApp(tester);
      expect(app.routerConfig, same(appRouter));
      expect(app.debugShowCheckedModeBanner, isFalse);
      expect(app.themeMode, ThemeMode.light);
      expect(app.theme?.brightness, Brightness.light);
      expect(app.darkTheme?.brightness, Brightness.dark);
      expect(
        find.ancestor(
          of: find.byType(MaterialApp),
          matching: find.byType(OverlayKit),
        ),
        findsOneWidget,
      );

      await _drainSplash(tester);
    },
  );

  testWidgets('wires up easy_localization locales', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    final app = _materialApp(tester);
    expect(app.supportedLocales, _locales);
    expect(app.locale, _locales.first);
    expect(app.localizationsDelegates, isNotEmpty);

    await _drainSplash(tester);
  });

  testWidgets('moves from splash to home once the splash finishes', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    await _drainSplash(tester);

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(SplashScreen), findsNothing);
  });

  testWidgets('unknown routes show the not-found screen', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();
    await _drainSplash(tester);

    appRouter.go('/does-not-exist');
    await tester.pumpAndSettle();

    expect(find.byType(NotFoundWidget), findsOneWidget);
  });
}
