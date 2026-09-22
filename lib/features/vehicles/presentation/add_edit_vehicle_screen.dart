import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/vehicle_repository.dart';
import '../domain/vehicle.dart';

class AddEditVehicleScreen extends ConsumerStatefulWidget {
  final Vehicle? vehicle;

  const AddEditVehicleScreen({super.key, this.vehicle});

  @override
  ConsumerState<AddEditVehicleScreen> createState() => _AddEditVehicleScreenState();
}

class _AddEditVehicleScreenState extends ConsumerState<AddEditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _makeController;
  late TextEditingController _modelController;
  late TextEditingController _variantController;
  late TextEditingController _yearController;
  late TextEditingController _odometerController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final v = widget.vehicle;
    _nameController = TextEditingController(text: v?.name ?? '');
    _makeController = TextEditingController(text: v?.make ?? '');
    _modelController = TextEditingController(text: v?.model ?? '');
    _variantController = TextEditingController(text: v?.variant ?? '');
    _yearController = TextEditingController(text: v != null ? v.year.toString() : '');
    _odometerController = TextEditingController(text: v != null ? v.currentOdometer.toString() : '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _variantController.dispose();
    _yearController.dispose();
    _odometerController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final name = _nameController.text;
    final make = _makeController.text;
    final model = _modelController.text;
    final variant = _variantController.text;
    final year = int.tryParse(_yearController.text) ?? 0;
    final odometer = int.tryParse(_odometerController.text) ?? 0;

    try {
      final repo = ref.read(vehicleRepositoryProvider);
      if (widget.vehicle == null) {
        // Add
        await repo.addVehicle(
          name: name,
          make: make,
          model: model,
          variant: variant,
          year: year,
          currentOdometer: odometer,
        );
      } else {
        // Edit
        await repo.updateVehicle(
          id: widget.vehicle!.id,
          name: name,
          make: make,
          model: model,
          variant: variant,
          year: year,
        );
      }
      ref.invalidate(vehiclesProvider);
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Vehicle?'),
        content: const Text('Are you sure you want to delete this vehicle?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(vehicleRepositoryProvider).deleteVehicle(widget.vehicle!.id);
      ref.invalidate(vehiclesProvider);
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.vehicle != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Vehicle' : 'Add Vehicle'),
        actions: isEditing
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _isLoading ? null : _delete,
                )
              ]
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _makeController,
                      decoration: const InputDecoration(labelText: 'Brand / Make *'),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _modelController,
                      decoration: const InputDecoration(labelText: 'Model *'),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _variantController,
                      decoration: const InputDecoration(labelText: 'Variant'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _yearController,
                      decoration: const InputDecoration(labelText: 'Year *'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nickname (optional)'),
                    ),
                    if (!isEditing) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _odometerController,
                        decoration: const InputDecoration(labelText: 'Current Odometer'),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(isEditing ? 'Save Changes' : 'Add Vehicle'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
