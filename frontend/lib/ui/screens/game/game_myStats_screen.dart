import 'package:flutter/material.dart';
import 'package:frontend/core/models/user.dart';
import 'package:frontend/ui/theme.dart';

class GameMyStatsScreen extends StatefulWidget {
  const GameMyStatsScreen({
    Key? key,
  }) : super(key: key);

  _GameMyStatsScreenState createState() => _GameMyStatsScreenState();
}

class _GameMyStatsScreenState extends State<GameMyStatsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  User userInfo = User(
    id: 1,
    username: 'brendan',
    totalPoints: 523,
    avatarPicture: 'assets/images/placeholder.png',
    numPredictions: 20,
    globalPosition: 12,
    leaguesFinished: 6,
    leaguesWon: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'GAME',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 330,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 70,
                            child: Center(
                              child:
                                  Image.asset('assets/images/placeholder.png'),
                            ),
                          ),
                          SizedBox(height: 5),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Change avatar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatCard(userInfo.globalPosition, null,
                        'GLOBAL POSITION', false),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                height: 330,
                child: Column(
                  children: [
                    _buildStatCard(
                        userInfo.totalPoints, null, 'TOTAL POINTS', false),
                    SizedBox(
                      height: 15,
                    ),
                    _buildStatCard(userInfo.leaguesWon,
                        userInfo.leaguesFinished, 'LEAGUE WINS', true),
                    SizedBox(
                      height: 15,
                    ),
                    _buildStatCard(
                        userInfo.numPredictions, null, 'PREDICTIONS', false),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child:
              const Text(
                'BADGES',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),),
              const SizedBox(height: 5),
              Divider(
                color: Colors.white,
                thickness: 1,
              ),
              
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    int stat,
    int? total,
    String label,
    bool hasPercentage,
  ) {
    int percentage = 0;
    if (hasPercentage) {
      percentage = (stat * 100 / total!).truncate();
    }
    return Container(
      width: 155,
      height: 100,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                stat.toString(),
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Visibility(
                visible: total != null,
                child: Text(
                  '/$total',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
              ),
              Visibility(
                visible: hasPercentage,
                child: const SizedBox(width: 10),
              ),
              Visibility(
                visible: hasPercentage,
                child: Text(
                  '($percentage %)',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: redAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
