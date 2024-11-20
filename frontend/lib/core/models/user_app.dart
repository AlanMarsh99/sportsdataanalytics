class UserApp {
  String id;
  String username;
  String email;
  String avatar;
  int level;
  int totalPoints;
  int leaguesWon;
  int leaguesFinished;
  int numPredictions;

  UserApp({
    required this.id,
    required this.username,
    required this.email,
    required this.avatar,
    required this.level,
    required this.totalPoints,
    required this.leaguesWon,
    required this.leaguesFinished,
    required this.numPredictions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar': avatar,
      'level': level,
      'totalPoints': totalPoints,
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
      leaguesWon: map['leaguesWon'],
      leaguesFinished: map['leaguesFinished'],
      numPredictions: map['numPredictions'],
    );
  }

  @override
  String toString() {
    return 'UserApp(id: $id, name: $username, email: $email, avatar: $avatar, level: $level, totalPoints: $totalPoints, leaguesFinished: $leaguesFinished,leaguesWon: $leaguesWon, numPredictions: $numPredictions)';
  }
}
