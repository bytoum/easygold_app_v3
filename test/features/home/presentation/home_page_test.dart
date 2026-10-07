import 'package:easygold_app_v3/config/routes/app_router.dart';
import 'package:easygold_app_v3/features/home/presentation/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  GoRouter routerAt() => GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(path: Routes.home, builder: (_, _) => const HomePage()),
      GoRoute(
        path: Routes.signIn,
        builder: (_, _) => const Text('sign-in-page'),
      ),
    ],
  );

  testWidgets('renders the title and a sign-in button', (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: routerAt()));

    expect(find.text('Home Page'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
  });

  testWidgets('tapping Sign In pushes the sign-in route', (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: routerAt()));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('sign-in-page'), findsOneWidget);
  });
}
