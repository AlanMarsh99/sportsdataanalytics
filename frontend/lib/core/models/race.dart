class Race {
  final String date;
  final String raceName;
  final String raceId;
  final String circuitName;
  final String round;
  final String location;
  final String winner;
  final String winnerDriverId;
  final String winningTime;
  final String fastestLap;
  final String fastestLapDriverId;
  final String fastestLapTime;
  final String polePosition;
  final String polePositionDriverId;
  final String fastestPitStopDriverId;
  final String fastestPitStopDriver;
  final String fastestPitStopTime;

  Race({
    required this.date,
    required this.raceName,
    required this.raceId,
    required this.circuitName,
    required this.round,
    required this.location,
    required this.winner,
    required this.winnerDriverId,
    required this.winningTime,
    required this.fastestLap,
    required this.fastestLapDriverId,
    required this.fastestLapTime,
    required this.polePosition,
    required this.polePositionDriverId,
    required this.fastestPitStopDriverId,
    required this.fastestPitStopDriver,
    required this.fastestPitStopTime,
  });

  // A factory constructor to create a Race from a JSON map
  factory Race.fromJson(Map<String, dynamic> json) {
    return Race(
      date: json['date'],
      raceName: json['race_name'],
      raceId: json['race_id'],
      circuitName: json['circuit_name'],
      round: json['round'],
      location: json['location'],
      winner: json['winner'],
      winnerDriverId: json['winner_driver_id'],
      winningTime: json['winning_time'],
      fastestLap: json['fastest_lap'],
      fastestLapDriverId: json['fastest_lap_driver_id'],
      fastestLapTime: json['fastest_lap_time'],
      polePosition: json['pole_position'],
      polePositionDriverId: json['pole_position_driver_id'],
      fastestPitStopDriverId: json['fastest_pit_stop_driver_id'],
      fastestPitStopDriver: json['fastest_pit_stop'],
      fastestPitStopTime: json['fastest_pit_stop_time'],
    );
  }
}
