import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/models/chat.dart';
import 'package:frontend/core/models/league.dart';
import 'package:frontend/core/models/message.dart';
import 'package:frontend/core/models/prediction.dart';
import 'package:frontend/core/models/race_league.dart';
import 'package:frontend/core/models/user_app.dart';
import 'package:frontend/core/services/chat_service.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/screens/game/chat_screen.dart';
import 'package:frontend/ui/screens/game/result_prediction_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/chat_widget.dart';
import 'package:frontend/ui/widgets/dialogs/leave_league_dialog.dart';
import 'package:provider/provider.dart';

class RankingLeagueScreen extends StatefulWidget {
  const RankingLeagueScreen(
      {Key? key, required this.league, required this.user})
      : super(key: key);

  final League league;
  final UserApp user;

  _RankingLeagueScreenState createState() => _RankingLeagueScreenState();
}

class _RankingLeagueScreenState extends State<RankingLeagueScreen> {
  late Future<Map<String, dynamic>> leagueDataFuture;
  List<RaceLeague> predictionRaces = [];
  RaceLeague? selectedRace;
  bool showTotal = false;
  List<Prediction> predictions = [];
  List<UserApp> usersInfo = [];
  ChatService chatService = ChatService();
  late ChatUser currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = ChatUser(
      firstName: widget.user.username,
      id: widget.user.id,
      profileImage: 'assets/avatars/${widget.user.avatar}.png',
    );
    leagueDataFuture = _fetchLeagueData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchLeagueData() async {
    final users = await _getUsersLeague();
    final predictions = await _getPredictions();

    final races = _extractUniqueRaces(predictions);

    return {
      "users": users,
      "predictions": predictions,
      "races": races,
    };
  }

