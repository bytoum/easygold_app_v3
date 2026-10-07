import 'package:easygold_app_v3/core/widgets/not_found_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) =>
      tester.pumpWidget(MaterialApp(home: child));

  testWidgets('shows the default message', (tester) async {
    await pump(tester, const NotFoundWidget());
    expect(find.text('Not Found'), findsOneWidget);
  });

  testWidgets('shows a custom message instead of the default', (tester) async {
    await pump(tester, const NotFoundWidget(message: 'Nope'));
    expect(find.text('Nope'), findsOneWidget);
    expect(find.text('Not Found'), findsNothing);
  });
}
