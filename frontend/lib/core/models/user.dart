
class User {
  int id;
  String username;
  //String email;
  int totalPoints;
  String avatarPicture;
  int numPredictions;
  int leaguesFinished;
  int leaguesWon;
  int globalPosition;
  
  


  User(
      {required this.id,
      required this.username,
      //required this.email,
      required this.totalPoints,
      required this.avatarPicture,
      required this.numPredictions,
      required this.leaguesFinished,
      required this.leaguesWon,
      required this.globalPosition,
  

      // required this.results,
      // required this.laps,
      // required this.pitstops,
      });

}