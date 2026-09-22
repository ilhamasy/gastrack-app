import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:gastrack_app/features/vehicles/presentation/my_vehicles_screen.dart';
import 'package:gastrack_app/features/vehicles/data/vehicle_repository.dart';
import 'package:gastrack_app/features/vehicles/domain/vehicle.dart';

void main() {
  testWidgets('MyVehiclesScreen shows list of vehicles', (tester) async {
    final mockVehicles = [
      Vehicle(
        id: '1',
        userId: '123',
        name: 'My Honda',
        make: 'Honda',
        model: 'CBR',
        variant: '150R',
        year: 2021,
        isPrimary: true,
        currentOdometer: 10000,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehiclesProvider.overrideWith((ref) => Future.value(mockVehicles)),
        ],
        child: MaterialApp(
          home: const MyVehiclesScreen(),
        ),
      ),
    );

    // Initial loading state might be fast, but we pumpAndSettle
    await tester.pumpAndSettle();

    expect(find.text('My Vehicles'), findsOneWidget);
    expect(find.text('My Honda'), findsOneWidget);
    expect(find.text('2021 Honda CBR 150R'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget); // Primary star icon
  });
}
