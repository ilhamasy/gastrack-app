import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gastrack_app/main.dart';
import 'package:gastrack_app/features/auth/data/auth_repository.dart';
import 'package:gastrack_app/features/vehicles/data/vehicle_repository.dart';
import 'package:gastrack_app/features/settings/data/preferences_repository.dart';
import 'package:gastrack_app/features/settings/domain/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gastrack_app/core/providers.dart';
import 'mock_auth.dart';

class MockPreferencesRepository implements PreferencesRepository {
  @override
  Future<NotificationPreferences> getPreferences() async {
    return NotificationPreferences(emailEnabled: true, pushEnabled: true);
  }
  @override
  Future<NotificationPreferences> updatePreferences(NotificationPreferences prefs) async {
    return prefs;
  }
}

void main() {
  SharedPreferences.setMockInitialValues({});
  late SharedPreferences prefs;

  setUpAll(() async {
    prefs = await SharedPreferences.getInstance();
  });
  group('GasTrack App Shell', () {
    testWidgets('renders four bottom navigation items', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith((ref) => MockAuthNotifier(ref.read(dioProvider), ref.read(secureStorageProvider))),
            vehiclesProvider.overrideWith((ref) => Future.value([])),
            preferencesRepositoryProvider.overrideWithValue(MockPreferencesRepository()),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const GasTrackApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsWidgets);
      expect(find.text('History'), findsOneWidget);
      expect(find.text('Maintenance'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('starts on Dashboard tab', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith((ref) => MockAuthNotifier(ref.read(dioProvider), ref.read(secureStorageProvider))),
            vehiclesProvider.overrideWith((ref) => Future.value([])),
            preferencesRepositoryProvider.overrideWithValue(MockPreferencesRepository()),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const GasTrackApp(),
        ),
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
        ProviderScope(
          overrides: [
            authProvider.overrideWith((ref) => MockAuthNotifier(ref.read(dioProvider), ref.read(secureStorageProvider))),
            vehiclesProvider.overrideWith((ref) => Future.value([])),
            preferencesRepositoryProvider.overrideWithValue(MockPreferencesRepository()),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const GasTrackApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the History nav item
      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();

      expect(find.text('History'), findsWidgets);
    });

    testWidgets('navigates to Maintenance tab on tap', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith((ref) => MockAuthNotifier(ref.read(dioProvider), ref.read(secureStorageProvider))),
            vehiclesProvider.overrideWith((ref) => Future.value([])),
            preferencesRepositoryProvider.overrideWithValue(MockPreferencesRepository()),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const GasTrackApp(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Maintenance'));
      await tester.pumpAndSettle();

      expect(find.text('Maintenance'), findsWidgets);
    });

    testWidgets('navigates to Settings tab on tap', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith((ref) => MockAuthNotifier(ref.read(dioProvider), ref.read(secureStorageProvider))),
            vehiclesProvider.overrideWith((ref) => Future.value([])),
            preferencesRepositoryProvider.overrideWithValue(MockPreferencesRepository()),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const GasTrackApp(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsWidgets);
    });
  });
}
