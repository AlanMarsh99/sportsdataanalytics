import 'package:flutter/material.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/core/providers/data_provider.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/screens/drivers/drivers_screen.dart';
import 'package:frontend/ui/screens/game/predict_podium_screen.dart';
import 'package:frontend/ui/screens/races/races_detail_screen.dart';
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
  Race? lastRaceInfo;
  Color buttonColor = Colors.white;

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
    lastRaceInfo = dataProvider.lastRaceInfo;

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
              child: Responsive.isMobile(context)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HOME',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Flexible(
                              child: Text(
                                'Welcome to RaceVision - your go-to platform for F1 stats, predictions, and interactive analytics!',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Image.asset('assets/logo/formula-1-logo.png',
                                width: 50, fit: BoxFit.cover),
                          ],
                        ),
                        const SizedBox(height: 20),
                        upcomingRaceInfo != null && lastRaceResults != null
                            ? Column(
                                children: [
                                  _countdownContainer(upcomingRaceInfo, true),
                                  const SizedBox(height: 16),
                                  _lastRaceResultsContainer(
                                      lastRaceResults, true)
                                ],
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 16),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HOME',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Flexible(
                              child: Text(
                                'Welcome to RaceVision - your go-to platform for F1 stats, predictions, and interactive analytics!',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Image.asset('assets/logo/formula-1-logo.png',
                                width: 50, fit: BoxFit.cover),
                          ],
                        ),
                        const SizedBox(height: 20),
                        upcomingRaceInfo != null && lastRaceResults != null
                            ? Row(
                                children: [
                                  Flexible(
                                    child: _countdownContainer(
                                        upcomingRaceInfo, false),
                                  ),
                                  const SizedBox(width: 16),
                                  Flexible(
                                    child: _lastRaceResultsContainer(
                                        lastRaceResults, false),
                                  )
                                ],
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 16),
                      ],
                    )),
        ),
      ),
    );
  }

  Widget _buildDriverCard(Map<String, dynamic> fastestLapData) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DriversScreen(
                  driverId: fastestLapData['driver_id'],
                  driverName: fastestLapData['driver_name']),
            ),
          );
        },
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
        trailing: IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios,
            color: secondary,
            size: 20,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DriversScreen(
                    driverId: fastestLapData['driver_id'],
                    driverName: fastestLapData['driver_name']),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPositionContainer(String position) {
    Color color;
    switch (position) {
      case "1":
        color = const Color.fromARGB(255, 220, 148, 4); // 1st position
        break;
      case "2":
        color = const Color.fromARGB(255, 136, 136, 136); // 2nd position
        break;
      case "3":
        color = const Color.fromARGB(255, 106, 74, 62); // 3rd position
        break;
      default:
        color = Colors.transparent; // Default color
        break;
    }

    int pos = 4;

    try {
      pos = int.parse(position);
    } catch (e) {
      print(e);
    }

    return Container(
      width: position == "N/A" ? 42 : 35,
      height: 35,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Text(
          position,
          style: TextStyle(
              color: pos <= 3 ? Colors.white : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPodiumCard(int position, Map<String, dynamic> driverData) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DriversScreen(
                  driverId: driverData['driver_id'],
                  driverName: driverData['driver_name']),
            ),
          );
        },
        leading: _buildPositionContainer(position.toString()),
        title: Text(
          '${driverData['driver_name']}',
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${driverData['team_name']}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios,
            color: secondary,
            size: 20,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DriversScreen(
                    driverId: driverData['driver_id'],
                    driverName: driverData['driver_name']),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _lastRaceResultsContainer(
      Map<String, dynamic> lastRaceResults, bool isMobile) {
    return Container(
      width: double.infinity, //MediaQuery.of(context).size.width * 0.8,
      height: isMobile ? 480 : 480,
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
                MouseRegion(
                  onEnter: (_) => setState(() {
                    buttonColor = Colors.redAccent;
                  }),
                  onExit: (_) => setState(() {
                    buttonColor = Colors.white;
                  }),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Ensures vertical alignment
                    children: [
                      TextButton(
                        onPressed: () {
                          if (lastRaceInfo != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RacesDetailScreen(race: lastRaceInfo!),
                              ),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                        ),
                        child: Text(
                          "View full results",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: buttonColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          if (lastRaceInfo != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RacesDetailScreen(race: lastRaceInfo!),
                              ),
                            );
                          }
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: buttonColor,
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                ),
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

  Widget _countdownContainer(
      Map<String, dynamic> upcomingRaceInfo, bool isMobile) {
    String date = upcomingRaceInfo['date']; // e.g., "2023-08-27"
    String hour = upcomingRaceInfo['hour']; // e.g., "13:00"

    // Convert date and time strings to DateTime object
    DateTime raceDate = DateTime.parse("$date $hour:00");

    String formattedDate = DateFormat('EEEE MMMM d').format(raceDate);
    return Container(
      width: double.infinity, //MediaQuery.of(context).size.width * 0.8,
      height: isMobile ? 350 : 480,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
              padding: const EdgeInsets.all(5),
              child: Text(
                'FORMULA 1 ${upcomingRaceInfo['race_name']}'.toUpperCase(),
                style: const TextStyle(
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
            '$formattedDate at $hour',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 25 : 40),
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
          SizedBox(height: isMobile ? 18 : 25),
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
          SizedBox(height: isMobile ? 25 : 35),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            width: 270,
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
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: isMobile ? 0 : 5.0),
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
    );
  }
}
