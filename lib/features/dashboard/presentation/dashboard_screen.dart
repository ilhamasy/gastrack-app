import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../vehicles/data/vehicle_repository.dart';
import '../data/odometer_repository.dart';
import '../../../core/routing/routes.dart';

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
                const SizedBox(height: 32),
                const Text('Current Odometer', style: TextStyle(fontSize: 16, color: Colors.grey)),
                Text(
                  '${vehicle.currentOdometer} KM',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showUpdateOdometerDialog(context, ref, vehicle.id, vehicle.currentOdometer),
                  icon: const Icon(Icons.speed),
                  label: const Text('Update Odometer'),
                ),
                TextButton(
                  onPressed: () {
                    context.pushNamed(AppRoutes.odometerHistory, extra: vehicle.id);
                  },
                  child: const Text('View Odometer History'),
                ),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error: $err'),
        ),
      ),
    );
  }

  Future<void> _showUpdateOdometerDialog(BuildContext context, WidgetRef ref, String vehicleId, int currentOdometer) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Odometer'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'New Odometer (KM)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                final intValue = int.tryParse(value);
                if (intValue == null) {
                  return 'Please enter a valid number';
                }
                if (intValue < currentOdometer) {
                  return 'Cannot be lower than current ($currentOdometer KM)';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newValue = int.parse(controller.text);
                  try {
                    await ref.read(odometerRepositoryProvider).logOdometer(vehicleId, newValue);
                    if (context.mounted) {
                      Navigator.pop(context);
                      // Invalidate vehicles provider to get updated currentOdometer
                      ref.invalidate(vehiclesProvider);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
