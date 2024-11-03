import 'package:flutter/material.dart';
import 'package:frontend/core/models/driver.dart';
import 'package:frontend/ui/screens/game/predict_podium_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Duration remainingTime;
  late Timer timer;

  List<Driver> podiumDrivers = [
    Driver(
      id: 1,
      name: "Max Verstappen",
      totalWins: 50,
      totalPodiums: 85,
      totalChampionships: 2,
      totalPolePositions: 30,
      seasonWins: 10,
      seasonPodiums: 15,
      seasonChampionships: 1,
      seasonPolePositions: 8,
      teamId: "Red Bull Racing",
    ),
    Driver(
      id: 2,
      name: "Lewis Hamilton",
      totalWins: 103,
      totalPodiums: 182,
      totalChampionships: 7,
      totalPolePositions: 103,
      seasonWins: 5,
      seasonPodiums: 10,
      seasonChampionships: 0,
      seasonPolePositions: 4,
      teamId: "Mercedes",
    ),
    Driver(
      id: 3,
      name: "Charles Leclerc",
      totalWins: 5,
      totalPodiums: 23,
      totalChampionships: 0,
      totalPolePositions: 10,
      seasonWins: 2,
      seasonPodiums: 5,
      seasonChampionships: 0,
      seasonPolePositions: 3,
      teamId: "Ferrari",
    ),
  ];

  Driver fastestLapDriver = Driver(
    id: 4,
    name: "Lando Norris",
    totalWins: 0,
    totalPodiums: 9,
    totalChampionships: 0,
    totalPolePositions: 0,
    seasonWins: 0,
    seasonPodiums: 4,
    seasonChampionships: 0,
    seasonPolePositions: 0,
    teamId: "McLaren",
  );

  @override
  void initState() {
    super.initState();
    DateTime raceDate =
        DateTime(2024, 11, 27, 18, 0); // Set the race date and time
    remainingTime = raceDate.difference(DateTime.now());

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
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String days = twoDigits(duration.inDays);
    String hours = twoDigits(duration.inHours.remainder(24));
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$days:$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
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
                _countdownContainer(),
                const SizedBox(height: 16),
                _lastRaceResultsContainer(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDriverCard(Driver driver) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.flag, color: secondary),
        title: Text(
          driver.name,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          driver.teamId,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _lastRaceResultsContainer() {
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
            _buildDriverCard(podiumDrivers[0]),
            _buildDriverCard(podiumDrivers[1]),
            _buildDriverCard(podiumDrivers[2]),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Fastest lap",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(color: Colors.white),
            _buildDriverCard(fastestLapDriver),
          ],
        ),
      ),
    );
  }

  Widget _countdownContainer() {
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
            child: const Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'FORMULA 1 PIRELLI UNITED STATES GRAND PRIX 2024',
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
          const Text(
            'Sunday October 2 at 14:00 CET',
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

  Widget _buildTutorialButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: 200,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(secondary),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(2),
          child: const Center(
            child: Text(
              'TAKE THE TOUR',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        onPressed: () async {},
      ),
    );
  }

  Widget _buildSkipTextButton() {
    return TextButton(
      onPressed: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ForgotPasswordScreen(),
        //   ),
        // );
      },
      child: const Text(
        'Skip',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontFamily: 'OpenSans',
        ),
      ),
    );
  }
}