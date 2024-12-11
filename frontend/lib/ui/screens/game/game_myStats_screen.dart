import 'package:flutter/material.dart';
import 'package:frontend/core/models/user_app.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/dialogs/avatar_selection_dialog.dart';
import 'package:frontend/ui/widgets/level_progress_bar.dart';
import 'package:frontend/ui/widgets/log_in_container.dart';
import 'package:provider/provider.dart';

class GameMyStatsScreen extends StatefulWidget {
  const GameMyStatsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _GameMyStatsScreenState createState() => _GameMyStatsScreenState();
}

class _GameMyStatsScreenState extends State<GameMyStatsScreen> {
  late UserApp userInfo;
  late Future<int> _globalPositionFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch global position synchronously
    _globalPositionFuture = _fetchGlobalPosition();
  }

  /// Fetches the global position from AuthService
  Future<int> _fetchGlobalPosition() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    return await authService.getGlobalPosition();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with GAME title and LevelProgressBar
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GAME',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Consumer<AuthService>(builder: (context, auth, child) {
                if (auth.status == Status.Authenticated &&
                    auth.userApp != null) {
                  int pointsToNextLevel =
                      Globals.nextLevelPoints(auth.userApp!.level);
                  return LevelProgressBar(
                    currentLevel: auth.userApp!.level,
                    currentPoints: auth.userApp!.totalPoints,
                    pointsToNextLevel: pointsToNextLevel,
                  );
                } else {
                  return Container();
                }
              }),
            ],
          ),
        ),
        // User Stats Section
        Consumer<AuthService>(
          builder: (context, auth, child) {
            if (auth.status == Status.Authenticated && auth.userApp != null) {
              userInfo = auth.userApp!;
              return FutureBuilder<int>(
                future: _globalPositionFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show loading indicator while fetching
                    return _buildLoadingContainer(isMobile);
                  } else if (snapshot.hasError || snapshot.data == -1) {
                    // Show error message
                    return _buildErrorContainer(isMobile);
                  } else {
                    int globalPosition = snapshot.data!;
                    return _buildStatsContainer(isMobile, globalPosition);
                  }
                },
              );
            } else {
              // Show login prompt if not authenticated
              return _buildLoginPrompt(isMobile);
            }
          },
        ),
      ],
    );
  }

  // Widget to show while loading
  Widget _buildLoadingContainer(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Container(
        width: double.infinity,
        height: isMobile
            ? MediaQuery.of(context).size.height * 0.6
            : MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  // Widget to show on error
  Widget _buildErrorContainer(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Container(
        width: double.infinity,
        height: isMobile
            ? MediaQuery.of(context).size.height * 0.6
            : MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'Error fetching global position',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  // Widget to show the stats including global position
  Widget _buildStatsContainer(bool isMobile, int globalPosition) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Container(
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
                'assets/images/image6_f1.jpg',
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
            // Stats Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Left Column: Avatar and Global Position
                      Container(
                        height: 330,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Avatar Section
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 70,
                                    backgroundImage: AssetImage(
                                        'assets/avatars/${userInfo.avatar}.png'),
                                  ),
                                  const SizedBox(height: 5),
                                  TextButton(
                                    onPressed: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AvatarSelectionDialog(
                                            userApp: userInfo,
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'Change avatar',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Global Position Card
                            _buildStatCard(
                                globalPosition, null, 'GLOBAL POSITION', false),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      // Right Column: Other Stats
                      Container(
                        height: 330,
                        child: Column(
                          children: [
                            _buildStatCard(userInfo.totalPoints, null,
                                'TOTAL POINTS', false),
                            const SizedBox(
                              height: 15,
                            ),
                            _buildStatCard(userInfo.leaguesWon, null,
                                'LEAGUE WINS', false),
                            const SizedBox(
                              height: 15,
                            ),
                            _buildStatCard(userInfo.numPredictions, null,
                                'PREDICTIONS', false),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                /*
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'BADGES',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 5),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
                */
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget to show login prompt
  Widget _buildLoginPrompt(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Container(
        width: double.infinity,
        height: isMobile
            ? MediaQuery.of(context).size.height * 0.5
            : MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            // Background Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/image6_f1.jpg',
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
            // Login Container
            LogInContainer(isMobile: isMobile),
          ],
        ),
      ),
    );
  }

  /// Builds a statistic card with given parameters.
  Widget _buildStatCard(
    int stat,
    int? total,
    String label,
    bool hasPercentage,
  ) {
    int percentage = 0;
    try {
      if (hasPercentage && total != null && total != 0) {
        percentage = (stat * 100 / total).truncate();
      }
    } catch (e) {
      percentage = -1;
      print(e);
    }

    return Container(
      width: 155,
      height: 100,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Stat Number and Optional Total/Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                stat.toString(),
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              if (total != null)
                Text(
                  '/$total',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
              if (hasPercentage && percentage != -1)
                const SizedBox(width: 10),
              if (hasPercentage && percentage != -1)
                Text(
                  '($percentage%)',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: redAccent),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Stat Label
          Text(
            label,
            style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
