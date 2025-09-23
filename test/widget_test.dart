// This is a basic Flutter widget test for Fibaya Mina app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:fibaya_mina/main.dart';

void main() {
  testWidgets('Fibaya Mina app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FibayaMinaApp());

    // Verify that our app shows the category filters.
    expect(find.text('Tous (55)'), findsOneWidget);
    expect(find.text('Maintenance (2)'), findsOneWidget);
    expect(find.text('Alimentation (6)'), findsOneWidget);

    // Verify that service cards are present.
    expect(find.text('Trouver un prestataire'), findsWidgets);
  });
}
