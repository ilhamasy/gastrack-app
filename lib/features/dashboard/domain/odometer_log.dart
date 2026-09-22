class OdometerLog {
  final String id;
  final String vehicleId;
  final int odometerValue;
  final DateTime recordedAt;

  OdometerLog({
    required this.id,
    required this.vehicleId,
    required this.odometerValue,
    required this.recordedAt,
  });

  factory OdometerLog.fromJson(Map<String, dynamic> json) {
    return OdometerLog(
      id: json['id'] as String,
      vehicleId: json['vehicle_id'] as String,
      odometerValue: json['odometer_value'] as int,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_id': vehicleId,
      'odometer_value': odometerValue,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }
}
