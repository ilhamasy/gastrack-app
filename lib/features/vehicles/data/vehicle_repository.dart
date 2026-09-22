import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_repository.dart';
import '../domain/vehicle.dart';

class VehicleRepository {
  final Dio _dio;

  VehicleRepository(this._dio);

  Future<List<Vehicle>> getVehicles() async {
    final response = await _dio.get('/vehicles');
    if (response.data != null) {
      final List<dynamic> data = response.data;
      return data.map((json) => Vehicle.fromJson(json)).toList();
    }
    return [];
  }

  Future<Vehicle> addVehicle({
    required String name,
    required String make,
    required String model,
    required String variant,
    required int year,
    int currentOdometer = 0,
  }) async {
    final response = await _dio.post('/vehicles', data: {
      'name': name,
      'make': make,
      'model': model,
      'variant': variant,
      'year': year,
      'current_odometer': currentOdometer,
    });
    return Vehicle.fromJson(response.data);
  }

  Future<Vehicle> updateVehicle({
    required String id,
    required String name,
    required String make,
    required String model,
    required String variant,
    required int year,
  }) async {
    final response = await _dio.put('/vehicles/$id', data: {
      'name': name,
      'make': make,
      'model': model,
      'variant': variant,
      'year': year,
    });
    return Vehicle.fromJson(response.data);
  }

  Future<void> deleteVehicle(String id) async {
    await _dio.delete('/vehicles/$id');
  }

  Future<void> setPrimaryVehicle(String id) async {
    await _dio.put('/vehicles/$id/primary');
  }
}

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return VehicleRepository(dio);
});

final vehiclesProvider = FutureProvider<List<Vehicle>>((ref) {
  final repository = ref.watch(vehicleRepositoryProvider);
  return repository.getVehicles();
});

final primaryVehicleProvider = FutureProvider<Vehicle?>((ref) async {
  final vehicles = await ref.watch(vehiclesProvider.future);
  try {
    return vehicles.firstWhere((v) => v.isPrimary);
  } catch (e) {
    if (vehicles.isNotEmpty) return vehicles.first;
    return null;
  }
});
