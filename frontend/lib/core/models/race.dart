class Race {
  int id;
  String name;
  DateTime date;
  String circuit;
  String winner;
  String polePosition;
  String round;
  String location;
  String winningTime;
  String fastestLap;
  String fastestLapTime;
  String fastestPitStop;
  String fastestPitStopTime;
  // List<Results> results;
  // List<Lap> laps;
  // List<Pitstop> pitstops;


  Race(
      {required this.id,
      required this.name,
      required this.date,
      required this.circuit,
      required this.winner,
      required this.polePosition,
      required this.round,
      required this.location,
      required this.winningTime,
      required this.fastestLap,
      required this.fastestLapTime,
      required this.fastestPitStop,
      required this.fastestPitStopTime,
      // required this.results,
      // required this.laps,
      // required this.pitstops,
      });

}
