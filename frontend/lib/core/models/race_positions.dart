import 'driver_position.dart';

class RacePositions {
  final List<int> laps;
  final List<DriverPosition> drivers;

  RacePositions({
    required this.laps,
    required this.drivers,
  });

  factory RacePositions.fromJson(Map<String, dynamic> json) {
    return RacePositions(
      laps: List<int>.from(json['laps']),
      drivers: List<DriverPosition>.from(
          json['drivers'].map((x) => DriverPosition.fromJson(x))),
    );
  }
}