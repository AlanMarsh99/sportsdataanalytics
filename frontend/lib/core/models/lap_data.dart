class LapDataResponse {
  final List<DriverInfo> drivers;
  final LapData lapData;

  LapDataResponse({required this.drivers, required this.lapData});

  factory LapDataResponse.fromJson(Map<String, dynamic> json) {
    return LapDataResponse(
      drivers: (json['drivers'] as List)
          .map((driverJson) => DriverInfo.fromJson(driverJson))
          .toList(),
      lapData: LapData.fromJson(json['lap_data']),
    );
  }
}

class DriverInfo {
  final String driverId;
  final String driverName;

  DriverInfo({required this.driverId, required this.driverName});

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      driverId: json['driver_id'],
      driverName: json['driver_name'],
    );
  }
}

class LapData {
  final String driverId;
  final String driverName;
  final List<LapInfo> laps;

  LapData({required this.driverId, required this.driverName, required this.laps});

  factory LapData.fromJson(Map<String, dynamic> json) {
    return LapData(
      driverId: json['driver_id'],
      driverName: json['driver_name'],
      laps: (json['laps'] as List)
          .map((lapJson) => LapInfo.fromJson(lapJson))
          .toList(),
    );
  }
}

class LapInfo {
  final int lapNumber;
  final String lapTime;
  final int position;

  LapInfo({required this.lapNumber, required this.lapTime, required this.position});

  factory LapInfo.fromJson(Map<String, dynamic> json) {
    return LapInfo(
      lapNumber: json['lap_number'],
      lapTime: json['lap_time'],
      position: json['position'],
    );
  }
}
