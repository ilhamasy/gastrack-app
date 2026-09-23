import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../vehicles/data/vehicle_repository.dart';
import '../data/history_repository.dart';
import '../domain/service_record.dart';

final historyProvider = FutureProvider<List<ServiceRecord>>((ref) async {
  final vehicleAsync = ref.watch(primaryVehicleProvider);
  return vehicleAsync.when(
    data: (vehicle) {
      if (vehicle == null) return [];
      return ref.read(historyRepositoryProvider).getServiceRecords(vehicle.id);
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
