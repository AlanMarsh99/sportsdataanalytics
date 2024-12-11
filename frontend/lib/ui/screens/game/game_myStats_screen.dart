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

  _GameMyStatsScreenState createState() => _GameMyStatsScreenState();
}

class _GameMyStatsScreenState extends State<GameMyStatsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late UserApp userInfo;

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          ),
        ),
        Consumer<AuthService>(
          builder: (context, auth, child) {
            if (auth.status == Status.Authenticated && auth.userApp != null) {
              userInfo = auth.userApp!;
              return  Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
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

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, bottom: 16.0, left: 16.0, right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 330,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
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
                                    _buildStatCard(
                                        1, null, 'GLOBAL POSITION', false),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
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
                                    _buildStatCard(userInfo.numPredictions,
                                        null, 'PREDICTIONS', false),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        /*const SizedBox(
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
                  ),*/
                      ],
                    )
                  ],
                ),
              ),);
            } else {
              return Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
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

                      LogInContainer(isMobile: isMobile),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildStatCard(
    int stat,
    int? total,
    String label,
    bool hasPercentage,
  ) {
    int percentage = 0;
    try {
      if (hasPercentage) {
        percentage = (stat * 100 / total!).truncate();
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
              Visibility(
                visible: total != null,
                child: Text(
                  '/$total',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
              ),
              Visibility(
                visible: hasPercentage,
                child: const SizedBox(width: 10),
              ),
              Visibility(
                visible: hasPercentage && percentage != -1,
                child: Text(
                  '($percentage %)',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: redAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
