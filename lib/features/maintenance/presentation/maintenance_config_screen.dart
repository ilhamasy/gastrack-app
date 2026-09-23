import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/routes.dart';
import '../../vehicles/domain/vehicle.dart';
import '../data/maintenance_repository.dart';

class MaintenanceConfigScreen extends ConsumerWidget {
  final Vehicle vehicle;

  const MaintenanceConfigScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maintenanceAsync = ref.watch(vehicleMaintenanceProvider(vehicle.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Maintenance Config'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.pushNamed(
            AppRoutes.addMaintenanceName,
            pathParameters: {'vehicleId': vehicle.id},
          );
        },
      ),
      body: maintenanceAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No maintenance items configured.'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: const Icon(Icons.build),
                title: Text(item.name),
                subtitle: Text('Interval: ${item.intervalKm ?? 'N/A'} KM / ${item.intervalMonths ?? 'N/A'} Months\nSource: ${item.source}'),
                isThreeLine: true,
                trailing: const Icon(Icons.edit),
                onTap: () {
                  context.pushNamed(
                    AppRoutes.editMaintenanceName,
                    pathParameters: {'vehicleId': vehicle.id, 'id': item.id},
                    extra: item,
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
