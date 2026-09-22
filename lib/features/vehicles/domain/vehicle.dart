class Vehicle {
  final String id;
  final String userId;
  final String name;
  final String make;
  final String model;
  final String variant;
  final int year;
  final bool isPrimary;
  final int currentOdometer;

  Vehicle({
    required this.id,
    required this.userId,
    required this.name,
    required this.make,
    required this.model,
    required this.variant,
    required this.year,
    required this.isPrimary,
    required this.currentOdometer,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      variant: json['variant'] as String? ?? '',
      year: json['year'] as int,
      isPrimary: json['is_primary'] as bool? ?? false,
      currentOdometer: json['current_odometer'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'make': make,
      'model': model,
      'variant': variant,
      'year': year,
      'is_primary': isPrimary,
      'current_odometer': currentOdometer,
    };
  }
}
