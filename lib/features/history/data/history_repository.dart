import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/service_record.dart';

final historyRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return HistoryRepository(dio);
});

class HistoryRepository {
  final Dio _dio;

  HistoryRepository(this._dio);

  Future<void> addServiceRecord(String vehicleId, ServiceRecord record) async {
    try {
      await _dio.post(
        '/api/vehicles/$vehicleId/service-records',
        data: record.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to add service record: $e');
    }
  }
}
