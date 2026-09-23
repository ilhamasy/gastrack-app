import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/routes.dart';
import '../../vehicles/data/vehicle_repository.dart';
import '../data/maintenance_repository.dart';
import '../domain/vehicle_maintenance.dart';

class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryVehicleAsync = ref.watch(primaryVehicleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance')),
      body: primaryVehicleAsync.when(
        data: (vehicle) {
          if (vehicle == null) {
            return const Center(child: Text('No primary vehicle selected.'));
          }

          final maintenanceAsync = ref.watch(vehicleMaintenanceProvider(vehicle.id));

          return maintenanceAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return const Center(child: Text('No maintenance configured.'));
              }

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _MaintenanceListTile(item: item);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _MaintenanceListTile extends StatelessWidget {
  final VehicleMaintenance item;

  const _MaintenanceListTile({required this.item});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    switch (item.status) {
      case 'OVERDUE':
        statusColor = Colors.red;
        statusIcon = Icons.warning;
        break;
      case 'DUE':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      case 'CRITICAL':
        statusColor = Colors.deepOrange;
        statusIcon = Icons.error_outline;
        break;
      case 'UPCOMING':
        statusColor = Colors.blue;
        statusIcon = Icons.info_outline;
        break;
      default:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
    }

    String subtitle = '';
    if (item.remainingKm != null) {
      subtitle += '${item.remainingKm} KM remaining';
    }
    if (item.remainingDays != null) {
      if (subtitle.isNotEmpty) subtitle += ' / ';
      subtitle += '${item.remainingDays} Days remaining';
    }

    return ListTile(
      leading: Icon(statusIcon, color: statusColor, size: 32),
      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          Text('Status: ${item.status ?? "NORMAL"}', style: TextStyle(color: statusColor, fontWeight: FontWeight.w600)),
        ],
      ),
      isThreeLine: true,
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        context.pushNamed(
          AppRoutes.maintenanceDetailName,
          pathParameters: {'id': item.id},
          extra: item,
        );
      },
    );
  }
}
