import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/ui/screens/game/ranking_league_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class GameLeaguesScreen extends StatefulWidget {
  const GameLeaguesScreen({
    Key? key,
  }) : super(key: key);

  _GameLeaguesScreenState createState() => _GameLeaguesScreenState();
}

class _GameLeaguesScreenState extends State<GameLeaguesScreen> {
  List<Map<String, dynamic>> leagues = [
    {"id": 1, "name": "TUD", "members": 8},
    {"id": 2, "name": "FAMILY", "members": 5},
    {"id": 3, "name": "FERRARI LEAGUE", "members": 40},
  ];

  @override
  void initState() {
    super.initState();
    /*final provider = Provider.of<NavigationProvider>(context, listen: false);
    if (!provider.userAuthenticated) {
      leagues = [];
    }*/
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GAME',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _leaguesContainer(),
          ),
        ],
      ),
    );
  }

  Widget _leaguesContainer() {
    return Container(
      width: double.infinity, //MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "LEAGUE NAME",
                style: TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 48),
                child: Text(
                  "MEMBERS",
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: leagues.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RankingLeagueScreen(
                          leagueId: leagues[index]["leagueId"].toString(),
                          leagueName: leagues[index]["name"],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        leagues[index]["name"],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            leagues[index]["members"].toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 30),
                          const Icon(Icons.chevron_right, color: secondary, size: 28,),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Add create league functionality
                  },
                  child: const Text(
                    'CREATE LEAGUE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Add join league functionality
                  },
                  child: const Text(
                    'JOIN LEAGUE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
