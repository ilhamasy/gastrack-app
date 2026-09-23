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

  Future<List<ServiceRecord>> getServiceRecords(String vehicleId) async {
    try {
      final response = await _dio.get('/api/vehicles/$vehicleId/service-records');
      final List<dynamic> data = response.data;
      return data.map((e) => ServiceRecord.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch service records: $e');
    }
  }
}
