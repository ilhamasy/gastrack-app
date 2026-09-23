import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/maintenance_repository.dart';
import '../domain/vehicle_maintenance.dart';

class AddEditMaintenanceScreen extends ConsumerStatefulWidget {
  final String vehicleId;
  final VehicleMaintenance? maintenance;

  const AddEditMaintenanceScreen({super.key, required this.vehicleId, this.maintenance});

  @override
  ConsumerState<AddEditMaintenanceScreen> createState() => _AddEditMaintenanceScreenState();
}

class _AddEditMaintenanceScreenState extends ConsumerState<AddEditMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _intervalKmController;
  late TextEditingController _intervalMonthsController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.maintenance?.name ?? '');
    _descController = TextEditingController(text: widget.maintenance?.description ?? '');
    _intervalKmController = TextEditingController(text: widget.maintenance?.intervalKm?.toString() ?? '');
    _intervalMonthsController = TextEditingController(text: widget.maintenance?.intervalMonths?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _intervalKmController.dispose();
    _intervalMonthsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    final repo = ref.read(maintenanceRepositoryProvider);
    final data = {
      'name': _nameController.text,
      'description': _descController.text.isEmpty ? null : _descController.text,
      'interval_km': int.tryParse(_intervalKmController.text),
      'interval_months': int.tryParse(_intervalMonthsController.text),
    };

    try {
      if (widget.maintenance == null) {
        await repo.addCustomMaintenance(widget.vehicleId, data);
      } else {
        await repo.updateMaintenance(widget.vehicleId, widget.maintenance!.id, data);
      }
      
      ref.invalidate(vehicleMaintenanceProvider(widget.vehicleId));
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.maintenance != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Maintenance' : 'Add Maintenance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                enabled: !isEdit || widget.maintenance!.source == 'USER_CREATED', // Can't change name of templates
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description (Optional)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _intervalKmController,
                decoration: const InputDecoration(labelText: 'Interval (KM)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  if (int.tryParse(val) == null) return 'Must be a number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _intervalMonthsController,
                decoration: const InputDecoration(labelText: 'Interval (Months) (Optional)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading ? const CircularProgressIndicator() : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
