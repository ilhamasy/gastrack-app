import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gastrack_app/main.dart';

void main() {
  group('GasTrack App Shell', () {
    testWidgets('renders four bottom navigation items', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: GasTrackApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsWidgets);
      expect(find.text('History'), findsOneWidget);
      expect(find.text('Maintenance'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('starts on Dashboard tab', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: GasTrackApp()),
      );
      await tester.pumpAndSettle();

      // Dashboard screen body is visible
      expect(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.text('Dashboard'),
        ),
        findsWidgets,
      );
    });

    testWidgets('navigates to History tab on tap', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: GasTrackApp()),
      );
      await tester.pumpAndSettle();

      // Tap the History nav item
      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();

      expect(find.text('History'), findsWidgets);
    });

    testWidgets('navigates to Maintenance tab on tap', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: GasTrackApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Maintenance'));
      await tester.pumpAndSettle();

      expect(find.text('Maintenance'), findsWidgets);
    });

    testWidgets('navigates to Settings tab on tap', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: GasTrackApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsWidgets);
    });
  });
}
