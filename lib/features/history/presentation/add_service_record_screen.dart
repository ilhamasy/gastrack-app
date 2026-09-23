import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../data/history_repository.dart';
import '../domain/service_record.dart';

class AddServiceRecordScreen extends ConsumerStatefulWidget {
  final String vehicleId;

  const AddServiceRecordScreen({super.key, required this.vehicleId});

  @override
  ConsumerState<AddServiceRecordScreen> createState() => _AddServiceRecordScreenState();
}

class _AddServiceRecordScreenState extends ConsumerState<AddServiceRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _odometerController = TextEditingController();
  final _workshopController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _serviceDate = DateTime.now();

  // For simplicity, we only add one item in this basic UI, 
  // though the model supports multiple.
  final _itemNameController = TextEditingController();
  final _costController = TextEditingController();

  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _serviceDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _serviceDate) {
      setState(() {
        _serviceDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final odometer = int.parse(_odometerController.text);
      final cost = double.parse(_costController.text);
      
      final item = ServiceItem(
        itemName: _itemNameController.text,
        cost: cost,
      );

      final record = ServiceRecord(
        vehicleId: widget.vehicleId,
        serviceDate: _serviceDate,
        odometerKm: odometer,
        workshopName: _workshopController.text.isEmpty ? null : _workshopController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        totalCost: cost,
        items: [item],
      );

      await ref.read(historyRepositoryProvider).addServiceRecord(widget.vehicleId, record);
      
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service record added')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _odometerController.dispose();
    _workshopController.dispose();
    _notesController.dispose();
    _itemNameController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service Record'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  ListTile(
                    title: const Text('Service Date'),
                    subtitle: Text(DateFormat.yMMMd().format(_serviceDate)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _odometerController,
                    decoration: const InputDecoration(labelText: 'Odometer (KM)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _workshopController,
                    decoration: const InputDecoration(labelText: 'Workshop Name (Optional)'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(labelText: 'Notes (Optional)'),
                    maxLines: 3,
                  ),
                  const Divider(height: 32),
                  const Text('Service Item', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _itemNameController,
                    decoration: const InputDecoration(labelText: 'Item Name (e.g. Engine Oil)'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _costController,
                    decoration: const InputDecoration(labelText: 'Cost'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Save Record'),
                  ),
                ],
              ),
            ),
    );
  }
}
