import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/screens/game/ranking_league_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/dialogs/create_league_dialog.dart';
import 'package:frontend/ui/widgets/dialogs/log_in_dialog.dart';
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
    bool isMobile = Responsive.isMobile(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GAME',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: _leaguesContainer(isMobile),
          )),
        ],
      ),
    );
  }

  Widget _leaguesContainer(bool isMobile) {
    return Container(
      width: double.infinity, //MediaQuery.of(context).size.width * 0.8,

      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/image2_f1.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Semi-transparent overlay to make text readable
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // Content overlaid on top of the image
          Padding(
            padding: const EdgeInsets.all(16),
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 48),
                      child: Text(
                        "MEMBERS",
                        style: TextStyle(
                          color: Colors.white,
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
                                const SizedBox(width: 30),
                                const Icon(
                                  Icons.chevron_right,
                                  color: secondary,
                                  size: 28,
                                ),
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
                      width: isMobile ? 150 : 200,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(secondary),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Provider.of<AuthService>(context, listen: false)
                                      .status ==
                                  Status.Authenticated
                              ? showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CreateLeagueDialog();
                                  },
                                )
                              /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PredictPodiumScreen(),
                        ),
                      )*/
                              : showDialog(
                                  context: context,
                                  builder: (context) {
                                    return LogInDialog();
                                  },
                                );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            'CREATE LEAGUE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 13 : 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: isMobile ? 150 : 200,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(secondary),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Provider.of<AuthService>(context, listen: false)
                                      .status ==
                                  Status.Authenticated
                              ? showDialog(
                                  context: context,
                                  builder: (context) {
                                    return LogInDialog();
                                  },
                                )
                              /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PredictPodiumScreen(),
                        ),
                      )*/
                              : showDialog(
                                  context: context,
                                  builder: (context) {
                                    return LogInDialog();
                                  },
                                );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            'JOIN LEAGUE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 13 : 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
