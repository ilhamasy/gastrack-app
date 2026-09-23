import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/routes.dart';
import '../data/vehicle_repository.dart';

class MyVehiclesScreen extends ConsumerWidget {
  const MyVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vehicles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.pushNamed(AppRoutes.addVehicleName);
            },
          ),
        ],
      ),
      body: vehiclesAsync.when(
        data: (vehicles) {
          if (vehicles.isEmpty) {
            return const Center(child: Text('No vehicles found. Add one!'));
          }
          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return ListTile(
                leading: const Icon(Icons.motorcycle),
                title: Text(vehicle.name),
                subtitle: Text('${vehicle.year} ${vehicle.make} ${vehicle.model} ${vehicle.variant}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (vehicle.isPrimary) const Icon(Icons.star, color: Colors.amber),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'set_primary') {
                          try {
                            await ref.read(vehicleRepositoryProvider).setPrimaryVehicle(vehicle.id);
                            ref.invalidate(vehiclesProvider);
                            ref.invalidate(primaryVehicleProvider);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                            }
                          }
                        } else if (value == 'maintenance_config') {
                          context.pushNamed(
                            AppRoutes.maintenanceConfigName,
                            pathParameters: {'vehicleId': vehicle.id},
                            extra: vehicle,
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        if (!vehicle.isPrimary)
                          const PopupMenuItem(
                            value: 'set_primary',
                            child: Text('Set as Primary'),
                          ),
                        const PopupMenuItem(
                          value: 'maintenance_config',
                          child: Text('Maintenance Config'),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  context.pushNamed(
                    AppRoutes.editVehicleName,
                    pathParameters: {'id': vehicle.id},
                    extra: vehicle,
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
