import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/models/league.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/screens/game/ranking_league_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/dialogs/create_league_dialog.dart';
import 'package:frontend/ui/widgets/dialogs/join_league_dialog.dart';
import 'package:frontend/ui/widgets/dialogs/log_in_dialog.dart';
import 'package:frontend/ui/widgets/log_in_container.dart';
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
  late Future<List<League>> _leaguesFuture;
  bool firstTime = true;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthService>(context, listen: false);

    if (auth.status == Status.Authenticated && auth.userApp != null) {
      _leaguesFuture = _fetchUserLeagues(auth.userApp!.id);
      firstTime = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<League>> _fetchUserLeagues(String userId) async {
    try {
      // Fetch user's leagues from Firestore
      QuerySnapshot userLeaguesSnapshot = await FirebaseFirestore.instance
          .collection('userLeagues')
          .where('userId', isEqualTo: userId)
          .get();

      List<League> leagues = [];

      for (var doc in userLeaguesSnapshot.docs) {
        String leagueId = doc['leagueId'];

        // Fetch league details for each leagueId
        DocumentSnapshot leagueSnapshot = await FirebaseFirestore.instance
            .collection('leagues')
            .doc(leagueId)
            .get();

        if (leagueSnapshot.exists) {
          leagues.add(League.fromMap(
            leagueSnapshot.data() as Map<String, dynamic>,
          ));
        }
      }

      return leagues;
    } catch (e) {
      print("Error fetching leagues: $e");
      throw Exception("Failed to load leagues");
    }
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
            child: Consumer<AuthService>(
              builder: (context, auth, child) {
                if (auth.status == Status.Authenticated &&
                    auth.userApp != null) {
                  if (firstTime) {
                    _leaguesFuture = _fetchUserLeagues(auth.userApp!.id);
                    firstTime = false;
                  }
                  //userInfo = auth.userApp!;
                  return FutureBuilder<List<League>>(
                    future: _leaguesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'An error occurred',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        List<League> leagues = snapshot.data!;
                        return Column(
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
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RankingLeagueScreen(
                                            league: leagues[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            leagues[index].name,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                leagues[index]
                                                    .userIds
                                                    .length
                                                    .toString(),
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
                                        ],
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
                                          WidgetStateProperty.all<Color>(
                                              secondary),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      bool hasCreated = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CreateLeagueDialog();
                                        },
                                      );
                                      if (hasCreated) {
                                        setState(() {
                                          _leaguesFuture = _fetchUserLeagues(
                                              auth.userApp!.id);
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0),
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
                                          WidgetStateProperty.all<Color>(
                                              secondary),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      bool hasJoined = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return JoinLeagueDialog();
                                        },
                                      );
                                      if (hasJoined) {
                                        setState(() {
                                          _leaguesFuture = _fetchUserLeagues(
                                              auth.userApp!.id);
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0),
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
                        );
                      }
                    },
                  );
                } else {
                  return LogInContainer(isMobile: isMobile);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
