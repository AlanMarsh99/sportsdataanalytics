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
    );
  }

  @override
  String toString() {
    return 'UserApp(id: $id, name: $username, email: $email, avatar: $avatar, level: $level, totalPoints: $totalPoints, seasonPoints: $seasonPoints,leaguesFinished: $leaguesFinished,leaguesWon: $leaguesWon, numPredictions: $numPredictions)';
  }
}
