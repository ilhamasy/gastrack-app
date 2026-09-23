import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gastrack_app/features/auth/data/auth_repository.dart';
import 'package:gastrack_app/features/vehicles/data/vehicle_repository.dart';
import 'package:gastrack_app/features/settings/data/preferences_repository.dart';
import 'package:gastrack_app/features/history/data/history_repository.dart';
import 'package:gastrack_app/features/maintenance/data/maintenance_repository.dart';
import 'package:gastrack_app/features/dashboard/data/odometer_repository.dart';
import 'package:gastrack_app/features/dashboard/data/expense_repository.dart';
import 'package:gastrack_app/features/dashboard/data/recommendation_repository.dart';

class FakeSecureStorage extends Fake implements FlutterSecureStorage {
  final Map<String, String> _data = {};

  @override
  Future<String?> read({required String key, iOptions, aOptions, eOptions, sOptions, mOptions, lOptions, webOptions, wOptions}) async {
    return _data[key];
  }

  @override
  Future<void> write({required String key, required String? value, iOptions, aOptions, eOptions, sOptions, mOptions, lOptions, webOptions, wOptions}) async {
    if (value != null) {
      _data[key] = value;
    } else {
      _data.remove(key);
    }
  }

  @override
  Future<void> delete({required String key, iOptions, aOptions, eOptions, sOptions, mOptions, lOptions, webOptions, wOptions}) async {
    _data.remove(key);
  }
}

void main() {
  late Dio dio;
  late FakeSecureStorage storage;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
    storage = FakeSecureStorage();
  });

  group('AuthNotifier', () {
    test('initial state is unauthenticated if token missing', () async {
      final notifier = AuthNotifier(dio, storage);
      await Future.delayed(Duration.zero);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.isAuthenticated, false);
    });

    test('logout clears token and updates state', () async {
      await storage.write(key: 'jwt_token', value: 'fake-token');
      final notifier = AuthNotifier(dio, storage);
      await notifier.logout();

      expect(notifier.state.isAuthenticated, false);
      final token = await storage.read(key: 'jwt_token');
      expect(token, null);
    });
  });

  group('VehicleRepository', () {
    test('instantiates correctly with Dio', () {
      final repo = VehicleRepository(dio);
      expect(repo, isNotNull);
    });
  });

  group('PreferencesRepository', () {
    test('instantiates correctly with Dio', () {
      final repo = PreferencesRepository(dio);
      expect(repo, isNotNull);
    });
  });

  group('HistoryRepository', () {
    test('instantiates correctly with Dio', () {
      final repo = HistoryRepository(dio);
      expect(repo, isNotNull);
    });
  });

  group('MaintenanceRepository', () {
    test('instantiates correctly with Dio', () {
      final repo = MaintenanceRepository(dio);
      expect(repo, isNotNull);
    });
  });

  group('Dashboard Repositories', () {
    test('instantiates OdometerRepository, ExpenseRepository, RecommendationRepository', () {
      final odoRepo = OdometerRepository(dio);
      final expRepo = ExpenseRepository(dio);
      final recRepo = RecommendationRepository(dio);

      expect(odoRepo, isNotNull);
      expect(expRepo, isNotNull);
      expect(recRepo, isNotNull);
    });
  });
}
