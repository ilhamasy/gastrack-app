import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrack_app/features/settings/presentation/settings_screen.dart';
import 'package:gastrack_app/features/settings/data/preferences_repository.dart';
import 'package:gastrack_app/features/settings/domain/preferences.dart';
import 'package:gastrack_app/features/history/presentation/service_record_detail_screen.dart';
import 'package:gastrack_app/features/history/presentation/add_service_record_screen.dart';
import 'package:gastrack_app/features/history/domain/service_record.dart';
import 'package:gastrack_app/features/dashboard/presentation/dashboard_screen.dart';
import 'package:gastrack_app/features/dashboard/presentation/odometer_history_screen.dart';
import 'package:gastrack_app/features/dashboard/data/odometer_repository.dart';
import 'package:gastrack_app/features/dashboard/data/expense_repository.dart';
import 'package:gastrack_app/features/dashboard/data/recommendation_repository.dart';
import 'package:gastrack_app/features/dashboard/domain/odometer_log.dart';
import 'package:gastrack_app/features/dashboard/domain/expense_analytics.dart';
import 'package:gastrack_app/features/dashboard/domain/recommendation.dart';
import 'package:gastrack_app/features/history/presentation/history_screen.dart';
import 'package:gastrack_app/features/history/presentation/history_provider.dart';
import 'package:gastrack_app/features/maintenance/presentation/maintenance_screen.dart';
import 'package:gastrack_app/features/maintenance/data/maintenance_repository.dart';
import 'package:gastrack_app/features/maintenance/domain/vehicle_maintenance.dart';
import 'package:gastrack_app/features/vehicles/data/vehicle_repository.dart';
import 'package:gastrack_app/features/vehicles/domain/vehicle.dart';

class FakePreferencesRepository extends Fake implements PreferencesRepository {
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
  final sampleVehicle = Vehicle(
    id: 'v-1',
    userId: 'u-1',
    name: 'Honda Civic',
    make: 'Honda',
    model: 'Civic',
    variant: 'RS',
    year: 2022,
    isPrimary: true,
    currentOdometer: 15000,
  );

  Widget buildTestableWidget(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: [
        preferencesRepositoryProvider.overrideWithValue(FakePreferencesRepository()),
        primaryVehicleProvider.overrideWith((ref) async => sampleVehicle),
        ...overrides,
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('SettingsScreen Widget Test', () {
    testWidgets('renders SettingsScreen with options', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const SettingsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });
  });

  group('ServiceRecordDetailScreen Widget Test', () {
    testWidgets('renders ServiceRecordDetailScreen correctly', (WidgetTester tester) async {
      final record = ServiceRecord(
        id: 'sr-1',
        vehicleId: 'v-1',
        serviceDate: DateTime(2026, 9, 20),
        odometerKm: 15000,
        workshopName: 'Honda Official',
        totalCost: 150000.0,
        notes: 'Regular checkup',
        items: [
          ServiceItem(
            id: 'item-1',
            itemName: 'Engine Oil',
            cost: 150000.0,
            quantity: 1.0,
          )
        ],
      );

      await tester.pumpWidget(buildTestableWidget(ServiceRecordDetailScreen(record: record)));
      await tester.pumpAndSettle();

      expect(find.text('Honda Official'), findsOneWidget);
      expect(find.text('Engine Oil'), findsOneWidget);
    });
  });

  group('AddServiceRecordScreen Widget Test', () {
    testWidgets('renders AddServiceRecordScreen with form fields', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const AddServiceRecordScreen(vehicleId: 'v-1')));
      await tester.pumpAndSettle();

      expect(find.text('Add Service Record'), findsOneWidget);
    });
  });

  group('DashboardScreen Widget Test', () {
    testWidgets('renders DashboardScreen with vehicle details', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const DashboardScreen(),
        overrides: [
          expenseAnalyticsProvider('v-1').overrideWith((ref) async => ExpenseAnalytics(monthlyExpenses: [], categoryExpenses: [])),
          recommendationsProvider('v-1').overrideWith((ref) async => <Recommendation>[]),
          vehicleMaintenanceProvider('v-1').overrideWith((ref) async => <VehicleMaintenance>[]),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Honda Civic'), findsOneWidget);
    });
  });

  group('OdometerHistoryScreen Widget Test', () {
    testWidgets('renders OdometerHistoryScreen with log items', (WidgetTester tester) async {
      final logs = [
        OdometerLog(
          id: 'log-1',
          vehicleId: 'v-1',
          odometerValue: 12000,
          recordedAt: DateTime(2026, 9, 23, 10, 0),
        ),
      ];

      await tester.pumpWidget(buildTestableWidget(
        const OdometerHistoryScreen(vehicleId: 'v-1'),
        overrides: [
          odometerHistoryProvider('v-1').overrideWith((ref) async => logs),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('Odometer History'), findsOneWidget);
      expect(find.text('12000 KM'), findsOneWidget);
    });
  });

  group('HistoryScreen Widget Test', () {
    testWidgets('renders HistoryScreen with service records', (WidgetTester tester) async {
      final records = [
        ServiceRecord(
          id: 'sr-1',
          vehicleId: 'v-1',
          serviceDate: DateTime(2026, 9, 20),
          odometerKm: 15000,
          workshopName: 'Honda Official',
          totalCost: 150000.0,
          items: [],
        ),
      ];

      await tester.pumpWidget(buildTestableWidget(
        const HistoryScreen(),
        overrides: [
          historyProvider.overrideWith((ref) async => records),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('Service History'), findsOneWidget);
      expect(find.text('Honda Official'), findsOneWidget);
    });
  });

  group('MaintenanceScreen Widget Test', () {
    testWidgets('renders MaintenanceScreen with maintenance items', (WidgetTester tester) async {
      final items = <VehicleMaintenance>[
        VehicleMaintenance(
          id: 'm-1',
          vehicleId: 'v-1',
          name: 'Oil Change',
          intervalKm: 10000,
          lastServiceKm: 5000,
          source: 'TEMPLATE',
          priority: 1,
        ),
      ];

      await tester.pumpWidget(buildTestableWidget(
        const MaintenanceScreen(),
        overrides: [
          vehicleMaintenanceProvider('v-1').overrideWith((ref) async => items),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('Maintenance'), findsOneWidget);
      expect(find.text('Oil Change'), findsOneWidget);
    });
  });
}
