import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/odometer_repository.dart';

class OdometerHistoryScreen extends ConsumerWidget {
  final String vehicleId;

  const OdometerHistoryScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(odometerHistoryProvider(vehicleId));

    return Scaffold(
      appBar: AppBar(title: const Text('Odometer History')),
      body: historyAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(child: Text('No odometer history found.'));
          }
          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return ListTile(
                leading: const Icon(Icons.speed),
                title: Text('${log.odometerValue} KM', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(DateFormat.yMMMd().add_Hm().format(log.recordedAt.toLocal())),
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
