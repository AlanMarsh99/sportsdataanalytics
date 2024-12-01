import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/models/lap_data.dart';
import 'package:frontend/core/models/prediction.dart';
import 'package:frontend/core/providers/data_provider.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/screens/game/predict_podium_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/dialogs/log_in_dialog.dart';
import 'package:frontend/ui/widgets/dialogs/view_predictions_dialog.dart';
import 'package:frontend/ui/widgets/level_progress_bar.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class GamePredictScreen extends StatefulWidget {
  const GamePredictScreen({
    Key? key,
  }) : super(key: key);

  _GamePredictScreenState createState() => _GamePredictScreenState();
}

class _GamePredictScreenState extends State<GamePredictScreen> {
  late Duration remainingTime;
  Timer? timer;
  bool firstTime = true;
  DateTime? raceDate;
  late Future<Prediction?> userPredictionFuture;

  @override
  void initState() {
    super.initState();
    userPredictionFuture = Future.value(null);
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  Future<Prediction?> _checkUserPrediction(
      Map<String, dynamic> upcomingRaceInfo) async {
    try {
      final authProvider = Provider.of<AuthService>(context, listen: false);
      if (authProvider.status == Status.Authenticated) {
        int round = int.parse(upcomingRaceInfo!['race_id']);
        int year = int.parse(upcomingRaceInfo['year']);

        // Query Firestore to find if the user has made a prediction for the race
        QuerySnapshot predictionSnapshot = await FirebaseFirestore.instance
            .collection('predictions')
            .where('userId', isEqualTo: authProvider.userApp!.id)
            .where('year', isEqualTo: year)
            .where('round', isEqualTo: round)
            .limit(1)
            .get();

        if (predictionSnapshot.docs.isNotEmpty) {
          // Convert the Firestore document to a Prediction instance
          return Prediction.fromMap(
              predictionSnapshot.docs.first.data() as Map<String, dynamic>);
        }
        return null; // No prediction found
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  void startCountdown(Map<String, dynamic> upcomingRaceInfo) {
    // Parse the date and time from the JSON
    String date = upcomingRaceInfo['date']; // e.g., "2023-08-27"
    String hour = upcomingRaceInfo['hour']; // e.g., "13:00"

    // Convert date and time strings to DateTime object
    raceDate = DateTime.parse("$date $hour:00");
    DateTime deadline = raceDate!.subtract(const Duration(days: 3));

    remainingTime = deadline!.difference(DateTime.now());

    if (remainingTime.isNegative) {
      timer = null;
      setState(() {
        remainingTime =
            const Duration(days: 0, hours: 0, minutes: 0, seconds: 0);
      });
    } else {
      setState(() {
        remainingTime = deadline!.difference(DateTime.now());
      });

      // Set up the timer to update every second
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          remainingTime = deadline!.difference(DateTime.now());
          if (remainingTime.isNegative) {
            remainingTime =
                const Duration(days: 0, hours: 0, minutes: 0, seconds: 0);
            timer.cancel();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    // Access the provider
    final dataProvider = Provider.of<DataProvider>(context);

    // Extract data from provider
    final upcomingRaceInfo = dataProvider.upcomingRaceInfo;

    if (upcomingRaceInfo != null && firstTime) {
      firstTime = false;
      startCountdown(upcomingRaceInfo);
      userPredictionFuture = _checkUserPrediction(upcomingRaceInfo);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'GAME',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Consumer<AuthService>(builder: (context, auth, child) {
                  if (auth.status == Status.Authenticated &&
                      auth.userApp != null) {
                    int pontsToNextLevel =
                        Globals.nextLevelPoints(auth.userApp!.level);
                    return LevelProgressBar(
                      currentLevel: auth.userApp!.level,
                      currentPoints: auth.userApp!.totalPoints,
                      pointsToNextLevel: pontsToNextLevel,
                    );
                  } else {
                    return Container();
                  }
                }),
              ],
            )),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: upcomingRaceInfo == null
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
              : _countdownContainer(upcomingRaceInfo, isMobile),
        ),
      ],
    );
  }

  Widget _buildTimeColumn(String timeValue, String label, bool isMobile) {
    return Column(
      children: [
        Text(
          timeValue,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 24 : 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: const Color.fromARGB(213, 255, 255, 255),
            fontSize: isMobile ? 12 : 16,
          ),
        ),
      ],
    );
  }

