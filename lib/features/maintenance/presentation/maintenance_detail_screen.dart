import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../domain/vehicle_maintenance.dart';

class MaintenanceDetailScreen extends StatelessWidget {
  final VehicleMaintenance maintenance;

  const MaintenanceDetailScreen({super.key, required this.maintenance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              maintenance.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (maintenance.description != null) ...[
              const SizedBox(height: 8),
              Text(
                maintenance.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            const SizedBox(height: 24),
            _buildSection(context, 'Status', _buildStatusInfo()),
            const SizedBox(height: 24),
            _buildSection(context, 'Configuration', _buildConfigInfo()),
            const SizedBox(height: 24),
            _buildSection(context, 'History', const Text('Service history will be displayed here.')),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: content,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Current Status', maintenance.status ?? 'NORMAL'),
        if (maintenance.remainingKm != null)
          _buildInfoRow('Remaining KM', '${maintenance.remainingKm} KM'),
        if (maintenance.remainingDays != null)
          _buildInfoRow('Remaining Days', '${maintenance.remainingDays} Days'),
        if (maintenance.nextServiceKm != null)
          _buildInfoRow('Next Service At', '${maintenance.nextServiceKm} KM'),
        if (maintenance.nextServiceDate != null)
          _buildInfoRow('Next Service Date', DateFormat.yMMMd().format(maintenance.nextServiceDate!)),
      ],
    );
  }

  Widget _buildConfigInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (maintenance.intervalKm != null)
          _buildInfoRow('Interval KM', '${maintenance.intervalKm} KM'),
        if (maintenance.intervalMonths != null)
          _buildInfoRow('Interval Months', '${maintenance.intervalMonths} Months'),
        _buildInfoRow('Source', maintenance.source),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
