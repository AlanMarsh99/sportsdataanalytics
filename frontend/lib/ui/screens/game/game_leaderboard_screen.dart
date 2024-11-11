import 'package:flutter/material.dart';
import 'package:frontend/core/models/user.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/tables/global_leaderboard_table.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class GameLeaderboardScreen extends StatefulWidget {
  const GameLeaderboardScreen({
    Key? key,
  }) : super(key: key);

  _GameLeaderboardScreenState createState() => _GameLeaderboardScreenState();
}

class _GameLeaderboardScreenState extends State<GameLeaderboardScreen> {
  List<User> _users = [
    User(
      id: 1,
      username: 'brendan',
      totalPoints: 523,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'alanmarsh',
      totalPoints: 342,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'davidst',
      totalPoints: 260,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'alice',
      totalPoints: 41,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'anne',
      totalPoints: 69,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'alex',
      totalPoints: 164,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'user123',
      totalPoints: 186,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'peter',
      totalPoints: 215,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'caroline',
      totalPoints: 132,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'sergio',
      totalPoints: 153,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'paul',
      totalPoints: 190,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'ferrarifan',
      totalPoints: 205,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'andrea',
      totalPoints: 305,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'damian',
      totalPoints: 285,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'sarah',
      totalPoints: 64,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'fidel',
      totalPoints: 240,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'alonso',
      totalPoints: 84,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
    User(
      id: 1,
      username: 'stifnes',
      totalPoints: 220,
      avatarPicture: 'assets/images/placeholder.png',
      numPredictions: 20,
      globalPosition: 12,
      leaguesFinished: 6,
      leaguesWon: 2,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _users.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const  Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Text(
            'GAME',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: _leaderboardContainer(),
          ),
        ),
      ],
    );
  }

  Widget _leaderboardContainer() {
    return Container(
      width: double.infinity, //MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.61,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              //color: secondary,
              border: Border.all(
                color: secondary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'GLOBAL LEADERBOARD 2024 SEASON',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: GlobalLeaderboardTable(
                users: _users,
              ),
            ),
          )
        ],
      ),
    );
  }
}
