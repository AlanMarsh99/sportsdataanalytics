import 'package:flutter/material.dart';
import 'package:frontend/ui/theme.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class GamePredictScreen extends StatefulWidget {
  const GamePredictScreen({
    Key? key,
  }) : super(key: key);

  _GamePredictScreenState createState() => _GamePredictScreenState();
}

class _GamePredictScreenState extends State<GamePredictScreen> {
  late Duration remainingTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    DateTime raceDate =
        DateTime(2024, 10, 27, 18, 0); // Set the race date and time
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'GAME',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: _countdownContainer(),
              ),
            ),
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
            ),),
          ),
          const SizedBox(height: 25),
          const Text(
            'WIN POINTS, BADGES\nAND BE THE TOP IN THE LEADERBOARD!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 35),
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
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            width: 200,
            height: 100,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(secondary),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                ),
              ),
              onPressed: () {},
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
