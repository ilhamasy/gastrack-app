import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/routing/routes.dart';
import '../../vehicles/data/vehicle_repository.dart';
import 'history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(primaryVehicleProvider);
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service History'),
      ),
      body: vehicleAsync.when(
        data: (vehicle) {
          if (vehicle == null) {
            return const Center(child: Text('No vehicle selected.'));
          }

          return historyAsync.when(
            data: (records) {
              if (records.isEmpty) {
                return const Center(
                  child: Text(
                    'No service history.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => ref.refresh(historyProvider.future),
                child: ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(
                          record.workshopName ?? 'Service Record',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Date: ${DateFormat.yMMMd().format(record.serviceDate)}'),
                            Text('Odometer: ${record.odometerKm} km'),
                          ],
                        ),
                        trailing: Text(
                          '\$${record.totalCost.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                        onTap: () {
                          context.goNamed(
                            AppRoutes.serviceRecordDetailName,
                            pathParameters: {'id': record.id!},
                            extra: record,
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: vehicleAsync.value != null
          ? FloatingActionButton(
              onPressed: () {
                context.goNamed(
                  AppRoutes.addServiceRecordName,
                  pathParameters: {'vehicleId': vehicleAsync.value!.id},
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
