import 'package:easygold_app_v3/config/routes/app_router.dart';
import 'package:easygold_app_v3/features/home/presentation/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

Widget _app() => MaterialApp.router(
  routerConfig: GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(path: Routes.home, builder: (_, _) => const HomePage()),
      GoRoute(
        path: Routes.signIn,
        builder: (_, _) => const Scaffold(body: Text('sign-in destination')),
      ),
    ],
  ),
);

void main() {
  testWidgets('shows the app bar title and a Sign In button', (tester) async {
    await tester.pumpWidget(_app());

    expect(find.text('Home Page'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
  });

  testWidgets('tapping Sign In pushes the sign-in route', (tester) async {
    await tester.pumpWidget(_app());

    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('sign-in destination'), findsOneWidget);
    expect(
      find.byType(HomePage, skipOffstage: false),
      findsOneWidget,
      reason: 'push keeps home below',
    );
  });
}
