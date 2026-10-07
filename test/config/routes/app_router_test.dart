import 'package:easygold_app_v3/config/routes/app_router.dart';
import 'package:easygold_app_v3/core/widgets/not_found_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('appRouter', () {
    test('registers exactly the splash, sign-in and home routes', () {
      final paths = appRouter.configuration.routes.whereType<GoRoute>().map(
        (r) => r.path,
      );

      expect(paths, [Routes.splash, Routes.signIn, Routes.home]);
    });

    testWidgets('shows NotFoundWidget for an unknown location', (tester) async {
      appRouter.go('/does-not-exist');
      await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter));
      await tester.pumpAndSettle();

      expect(find.byType(NotFoundWidget), findsOneWidget);
      expect(find.text('Not Found'), findsOneWidget);
    });
  });
}
