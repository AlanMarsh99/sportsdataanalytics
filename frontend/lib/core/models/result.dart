class Result {
  String driver;
  String driverId;
  String team;
  String teamId;
  String position;
  String time;
  String grid;
  String laps;
  String points;

  Result({
    required this.driver,
    required this.driverId,
    required this.team,
    required this.teamId,
    required this.position,
    required this.time,
    required this.grid,
    required this.laps,
    required this.points,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      driver: json['driver'],
      driverId: json['driver_id'],
      team: json['team'],
      teamId: json['team_id'],
      position: json['position'],
      time: json['time'],
      grid: json['grid'],
      laps: json['laps'],
      points: json['points'],
    );
  }
}
