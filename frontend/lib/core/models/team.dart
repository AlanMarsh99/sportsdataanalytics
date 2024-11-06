class Team {
  String id;
  String name;
  int yearWins;
  int yearPodiums;
  List<String> driversList;

  Team({
    required this.id,
    required this.name,
    required this.yearWins,
    required this.yearPodiums,
    required this.driversList,
  });

  // A factory constructor to create a Team from a JSON map
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      driversList: List<String>.from(json['drivers'] as List),
      id: json['team_id'],
      name: json['team_name'],
      yearPodiums: json['year_podiums'],
      yearWins: json['year_wins'],
    );
  }
}
