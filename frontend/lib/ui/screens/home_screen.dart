import 'package:flutter/material.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/core/providers/data_provider.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/screens/drivers/drivers_screen.dart';
import 'package:frontend/ui/screens/game/predict_podium_screen.dart';
import 'package:frontend/ui/screens/races/races_detail_screen.dart';
import 'package:frontend/ui/screens/teams/teams_detail_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/dialogs/log_in_dialog.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Duration remainingTime;
  late Timer timer;
  bool firstTime = true;
  Race? lastRaceInfo;
  Color buttonColor = Colors.white;
  List<dynamic>? driversStandings;
  List<dynamic>? constructorsStandings;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }

  static String getMappedTeamName(String apiTeamName) {
    return Globals.teamNameMapping[apiTeamName] ?? apiTeamName;
  }

  static String? getBadgePath(String teamName) {
    String mappedName = getMappedTeamName(teamName);
    return Globals.teamBadges[mappedName] ??
        'assets/teams/logos/placeholder.png';
  }

  static Color getTeamColour(String teamName) {
    Color teamColor = Globals.teamColors[teamName] ?? Colors.black;
    return teamColor;
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
    driversStandings = dataProvider.driversStandings;
    constructorsStandings = dataProvider.constructorsStandings;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [darkGradient, lightGradient],
        ),
      ),
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Make scaffold background transparent
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
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
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
                                _lastRaceResultsContainer(lastRaceResults, true)
                              ],
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                      const SizedBox(height: 16),
                      _driversStandingsContainer(true),
                      const SizedBox(height: 16),
                      _constructorsStandingsContainer(true),
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
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
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Flexible(
                            child: _driversStandingsContainer(false),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: _constructorsStandingsContainer(false),
                          ),
                        ],
                      )
                    ],
                  ),
          ),
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
      width: double.infinity,
      height: isMobile ? 480 : 482,
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
                Text(
                  "LAST RACE RESULTS",
                  style: TextStyle(
                      fontSize: isMobile ? 14 : 18,
                      fontWeight: FontWeight.bold),
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
                            fontSize: isMobile ? 12 : 14,
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
      width: double.infinity,
      height: isMobile ? 350 : 482,
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
              'assets/images/f1car.jpg',
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
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
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
                const SizedBox(height: 20),
                Text(
                  '$formattedDate at $hour',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 14 : 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 25 : 40),
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
                        'DAYS', isMobile),
                    _buildTimeColumn(
                        remainingTime.inHours
                            .remainder(24)
                            .toString()
                            .padLeft(2, '0'),
                        'HRS', isMobile),
                    _buildTimeColumn(
                        remainingTime.inMinutes
                            .remainder(60)
                            .toString()
                            .padLeft(2, '0'),
                        'MINS', isMobile),
                    _buildTimeColumn(
                        remainingTime.inSeconds
                            .remainder(60)
                            .toString()
                            .padLeft(2, '0'),
                        'SECS', isMobile),
                  ],
                ),
                SizedBox(height: isMobile ? 25 : 35),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  width: 270,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(secondary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Provider.of<AuthService>(context, listen: false).status ==
                              Status.Authenticated
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PredictPodiumScreen(),
                              ),
                            )
                          : showDialog(
                              context: context,
                              builder: (context) {
                                return LogInDialog();
                              },
                            );
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
        ],
      ),
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

  Widget _driversStandingsContainer(bool isMobile) {
    int currentYear = DateTime.now().year;
    return Container(
      width: double.infinity,
      height: isMobile ? 450 : 550,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "DRIVERS' STANDINGS $currentYear",
              style: TextStyle(
                  fontSize: isMobile ? 14 : 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            driversStandings != null
                ? Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: driversStandings!.length,
                      itemBuilder: (context, index) {
                        final driver = driversStandings![index];
                        final teamBadgePath =
                            getBadgePath(driver['constructor_name']);
                        final positionColor =
                            getTeamColour(driver['constructor_name'])
                                .withOpacity(0.5); // Adjusted background color
                        final points = driver['points'];
                        final driverName = driver['driver_name']
                            .split(' ')
                            .last
                            .toUpperCase(); // Show last name

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DriversScreen(
                                    driverId: driver['driver_id'],
                                    driverName: driver['driver_name']),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  positionColor,
                                  Colors.black
                                ], // From blue to black
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Position and Logo
                                Row(
                                  children: [
                                    Container(
                                      width: 25,
                                      child: Text(
                                        driver['position'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Container(
                                      width: isMobile ? 50 : 60,
                                      child: Image.asset(
                                        teamBadgePath!,
                                        height: isMobile ? 20 : 30,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ),
                                // Driver Name
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      driverName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                // Points
                                Text(
                                  points.toString(),
                                  style: TextStyle(
                                    fontSize: isMobile ? 16 : 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _constructorsStandingsContainer(bool isMobile) {
    int currentYear = DateTime.now().year;
    return Container(
      width: double.infinity,
      height: isMobile ? 450 : 550,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CONSTRUCTORS' STANDINGS $currentYear",
              style: TextStyle(
                  fontSize: isMobile ? 14 : 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            constructorsStandings != null
                ? Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: constructorsStandings!.length,
                      itemBuilder: (context, index) {
                        final constructor = constructorsStandings![index];
                        final teamBadgePath =
                            getBadgePath(constructor['constructor_name']);
                        final positionColor =
                            getTeamColour(constructor['constructor_name'])
                                .withOpacity(0.5); // Adjusted background color
                        final points = constructor['points'];
                        final constructorName =
                            constructor['constructor_name'].toUpperCase();

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TeamsDetailScreen(
                                    teamId: constructor['constructor_id'],
                                    teamName: constructor['constructor_name']),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  positionColor,
                                  Colors.black
                                ], // From blue to black
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Position and Logo
                                Row(
                                  children: [
                                    Container(
                                      width: 25,
                                      child: Text(
                                        constructor['position'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Container(
                                      width: isMobile ? 50 : 60,
                                      child: Image.asset(
                                        teamBadgePath!,
                                        height: isMobile ? 20 : 30,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ),
                                // Driver Name
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      constructorName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                // Points
                                Text(
                                  points.toString(),
                                  style: TextStyle(
                                    fontSize: isMobile ? 16 : 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