  Widget _countdownContainer(
      Map<String, dynamic> upcomingRaceInfo, bool isMobile) {
    return Container(
      width: double.infinity,
      height: isMobile
          ? MediaQuery.of(context).size.height * 0.6
          : MediaQuery.of(context).size.height * 0.6,
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
              'assets/images/image4_f1.jpg',
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: primary.withAlpha(100),
                      border: Border.all(
                        color: secondary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        'FORMULA 1 ${upcomingRaceInfo['race_name']}'
                            .toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 14 : 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'WIN POINTS, BADGES\nAND BE THE TOP IN THE LEADERBOARD!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 20 : 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isMobile ? 30 : 40),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'PREDICTIONS CLOSE IN:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: isMobile ? 12 : 14,
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 18 : 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTimeColumn(
                          remainingTime.inDays.toString().padLeft(2, '0'),
                          'DAYS',
                          isMobile),
                      _buildTimeColumn(
                          remainingTime.inHours
                              .remainder(24)
                              .toString()
                              .padLeft(2, '0'),
                          'HRS',
                          isMobile),
                      _buildTimeColumn(
                          remainingTime.inMinutes
                              .remainder(60)
                              .toString()
                              .padLeft(2, '0'),
                          'MINS',
                          isMobile),
                      _buildTimeColumn(
                          remainingTime.inSeconds
                              .remainder(60)
                              .toString()
                              .padLeft(2, '0'),
                          'SECS',
                          isMobile),
                    ],
                  ),
                  SizedBox(height: isMobile ? 25 : 35),
                  FutureBuilder<Prediction?>(
                    future: userPredictionFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            "Error checking predictions",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      final predictionData = snapshot.data;

                      if (predictionData == null) {
                        DateTime editDeadline =
                            raceDate!.subtract(const Duration(days: 3));
                        DateTime now = DateTime.now();
                        bool canMakePrediction = true;
                        //now.isBefore(editDeadline);

                        // No prediction made
                        return Visibility(
                          visible: canMakePrediction,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            width: isMobile ? 270 : 350,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(secondary),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35.0),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                final authProvider = Provider.of<AuthService>(
                                    context,
                                    listen: false);
                                if (authProvider.status ==
                                    Status.Authenticated) {
                                  try {
                                    int round =
                                        int.parse(upcomingRaceInfo!['race_id']);
                                    int year =
                                        int.parse(upcomingRaceInfo['year']);
                                    Prediction newPrediction = Prediction(
                                      userId: authProvider.userApp!.id,
                                      round: round,
                                      year: year,
                                      raceCountry: upcomingRaceInfo['country'],
                                      raceName: upcomingRaceInfo['race_name'],
                                    );

                                    List<DriverInfo> drivers =
                                        (upcomingRaceInfo['drivers'] as List)
                                            .map((driverJson) =>
                                                DriverInfo.fromJson(driverJson))
                                            .toList();

                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PredictPodiumScreen(
                                          prediction: newPrediction,
                                          drivers: drivers,
                                        ),
                                      ),
                                    );
                                    userPredictionFuture =
                                        _checkUserPrediction(upcomingRaceInfo);
                                  } catch (e) {
                                    print(e);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Error: Could not load prediction data'),
                                        backgroundColor: secondary,
                                      ),
                                    );
                                  }
                                } else {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return LogInDialog();
                                    },
                                  );
                                  userPredictionFuture =
                                      _checkUserPrediction(upcomingRaceInfo);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: isMobile ? 0 : 5.0),
                                child: const Text(
                                  'PLAY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          width: isMobile ? 270 : 350,
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          //width: isMobile ? 270 : 350,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(secondary),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ViewPredictionsDialog(
                                      prediction: predictionData,
                                      raceName: upcomingRaceInfo['race_name']);
                                },
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: isMobile ? 0 : 5.0),
                              child: const Text(
                                "VIEW PREDICTIONS",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
