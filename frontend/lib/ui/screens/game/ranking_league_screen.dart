import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/models/league.dart';
import 'package:frontend/core/models/user_app.dart';
import 'package:frontend/ui/screens/game/result_prediction_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:provider/provider.dart';

class RankingLeagueScreen extends StatefulWidget {
  const RankingLeagueScreen({Key? key, required this.league}) : super(key: key);

  final League league;

  _RankingLeagueScreenState createState() => _RankingLeagueScreenState();
}

class _RankingLeagueScreenState extends State<RankingLeagueScreen> {
  List<String> _items = [];
  late Future<List<UserApp>> usersFuture;

  @override
  void initState() {
    super.initState();

    _items = [
      'assets/flags/france.png',
      'assets/flags/germany.png',
      'assets/flags/spain.png',
      'assets/flags/united-states.png',
      'assets/flags/italy.png',
      'assets/flags/united-kingdom.png',
      'assets/flags/france.png',
      'assets/flags/germany.png',
      'assets/flags/spain.png',
      'assets/flags/united-states.png',
      'assets/flags/italy.png',
      'assets/flags/united-kingdom.png',
    ];

    usersFuture = _getUsersLeague();
  }

  @override
  void dispose() {
    super.dispose();
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
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '(League code: ${widget.league.id})',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _leaguesContainer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rankingUserContainer(UserApp user, int index) {
    List<Color> indicators = [
      Colors.green,
      Colors.red,
      Colors.orange,
    ];
    return InkWell(
      onTap: () {
        // Navigate to another screen when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResultPredictionScreen(
                    userId: user.id,
                    raceId: "",
                  )),
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
              backgroundImage: AssetImage('assets/avatars/${user.avatar}.png'),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                user.username.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
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
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.chevron_right,
              color: secondary,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _leaguesContainer() {
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
              Container(
                width: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Add join league functionality
                  },
                  child: const Text(
                    'TOTAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: CarouselSlider(
                  items: _items.map((path) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.asset(
                            path,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    reverse: true,
                    viewportFraction: 0.20,
                    height: 30.0,
                    padEnds: false,
                    enableInfiniteScroll: false,
                    //initialPage: _currentIndex,
                    scrollDirection: Axis.horizontal,
                    /*onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                          _pageController.jumpToPage(index);
                        });
                      },*/
                  ),
                ),
              )
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
          Expanded(
            child: FutureBuilder<List<UserApp>>(
              future: _getUsersLeague(), // Call the function to fetch users
              builder: (context, snapshot) {
                // Check the state of the Future
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting, show a CircularProgressIndicator
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                } else if (snapshot.hasError) {
                  // If there's an error, display an error message
                  return Center(
                    child: Text(
                      'Error loading ranking: ${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // If no data is available, show a message
                  return Center(
                    child: Text(
                      'No users found in this league.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                // If data is available, display the ranking
                List<UserApp> users = snapshot.data!;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return _rankingUserContainer(users[index], index + 1);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
