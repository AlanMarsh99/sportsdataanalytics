class DriverPosition {
  final String driverId;
  final String driverName;
  final List<int?> positions;

  DriverPosition({
    required this.driverId,
    required this.driverName,
    required this.positions,
  });

  factory DriverPosition.fromJson(Map<String, dynamic> json) {
    return DriverPosition(
      driverId: json['driver_id'],
      driverName: json['driver_name'],
      positions: List<int?>.from(json['positions'].map((x) => x)),
    );
  }
}
