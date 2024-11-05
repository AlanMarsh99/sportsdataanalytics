import 'package:flutter/material.dart';
import 'package:frontend/core/models/driver.dart';
import 'package:frontend/core/providers/data_provider.dart';
import 'package:frontend/ui/screens/game/predict_podium_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    // Access the provider
    final dataProvider = Provider.of<DataProvider>(context);

    // Extract data from provider
    final upcomingRaceInfo = dataProvider.upcomingRaceInfo;

    if (upcomingRaceInfo != null && firstTime) {
      firstTime = false;
      startCountdown(upcomingRaceInfo);
    }

    final lastRaceResults = dataProvider.lastRaceResults;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [darkGradient, lightGradient],
        ),
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RACEVISION',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 16),
                upcomingRaceInfo != null
                    ? _countdownContainer(upcomingRaceInfo)
                    : const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                const SizedBox(height: 16),
                lastRaceResults != null
                    ? _lastRaceResultsContainer(lastRaceResults)
                    : const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDriverCard(Map<String, dynamic> fastestLapData) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.flag, color: secondary),
        title: Text(
          '${fastestLapData['driver_name']}',
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${fastestLapData['team_name']}',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildPodiumCard(int position, Map<String, dynamic> driverData) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.flag, color: secondary),
        title: Text(
          '${driverData['driver_name']}',
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${driverData['team_name']}',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _lastRaceResultsContainer(Map<String, dynamic> lastRaceResults) {
    return Container(
      width: double.infinity, //MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "LAST RACE RESULTS",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "See more",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: redAccent),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Podium",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(color: Colors.white),
            _buildPodiumCard(1, lastRaceResults['first_position']),
            _buildPodiumCard(2, lastRaceResults['second_position']),
            _buildPodiumCard(3, lastRaceResults['third_position']),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Fastest lap",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(color: Colors.white),
            _buildDriverCard(lastRaceResults['fastest_lap']),
          ],
        ),
      ),
    );
  }

  Widget _countdownContainer(Map<String, dynamic> upcomingRaceInfo) {
    String date = upcomingRaceInfo['date']; // e.g., "2023-08-27"
    String hour = upcomingRaceInfo['hour']; // e.g., "13:00"

    // Convert date and time strings to DateTime object
    DateTime raceDate = DateTime.parse("$date $hour:00");

    String formattedDate = DateFormat('EEEE MMMM d \a\t HH:mm z')
        .format(raceDate);
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
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'FORMULA 1 ${upcomingRaceInfo['race_name']}'.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            formattedDate,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'PREDICTIONS CLOSE IN:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    remainingTime.inDays.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'DAYS',
                    style: TextStyle(
                      color: Color.fromARGB(213, 255, 255, 255),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    remainingTime.inHours
                        .remainder(24)
                        .toString()
                        .padLeft(2, '0'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'HRS',
                    style: TextStyle(
                      color: Color.fromARGB(213, 255, 255, 255),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    remainingTime.inMinutes
                        .remainder(60)
                        .toString()
                        .padLeft(2, '0'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'MINS',
                    style: TextStyle(
                      color: Color.fromARGB(213, 255, 255, 255),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    remainingTime.inSeconds
                        .remainder(60)
                        .toString()
                        .padLeft(2, '0'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'SECS',
                    style: TextStyle(
                      color: Color.fromARGB(213, 255, 255, 255),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            width: 200,
            //height: 100,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(secondary),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PredictPodiumScreen(),
                  ),
                );
              },
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
        ],
      ),
    );
  }
}
