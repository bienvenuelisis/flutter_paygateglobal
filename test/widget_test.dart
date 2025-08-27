import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../example/lib/main.dart';

void main() {
  group('PayGate Example App Widget Tests', () {
    testWidgets('should display main UI elements', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify app title
      expect(find.text('Flutter Paygate Global Example'), findsOneWidget);

      // Verify essential UI elements exist
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('should validate phone number input', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Find phone number field and enter invalid number
      final phoneField = find.byType(TextFormField).first;
      await tester.enterText(phoneField, '12345');

      // Try to submit form
      final submitButton = find.byType(ElevatedButton).first;
      await tester.tap(submitButton);
      await tester.pump();

      // Should show validation error
      expect(find.textContaining('Invalid'), findsOneWidget);
    });

    testWidgets('should show provider selection', (tester) async {
      await tester.pumpWidget(const MyApp());

      // Should have radio buttons or dropdown for provider selection
      expect(find.byType(RadioListTile), findsWidgets);
    });
  });
}
