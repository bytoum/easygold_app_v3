import 'package:easygold_app_v3/core/widgets/not_found_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows "Not Found" by default', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: NotFoundWidget()));

    expect(find.text('Not Found'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('shows a custom message when given one', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: NotFoundWidget(message: 'Nothing here')),
    );

    expect(find.text('Nothing here'), findsOneWidget);
    expect(find.text('Not Found'), findsNothing);
  });
}
