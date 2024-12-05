class UserApp {
  String id;
  String username;
  String email;
  String avatar;
  int level;
  int totalPoints;
  int seasonPoints;
  int leaguesWon;
  int leaguesFinished;
  int numPredictions;
  int? predictionPoints;
  bool firstTimeTutorial;
  int? globalLeaderboardWins;
  bool? notifyLeaderboardWin;
  bool? notifyLeagueWin;
  List<String>? leagueNameWin;

  UserApp({
    required this.id,
    required this.username,
    required this.email,
    required this.avatar,
    required this.level,
    required this.totalPoints,
    required this.seasonPoints,
    required this.leaguesWon,
    required this.leaguesFinished,
    required this.numPredictions,
    this.predictionPoints,
    required this.firstTimeTutorial,
    this.globalLeaderboardWins,
    this.notifyLeaderboardWin,
    this.notifyLeagueWin,
    this.leagueNameWin,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar': avatar,
      'level': level,
      'totalPoints': totalPoints,
      'seasonPoints': seasonPoints,
      'leaguesWon': leaguesWon,
      'leaguesFinished': leaguesFinished,
      'numPredictions': numPredictions,
      'firstTimeTutorial': firstTimeTutorial,
      'globalLeaderboardWins': globalLeaderboardWins,
      'notifyLeaderboardWin': notifyLeaderboardWin,
      'notifyLeagueWin': notifyLeagueWin,
      'leagueNameWin': leagueNameWin,
    };
  }

  factory UserApp.fromMap(Map<String, dynamic> map) {
    return UserApp(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      avatar: map['avatar'],
      level: map['level'],
      totalPoints: map['totalPoints'],
      seasonPoints: map['seasonPoints'],
      leaguesWon: map['leaguesWon'],
      leaguesFinished: map['leaguesFinished'],
      numPredictions: map['numPredictions'],
      firstTimeTutorial: map['firstTimeTutorial'] ?? true,
      globalLeaderboardWins: map['globalLeaderboardWins'] ?? 0,
      notifyLeaderboardWin: map['notifyLeaderboardWin'] ?? false,
      notifyLeagueWin: map['notifyLeagueWin'] ?? false,
      leagueNameWin: List<String>.from(map['leagueNameWin'] ?? []),
    );
  }

  @override
  String toString() {
    return 'UserApp(id: $id, name: $username, email: $email, avatar: $avatar, level: $level, totalPoints: $totalPoints, seasonPoints: $seasonPoints,leaguesFinished: $leaguesFinished,leaguesWon: $leaguesWon, numPredictions: $numPredictions)';
  }
}
