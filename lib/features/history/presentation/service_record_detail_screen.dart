import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../domain/service_record.dart';

class ServiceRecordDetailScreen extends StatelessWidget {
  final ServiceRecord record;

  const ServiceRecordDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Record Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInfoRow('Service Date', DateFormat.yMMMd().format(record.serviceDate)),
          _buildInfoRow('Odometer', '${record.odometerKm} km'),
          _buildInfoRow('Workshop', record.workshopName ?? '-'),
          _buildInfoRow('Total Cost', '\$${record.totalCost.toStringAsFixed(2)}'),
          if (record.notes != null && record.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(record.notes!),
          ],
          const Divider(height: 32),
          const Text('Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          ...record.items.map((item) => Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  title: Text(item.itemName),
                  subtitle: Text('Qty: ${item.quantity}'),
                  trailing: Text(
                    '\$${(item.cost * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
          if (record.items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No items recorded.', style: TextStyle(color: Colors.grey)),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
