class PitStopDataResponse {
  final List<PitStopDriverData> drivers;

  PitStopDataResponse({required this.drivers});

  factory PitStopDataResponse.fromJson(List<dynamic> json) {
    return PitStopDataResponse(
      drivers: json.map((e) => PitStopDriverData.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'drivers': drivers.map((e) => e.toJson()).toList(),
    };
  }
}

// Model for each driver
class PitStopDriverData {
  final String driver;
  final String team;
  final String teamId;
  final double totalDuration;
  final List<PitStop> stops;

  PitStopDriverData({
    required this.driver,
    required this.team,
    required this.teamId,
    required this.totalDuration,
    required this.stops,
  });

  factory PitStopDriverData.fromJson(Map<String, dynamic> json) {
    return PitStopDriverData(
      driver: json['driver'],
      team: json['team'],
      teamId: json['team_id'],
      totalDuration: (json['total_duration'] as num).toDouble(),
      stops: (json['stops'] as List<dynamic>)
          .map((stop) => PitStop.fromJson(stop))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver': driver,
      'team': team,
      'team_id': teamId,
      'total_duration': totalDuration,
      'stops': stops.map((stop) => stop.toJson()).toList(),
    };
  }
}

// Model for each pit stop
class PitStop {
  final double duration;
  final String lap;
  final String timeOfDay;

  PitStop({
    required this.duration,
    required this.lap,
    required this.timeOfDay,
  });

  factory PitStop.fromJson(Map<String, dynamic> json) {
    return PitStop(
      duration: (json['duration'] as num).toDouble(),
      lap: json['lap'],
      timeOfDay: json['time_of_day'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'lap': lap,
      'time_of_day': timeOfDay,
    };
  }
}
