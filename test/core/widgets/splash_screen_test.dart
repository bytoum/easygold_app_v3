import 'package:easygold_app_v3/config/routes/app_router.dart';
import 'package:easygold_app_v3/core/widgets/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

Widget _app() => MaterialApp.router(
  routerConfig: GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(
        path: Routes.home,
        builder: (_, _) => const Scaffold(body: Text('home destination')),
      ),
    ],
  ),
);

double _opacity(WidgetTester tester) =>
    tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity;

void main() {
  testWidgets('starts fully visible and does not navigate early', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pump(const Duration(milliseconds: 2000));

    expect(_opacity(tester), 1);
    expect(find.byType(SplashScreen), findsOneWidget);

    // Let the 2.2s startup timer finish so none is left pending.
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
  });

  testWidgets('fades out after 2.2s then goes to home', (tester) async {
    await tester.pumpWidget(_app());

    await tester.pump(const Duration(milliseconds: 2300));
    expect(_opacity(tester), 0);
    expect(find.byType(SplashScreen), findsOneWidget, reason: 'still fading');

    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('home destination'), findsOneWidget);
    expect(find.byType(SplashScreen), findsNothing);
  });
}
