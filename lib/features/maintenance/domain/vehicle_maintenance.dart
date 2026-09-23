

class VehicleMaintenance {
  final String id;
  final String vehicleId;
  final String name;
  final String? description;
  final int? intervalKm;
  final int? intervalMonths;
  final int? lastServiceKm;
  final DateTime? lastServiceDate;
  final String source; // TEMPLATE, USER_CUSTOMIZED, USER_CREATED

  VehicleMaintenance({
    required this.id,
    required this.vehicleId,
    required this.name,
    this.description,
    this.intervalKm,
    this.intervalMonths,
    this.lastServiceKm,
    this.lastServiceDate,
    required this.source,
  });

  factory VehicleMaintenance.fromJson(Map<String, dynamic> json) {
    return VehicleMaintenance(
      id: json['id'],
      vehicleId: json['vehicle_id'],
      name: json['name'],
      description: json['description'],
      intervalKm: json['interval_km'],
      intervalMonths: json['interval_months'],
      lastServiceKm: json['last_service_km'],
      lastServiceDate: json['last_service_date'] != null ? DateTime.parse(json['last_service_date']) : null,
      source: json['source'] ?? 'TEMPLATE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_id': vehicleId,
      'name': name,
      'description': description,
      'interval_km': intervalKm,
      'interval_months': intervalMonths,
      'last_service_km': lastServiceKm,
      'last_service_date': lastServiceDate?.toIso8601String(),
      'source': source,
    };
  }
}
