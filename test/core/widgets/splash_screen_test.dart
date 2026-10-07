import 'package:easygold_app_v3/config/routes/app_router.dart';
import 'package:easygold_app_v3/core/widgets/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('fades out after the delay, then navigates home', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
        GoRoute(path: Routes.home, builder: (_, _) => const Text('home-page')),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    double opacity() =>
        tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity;

    expect(opacity(), 1);
    expect(find.text('home-page'), findsNothing);

    await tester.pump(const Duration(milliseconds: 2100));
    expect(opacity(), 1, reason: 'still showing before the 2200ms delay');

    await tester.pump(const Duration(milliseconds: 200));
    expect(opacity(), 0);
    expect(find.text('home-page'), findsNothing);

    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    expect(find.text('home-page'), findsOneWidget);
  });
}
