import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_repository.dart';
import '../domain/vehicle_maintenance.dart';

class MaintenanceRepository {
  final Dio _dio;

  MaintenanceRepository(this._dio);

  Future<List<VehicleMaintenance>> getVehicleMaintenance(String vehicleId) async {
    try {
      final response = await _dio.get('/api/vehicles/$vehicleId/maintenance');
      final List<dynamic> data = response.data;
      return data.map((e) => VehicleMaintenance.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch maintenance items: $e');
    }
  }

  Future<VehicleMaintenance> addCustomMaintenance(String vehicleId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/api/vehicles/$vehicleId/maintenance', data: data);
      return VehicleMaintenance.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add custom maintenance: $e');
    }
  }

  Future<VehicleMaintenance> updateMaintenance(String vehicleId, String maintenanceId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/api/vehicles/$vehicleId/maintenance/$maintenanceId', data: data);
      return VehicleMaintenance.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update maintenance: $e');
    }
  }
}

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MaintenanceRepository(dio);
});

final vehicleMaintenanceProvider = FutureProvider.family<List<VehicleMaintenance>, String>((ref, vehicleId) {
  final repository = ref.watch(maintenanceRepositoryProvider);
  return repository.getVehicleMaintenance(vehicleId);
});
