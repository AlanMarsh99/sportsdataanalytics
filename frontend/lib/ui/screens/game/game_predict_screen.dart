import 'package:flutter/material.dart';
import 'package:frontend/core/models/lap_data.dart';
import 'package:frontend/core/models/prediction.dart';
import 'package:frontend/core/providers/data_provider.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/screens/game/predict_podium_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/dialogs/log_in_dialog.dart';
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
  late Timer timer;
  bool firstTime = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startCountdown(Map<String, dynamic> upcomingRaceInfo) {
    // Parse the date and time from the JSON
    String date = upcomingRaceInfo['date']; // e.g., "2023-08-27"
    String hour = upcomingRaceInfo['hour']; // e.g., "13:00"

    // Convert date and time strings to DateTime object
    DateTime raceDate = DateTime.parse("$date $hour:00");

    setState(() {
      remainingTime = raceDate.difference(DateTime.now());
    });

    // Set up the timer to update every second
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime = raceDate.difference(DateTime.now());
        if (remainingTime.isNegative) {
          timer.cancel();
        }
      });
    });
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
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Text(
            'GAME',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Center(
            child: upcomingRaceInfo == null
                ? CircularProgressIndicator()
                : _countdownContainer(upcomingRaceInfo, isMobile),
          ),
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
            color: Color.fromARGB(213, 255, 255, 255),
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
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'FORMULA 1 ${upcomingRaceInfo['race_name']}',
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
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    width: isMobile ? 270 : 350,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(secondary),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (Provider.of<AuthService>(context, listen: false)
                                .status ==
                            Status.Authenticated) {
                          Prediction newPrediction = Prediction(
                            userId:
                                Provider.of<AuthService>(context, listen: false)
                                    .user!
                                    .uid,
                            round: upcomingRaceInfo!['round'],
                            year: upcomingRaceInfo['year'],
                          );

                          List<DriverInfo> drivers =
                              (upcomingRaceInfo['drivers'] as List)
                                  .map((driverJson) =>
                                      DriverInfo.fromJson(driverJson))
                                  .toList();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PredictPodiumScreen(
                                prediction: newPrediction,
                                drivers: drivers,
                                raceName: upcomingRaceInfo['race_name'],
                              ),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return LogInDialog();
                            },
                          );
                        }
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: isMobile ? 0 : 5.0),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
