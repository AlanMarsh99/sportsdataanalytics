
class Team {
  int id;
  String name;
  int wins;
  int podiums;
  String drivers;
  int seasonYear;
  int polePositions;
  int points;
  int position;
  int championshipsWins;
  int championshipsParticipated;
  int totalRaces;
  // List<Results> results;
  // List<Lap> laps;
  // List<Pitstop> pitstops;


  Team(
      {required this.id,
      required this.name,
      required this.wins,
      required this.podiums,
      required this.drivers,
      required this.seasonYear,
      required this.polePositions,
      required this.points,
      required this.position,
      required this.championshipsWins,
      required this.championshipsParticipated,
      required this.totalRaces,
      // required this.results,
      // required this.laps,
      // required this.pitstops,
      });

}
