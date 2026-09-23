import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../vehicles/data/vehicle_repository.dart';
import '../../maintenance/data/maintenance_repository.dart';
import '../data/odometer_repository.dart';
import '../data/expense_repository.dart';
import '../data/recommendation_repository.dart';
import 'recommendation_carousel.dart';
import '../../../core/routing/routes.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryVehicleAsync = ref.watch(primaryVehicleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(primaryVehicleProvider);
            },
          ),
        ],
      ),
      body: primaryVehicleAsync.when(
        data: (vehicle) {
          if (vehicle == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No primary vehicle selected.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.goNamed(AppRoutes.myVehiclesName),
                    child: const Text('Manage Vehicles'),
                  ),
                ],
              ),
            );
          }

          // Fetch maintenance items for the primary vehicle
          final maintenanceAsync = ref.watch(vehicleMaintenanceProvider(vehicle.id));

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Vehicle Header
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(Icons.directions_car, size: 30, color: Colors.blue),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(vehicle.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('${vehicle.make} ${vehicle.model} (${vehicle.year})', style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Recommendations Carousel
              ref.watch(recommendationsProvider(vehicle.id)).when(
                data: (recommendations) => RecommendationCarousel(recommendations: recommendations),
                loading: () => const SizedBox(height: 160, child: Center(child: CircularProgressIndicator())),
                error: (err, st) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),

              // Odometer Update
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.speed, size: 64, color: Colors.blue),
                      const SizedBox(height: 8),
                      const Text(
                        'Odometer',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('Current Odometer', style: TextStyle(color: Colors.grey)),
                              Text('${vehicle.currentOdometer} KM', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showUpdateOdometerDialog(context, ref, vehicle.id, vehicle.currentOdometer),
                            icon: const Icon(Icons.edit),
                            label: const Text('Update'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Upcoming Maintenance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      // Navigate to maintenance tab, which is in the StatefulShellRoute
                      // For now, we can just pushNamed or the user can tap the tab.
                      // Since we are in a tab, let's just let them tap the tab, or we can use GoRouter context.go
                      context.goNamed(AppRoutes.maintenanceName);
                    },
                    child: const Text('Show More'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              maintenanceAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('No upcoming maintenance.')));
                  }
                  // Items are already sorted by priority by backend
                  final topItems = items.take(3).toList();
                  return Column(
                    children: topItems.map((item) {
                      Color statusColor = Colors.grey;
                      IconData statusIcon = Icons.check_circle;
                      
                      if (item.priority == 1) {
                        statusColor = Colors.red;
                        statusIcon = Icons.warning;
                      } else if (item.priority == 2) {
                        statusColor = Colors.orange;
                        statusIcon = Icons.info;
                      } else if (item.priority == 3) {
                        statusColor = Colors.yellow.shade700;
                        statusIcon = Icons.error_outline;
                      } else if (item.priority == 4) {
                        statusColor = Colors.blue;
                        statusIcon = Icons.schedule;
                      } else if (item.priority == 5) {
                        statusColor = Colors.green;
                        statusIcon = Icons.check_circle;
                      }
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(statusIcon, color: statusColor),
                          title: Text(item.name),
                          subtitle: Text('Due in ${item.remainingKm} km / ${item.remainingDays} days'),
                          trailing: Text(item.status ?? 'Normal', style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                          onTap: () {
                            context.goNamed(
                              AppRoutes.maintenanceDetailName,
                              pathParameters: {'id': item.id},
                              extra: item,
                            );
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Text('Error: $e'),
              ),
              
              const SizedBox(height: 24),
              const Text('Expense Analytics (Last 6 Months)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              ref.watch(expenseAnalyticsProvider(vehicle.id)).when(
                data: (analytics) {
                  if (analytics.monthlyExpenses.isEmpty && analytics.categoryExpenses.isEmpty) {
                    return const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('No expense data.')));
                  }
                  
                  return Column(
                    children: [
                      // Monthly chart placeholder - replace with actual fl_chart BarChart later
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Monthly Expenses', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: analytics.monthlyExpenses.length,
                                  itemBuilder: (ctx, i) {
                                    final exp = analytics.monthlyExpenses[i];
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: (exp.totalCost / 1000).clamp(10, 150).toDouble(), // arbitrary scale
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(exp.month, style: const TextStyle(fontSize: 10)),
                                          Text('\$${exp.totalCost.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Category list
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('By Category', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              ...analytics.categoryExpenses.map((cat) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(cat.category),
                                      Text('\$${cat.totalCost.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Text('Error: $e'),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Future<void> _showUpdateOdometerDialog(BuildContext context, WidgetRef ref, String vehicleId, int currentOdometer) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Odometer'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'New Odometer (KM)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                final intValue = int.tryParse(value);
                if (intValue == null) {
                  return 'Please enter a valid number';
                }
                if (intValue < currentOdometer) {
                  return 'Cannot be lower than current ($currentOdometer KM)';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newValue = int.parse(controller.text);
                  try {
                    await ref.read(odometerRepositoryProvider).logOdometer(vehicleId, newValue);
                    ref.refresh(primaryVehicleProvider.future);
                    ref.refresh(vehicleMaintenanceProvider(vehicleId).future);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Odometer updated successfully')));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
