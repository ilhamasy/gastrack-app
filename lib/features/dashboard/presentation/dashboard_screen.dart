import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../vehicles/data/vehicle_repository.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryVehicleAsync = ref.watch(primaryVehicleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: primaryVehicleAsync.when(
          data: (vehicle) {
            if (vehicle == null) {
              return const Text('No Primary Vehicle Selected');
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Active Vehicle', style: TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  vehicle.name,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text('${vehicle.year} ${vehicle.make} ${vehicle.model} ${vehicle.variant}'),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error: $err'),
        ),
      ),
    );
  }
}
