import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/odometer_log.dart';

class OdometerRepository {
  final Dio _dio;

  OdometerRepository(this._dio);

  Future<void> logOdometer(String vehicleId, int value) async {
    await _dio.post(
      '/vehicles/$vehicleId/odometer',
      data: {'odometer_value': value},
    );
  }

  Future<List<OdometerLog>> getOdometerHistory(String vehicleId) async {
    final response = await _dio.get('/vehicles/$vehicleId/odometer');
    final data = response.data['data'] as List;
    return data.map((json) => OdometerLog.fromJson(json)).toList();
  }
}

final odometerRepositoryProvider = Provider<OdometerRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return OdometerRepository(dio);
});

final odometerHistoryProvider = FutureProvider.family<List<OdometerLog>, String>((ref, vehicleId) {
  final repository = ref.watch(odometerRepositoryProvider);
  return repository.getOdometerHistory(vehicleId);
});
