import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gastrack_app/features/vehicles/presentation/add_edit_vehicle_screen.dart';
import 'package:gastrack_app/features/vehicles/domain/vehicle.dart';

void main() {
  testWidgets('AddEditVehicleScreen renders correctly for Add', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AddEditVehicleScreen(),
        ),
      ),
    );

    expect(find.text('Add Vehicle'), findsNWidgets(2)); // Title and button
    expect(find.byType(TextFormField), findsNWidgets(6)); // 6 fields for Add
  });

  testWidgets('AddEditVehicleScreen renders correctly for Edit', (tester) async {
    final vehicle = Vehicle(
      id: '1',
      userId: '123',
      name: 'Test Bike',
      make: 'Yamaha',
      model: 'R15',
      variant: 'V4',
      year: 2022,
      isPrimary: false,
      currentOdometer: 5000,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: AddEditVehicleScreen(vehicle: vehicle),
        ),
      ),
    );

    expect(find.text('Edit Vehicle'), findsOneWidget); // Title
    expect(find.text('Save Changes'), findsOneWidget); // Button
    expect(find.byType(TextFormField), findsNWidgets(5)); // 5 fields for Edit
    expect(find.text('Yamaha'), findsOneWidget);
    expect(find.text('R15'), findsOneWidget);
  });
}