  Future<List<UserApp>> _getUsersLeague() async {
    try {
      List<UserApp> users = [];
      List<String> userIds = widget.league.userIds;

      // Firestore `whereIn` has a limit of 10. If the list is larger, split it.
      const int batchSize = 10;
      for (int i = 0; i < userIds.length; i += batchSize) {
        // Get a batch of up to `batchSize` IDs
        List<String> batch = userIds.sublist(
          i,
          i + batchSize > userIds.length ? userIds.length : i + batchSize,
        );

        // Query Firestore for users in this batch
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('id', whereIn: batch)
            .get();

        // Map Firestore documents to UserApp objects
        users.addAll(
          snapshot.docs
              .map((doc) => UserApp.fromMap(doc.data() as Map<String, dynamic>))
              .toList(),
        );
      }

      return users;
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<List<Prediction>> _getPredictions() async {
    try {
      final predictionsCollection =
          FirebaseFirestore.instance.collection("predictions");
      final querySnapshot = await predictionsCollection
          .where("userId", whereIn: widget.league.userIds)
          .get();

      List<Prediction> predictions = querySnapshot.docs.map((doc) {
        return Prediction.fromMap(doc.data());
      }).toList();

      return predictions;
    } catch (e) {
      print('Error fetching predictions: $e');
      return [];
    }
  }

  List<RaceLeague> _extractUniqueRaces(List<Prediction> predictions) {
    final raceSet = predictions.map((p) {
      return RaceLeague(
        year: p.year,
        round: p.round,
        country: p.raceCountry!,
        raceName: p.raceName!,
      );
    }).toSet();

    final sortedRaces = raceSet.toList()..sort(RaceLeague.compare);
    if (sortedRaces.isNotEmpty) {
      selectedRace = sortedRaces.last;
    }

    return sortedRaces;
  }

  Widget leaveLeagueButton(bool isMobile) {
    return Container(
      width: isMobile ? 130 : 150,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(secondary),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),
            ),
          ),
        ),
        onPressed: () async {
          bool wantsToLeave = await showDialog(
            context: context,
            builder: (context) {
              return LeaveLeagueDialog(
                  league: widget.league, user: widget.user);
            },
          );

          if (wantsToLeave) {
            Navigator.pop(context);

          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
            'LEAVE LEAGUE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 12 : 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [darkGradient, lightGradient],
        ),
      ),
      child: Scaffold(
        floatingActionButton: isMobile
            ? Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 20),
                child: FloatingActionButton(
                  backgroundColor: secondary,
                  foregroundColor: Colors.white,
                  tooltip: 'Open chat',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          league: widget.league,
                          currentUser: currentUser,
                          chatService: chatService,
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.chat),
                ),
              )
            : null,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    widget.league.name,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '(League code: ${widget.league.id})',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              !isMobile
                  ? Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: FutureBuilder<Map<String, dynamic>>(
                              future: leagueDataFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Error: ${snapshot.error}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  );
                                } else if (!snapshot.hasData) {
                                  return const Center(
                                    child: Text(
                                      'No data available.',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }

                                final data = snapshot.data!;
                                final users = data["users"] as List<UserApp>;
                                predictions =
                                    data["predictions"] as List<Prediction>;
                                predictionRaces =
                                    data["races"] as List<RaceLeague>;

                                return _leaguesContainer(
                                    users, predictions, isMobile);
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          Flexible(
                            flex: 2,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: StreamBuilder<List<Message>>(
                                stream:
                                    chatService.getMessages(widget.league.id),
                                builder: (context, snapshot) {
                                  // Check the stream's state
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: CircularProgressIndicator(
                                          color: primary,
                                        ),
                                      ),
                                    );
                                  }

                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(
                                          'Error: ${snapshot.error}',
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    );
                                  }

                                  List<Message> listMessages = [];

                                  if (snapshot.hasData &&
                                      snapshot.data!.isNotEmpty) {
                                    // Retrieve the list of Message objects
                                    listMessages = snapshot.data!;
                                    listMessages.sort((a, b) =>
                                        b.sentAt!.compareTo(a.sentAt!));
                                  }

                                  // Use a FutureBuilder to handle async message conversion
                                  return FutureBuilder<List<ChatMessage>>(
                                    future:
                                        chatService.generateChatMessagesList(
                                            listMessages, currentUser),
                                    builder: (context, chatSnapshot) {
                                      if (chatSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: primary,
                                          ),
                                        );
                                      }

                                      if (chatSnapshot.hasError) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text(
                                              'Error: ${chatSnapshot.error}',
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        );
                                      }

                                      // Retrieve the list of ChatMessage objects
                                      List<ChatMessage> messages =
                                          chatSnapshot.data ?? [];

                                      // Render DashChat with the messages
                                      return ChatWidget(
                                        messages: messages,
                                        league: widget.league,
                                        chatService: chatService,
                                        currentUser: currentUser,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: FutureBuilder<Map<String, dynamic>>(
                        future: leagueDataFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          } else if (!snapshot.hasData) {
                            return const Center(
                              child: Text(
                                'No data available.',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }

                          final data = snapshot.data!;
                          final users = data["users"] as List<UserApp>;
                          predictions = data["predictions"] as List<Prediction>;
                          predictionRaces = data["races"] as List<RaceLeague>;

                          return _leaguesContainer(
                              users, predictions, isMobile);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rankingUserContainer(UserApp user, int index, bool isMobile) {
    /*List<Color> indicators = [
      Colors.green,
      Colors.red,
      Colors.orange,
    ];*/

    return InkWell(
      onTap: showTotal || user.predictionPoints == -1
          ? null
          : () {
              // Navigate to another screen when the card is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultPredictionScreen(
                    user: user,
                    race: selectedRace!,
                    predictions: predictions,
                    league: widget.league,
                    currentUser: currentUser,
                    chatService: chatService,
                  ),
                ),
              );
            },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(
              '${index}',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.06),
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/avatars/${user.avatar}.png'),
              radius: 20,
            ),
            const SizedBox(width: 10),
            /* Expanded(
              child:*/
            Text(
              user.username.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // ),
            const Spacer(),
            Text(
              showTotal
                  ? user.seasonPoints.toString()
                  : user.predictionPoints != -1
                      ? user.predictionPoints.toString()
                      : "-",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            /*Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  user.seasonPoints.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: indicators.map((color) {
                    return Container(
                      margin: const EdgeInsets.only(left: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),*/
            const SizedBox(width: 10),

            Icon(
              Icons.chevron_right,
              color: user.predictionPoints != -1 && !showTotal
                  ? secondary
                  : Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  int? _getUserPointsForRace({
    required List<Prediction> predictions,
    required String userId,
    required int round,
    required int year,
  }) {
    final prediction = predictions.firstWhereOrNull(
      (p) => p.userId == userId && p.round == round && p.year == year,
    );

    return prediction?.points;
  }

  Widget _leaguesContainer(
      List<UserApp> users, List<Prediction> predictions, bool isMobile) {
    final List<UserApp> rankedUsers = users.map((user) {
      final points = selectedRace != null
          ? _getUserPointsForRace(
              predictions: predictions,
              userId: user.id,
              round: selectedRace!.round,
              year: selectedRace!.year)
          : user.seasonPoints;
      user.predictionPoints = points ?? -1;
      return user;
    }).toList()
      ..sort((a, b) => b.predictionPoints!.compareTo(a.predictionPoints!));

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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  setState(() {
                    showTotal = true;
                    selectedRace = null;
                  });
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: showTotal ? secondary : Colors.transparent,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    border: Border.all(color: secondary, width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: const Text(
                    "TOTAL",
                    style: TextStyle(
                        color: white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(
                width: 20,
              ),
              //Expanded(
              predictionRaces.isNotEmpty
                  ? Expanded(
                      child: CarouselSlider(
                        items: predictionRaces.map((race) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedRace = race;
                                        showTotal = false;
                                      });
                                    },
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              Globals.countryFlags[
                                                      race.country]! ??
                                                  "",
                                              width: 30.0,
                                            ),
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                          ],
                                        ),
                                        if (selectedRace == race)
                                          Container(
                                            width: 40,
                                            height: 4.0,
                                            color: secondary,
                                          ),
                                      ],
                                    ),
                                  ));
                            },
                          );
                        }).toList(),
                        options: CarouselOptions(
                          reverse: false,
                          viewportFraction: 0.20,
                          height: 50.0,
                          padEnds: false,
                          enableInfiniteScroll: false,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "POS",
                      style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05),
                    child: const Text(
                      "DRIVER",
                      style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(right: 45),
                child: Text(
                  "POINTS",
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          //Expanded(
          rankedUsers.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: rankedUsers.length,
                    itemBuilder: (context, index) {
                      return _rankingUserContainer(
                          rankedUsers[index], index + 1, isMobile);
                    },
                  ),
                )
              : const Center(
                  child: Text(
                    'No users available',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
          leaveLeagueButton(isMobile),
        ],
      ),
    );
  }
}
