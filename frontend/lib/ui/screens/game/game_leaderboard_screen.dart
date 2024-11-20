import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/models/user.dart';
import 'package:frontend/core/models/user_app.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/tables/global_leaderboard_table.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class GameLeaderboardScreen extends StatefulWidget {
  const GameLeaderboardScreen({
    Key? key,
  }) : super(key: key);

  _GameLeaderboardScreenState createState() => _GameLeaderboardScreenState();
}

class _GameLeaderboardScreenState extends State<GameLeaderboardScreen> {
  List<User> _users = [];
  late Future<List<UserApp>> _fetchUsersFuture;

  @override
  void initState() {
    super.initState();
    _fetchUsersFuture = _fetchUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<UserApp>> _fetchUsers() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      // Map Firestore documents to the User model
      final users = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return UserApp.fromMap(data);
      }).toList();

      // Sort users by total points (descending order)
      users.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

      return users;
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
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
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: FutureBuilder<List<UserApp>>(
              future: _fetchUsersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator while waiting for data
                  return const CircularProgressIndicator(
                    color: Colors.white,
                  );
                } else if (snapshot.hasError) {
                  // Show an error message if something goes wrong
                  return const Text(
                    'Error loading leaderboard.',
                    style: TextStyle(color: Colors.white),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Handle the case when no users are found
                  return const Text(
                    'No leaderboard data available.',
                    style: TextStyle(color: Colors.white),
                  );
                } else {
                  // Render the leaderboard container with the fetched users
                  List<UserApp> users = snapshot.data!;
                  return _leaderboardContainer(users, isMobile);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _leaderboardContainer(List<UserApp> users, bool isMobile) {
    return Container(
      width: double.infinity, //MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.61,
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
              'assets/images/image5_f1.jpg',
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
                      'GLOBAL LEADERBOARD 2024 SEASON',
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
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: GlobalLeaderboardTable(
                      users: users,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
