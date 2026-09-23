import 'package:flutter_test/flutter_test.dart';
import 'package:gastrack_app/features/vehicles/domain/vehicle.dart';
import 'package:gastrack_app/features/dashboard/domain/recommendation.dart';
import 'package:gastrack_app/features/dashboard/domain/expense_analytics.dart';
import 'package:gastrack_app/features/dashboard/domain/odometer_log.dart';
import 'package:gastrack_app/features/history/domain/service_record.dart';
import 'package:gastrack_app/features/maintenance/domain/vehicle_maintenance.dart';
import 'package:gastrack_app/features/settings/domain/preferences.dart';

void main() {
  group('Vehicle Domain Model', () {
    test('Vehicle.fromJson and toJson work correctly', () {
      final json = {
        'id': 'v-123',
        'user_id': 'u-123',
        'name': 'My Civic',
        'make': 'Honda',
        'model': 'Civic',
        'variant': 'RS',
        'year': 2022,
        'is_primary': true,
        'current_odometer': 15000,
      };

      final vehicle = Vehicle.fromJson(json);

      expect(vehicle.id, 'v-123');
      expect(vehicle.name, 'My Civic');
      expect(vehicle.make, 'Honda');
      expect(vehicle.model, 'Civic');
      expect(vehicle.year, 2022);
      expect(vehicle.isPrimary, true);
      expect(vehicle.currentOdometer, 15000);

      final outputJson = vehicle.toJson();
      expect(outputJson['name'], 'My Civic');
      expect(outputJson['make'], 'Honda');
    });

    test('Vehicle.copyWith works correctly', () {
      final vehicle = Vehicle(
        id: 'v-1',
        userId: 'u-1',
        name: 'Car',
        make: 'Toyota',
        model: 'Corolla',
        variant: 'STD',
        year: 2020,
        isPrimary: false,
        currentOdometer: 10000,
      );

      final updated = vehicle.copyWith(name: 'Updated Car', isPrimary: true);
      expect(updated.name, 'Updated Car');
      expect(updated.isPrimary, true);
      expect(updated.make, 'Toyota');
    });
  });

  group('Recommendation Domain Model', () {
    test('Recommendation.fromJson works correctly', () {
      final json = {
        'id': 'rec-1',
        'title': 'Change Oil',
        'description': 'Engine oil is overdue',
        'priority': 1,
        'category': 'Maintenance',
      };

      final rec = Recommendation.fromJson(json);
      expect(rec.id, 'rec-1');
      expect(rec.title, 'Change Oil');
      expect(rec.priority, 1);
    });
  });

  group('ExpenseAnalytics Domain Model', () {
    test('ExpenseAnalytics.fromJson works correctly', () {
      final json = {
        'monthly_expenses': [
          {'month': '2026-08', 'total_cost': 150000.0},
        ],
        'category_expenses': [
          {'category': 'Oil', 'total_cost': 150000.0},
        ],
      };

      final analytics = ExpenseAnalytics.fromJson(json);
      expect(analytics.monthlyExpenses.length, 1);
      expect(analytics.monthlyExpenses.first.month, '2026-08');
      expect(analytics.categoryExpenses.length, 1);
    });
  });

  group('OdometerLog Domain Model', () {
    test('OdometerLog.fromJson works correctly', () {
      final json = {
        'id': 'log-1',
        'vehicle_id': 'v-1',
        'odometer_value': 12000,
        'recorded_at': '2026-09-23T10:00:00Z',
      };

      final log = OdometerLog.fromJson(json);
      expect(log.id, 'log-1');
      expect(log.odometerValue, 12000);
      expect(log.recordedAt, DateTime.parse('2026-09-23T10:00:00Z'));
    });
  });

  group('ServiceRecord Domain Model', () {
    test('ServiceRecord.fromJson and toJson work correctly', () {
      final json = {
        'id': 'sr-1',
        'vehicle_id': 'v-1',
        'service_date': '2026-09-20T00:00:00Z',
        'odometer_km': 15000,
        'workshop_name': 'Honda Official',
        'total_cost': 250000.0,
        'notes': 'Regular service',
        'items': [
          {
            'id': 'item-1',
            'service_record_id': 'sr-1',
            'item_name': 'Synthetic Oil',
            'cost': 250000.0,
            'quantity': 1.0,
          }
        ],
      };

      final record = ServiceRecord.fromJson(json);
      expect(record.id, 'sr-1');
      expect(record.odometerKm, 15000);
      expect(record.workshopName, 'Honda Official');
      expect(record.items.length, 1);
      expect(record.items.first.itemName, 'Synthetic Oil');

      final output = record.toJson();
      expect(output['odometer_km'], 15000);
      expect(output['workshop_name'], 'Honda Official');
    });
  });

  group('VehicleMaintenance Domain Model', () {
    test('VehicleMaintenance.fromJson works correctly', () {
      final json = {
        'id': 'm-1',
        'vehicle_id': 'v-1',
        'name': 'Brake Inspection',
        'description': 'Check pads',
        'interval_km': 10000,
        'interval_months': 6,
        'last_service_km': 5000,
        'last_service_date': '2026-03-01T00:00:00Z',
        'source': 'TEMPLATE',
        'priority': 2,
        'due_km': 15000,
        'due_date': '2026-09-01T00:00:00Z',
        'remaining_km': -1000,
        'status_text': 'Overdue by 1000 km',
      };

      final m = VehicleMaintenance.fromJson(json);
      expect(m.id, 'm-1');
      expect(m.name, 'Brake Inspection');
      expect(m.intervalKm, 10000);
      expect(m.priority, 2);
    });
  });

  group('NotificationPreferences Domain Model', () {
    test('NotificationPreferences.fromJson and toJson work correctly', () {
      final json = {
        'email_enabled': true,
        'push_enabled': false,
      };

      final prefs = NotificationPreferences.fromJson(json);
      expect(prefs.emailEnabled, true);
      expect(prefs.pushEnabled, false);

      final output = prefs.toJson();
      expect(output['email_enabled'], true);
      expect(output['push_enabled'], false);
    });
  });
}
