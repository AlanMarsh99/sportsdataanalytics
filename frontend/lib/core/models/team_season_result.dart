class TeamSeasonResult {
  String year;
  int numRaces;
  int wins;
  int podiums;
  int polePositions;
  String position;
  double points;
  List<String> driversList;

  TeamSeasonResult({
    required this.year,
    required this.numRaces,
    required this.wins,
    required this.podiums,
    required this.polePositions,
    required this.position,
    required this.points,
    required this.driversList,
  });

  // A factory constructor to create a TeamSeasonResult from a JSON map
  factory TeamSeasonResult.fromJson(Map<String, dynamic> json) {
    return TeamSeasonResult(
      driversList: List<String>.from(json['drivers'] as List),
      year: json['year'],
      numRaces: json['num_races'],
      wins: json['wins'],
      podiums: json['podiums'],
      polePositions: json['pole_positions'],
      position: json['position'],
      points: json['points'],
    );
  }
}