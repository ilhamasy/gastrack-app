class ServiceRecord {
  final String? id;
  final String vehicleId;
  final DateTime serviceDate;
  final int odometerKm;
  final String? workshopName;
  final double totalCost;
  final String? notes;
  final List<ServiceItem> items;

  ServiceRecord({
    this.id,
    required this.vehicleId,
    required this.serviceDate,
    required this.odometerKm,
    this.workshopName,
    this.totalCost = 0.0,
    this.notes,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_id': vehicleId,
      'service_date': serviceDate.toIso8601String(),
      'odometer_km': odometerKm,
      'workshop_name': workshopName,
      'total_cost': totalCost,
      'notes': notes,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}

class ServiceItem {
  final String? id;
  final String? maintenanceId;
  final String itemName;
  final String? brand;
  final String? product;
  final String? partNumber;
  final double quantity;
  final double cost;
  final String? notes;

  ServiceItem({
    this.id,
    this.maintenanceId,
    required this.itemName,
    this.brand,
    this.product,
    this.partNumber,
    this.quantity = 1.0,
    required this.cost,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maintenance_id': maintenanceId,
      'item_name': itemName,
      'brand': brand,
      'product': product,
      'part_number': partNumber,
      'quantity': quantity,
      'cost': cost,
      'notes': notes,
    };
  }
}
