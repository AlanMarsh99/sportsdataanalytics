import 'package:flutter/material.dart';
import 'package:frontend/core/models/team.dart';
import 'package:frontend/core/services/API_service.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/tables/team_seasons_table.dart';

class TeamsDetailScreen extends StatefulWidget {
  const TeamsDetailScreen(
      {Key? key, required this.teamId, required this.teamName})
      : super(key: key);

  final String teamId;
  final String teamName;

  _TeamsDetailScreenState createState() => _TeamsDetailScreenState();
}

class _TeamsDetailScreenState extends State<TeamsDetailScreen> {
  late Future<Map<String, dynamic>> _teamStatsFuture;

  @override
  void initState() {
    super.initState();
    // Get the team info by the id and current year
    _teamStatsFuture =
        APIService().getTeamStats(widget.teamId, DateTime.now().year);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Container(
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 10),
                    child: Row(
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
                        const SizedBox(width: 10),
                        Text(
                          widget.teamName.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  //const SizedBox(height: 16),
                  //_buildTeamDropdown(),
                  const SizedBox(height: 40),
                  const Text(
                    'STATISTICS',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const TabBar(
                      labelColor: redAccent,
                      unselectedLabelColor: Colors.white,
                      unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      indicatorColor: redAccent,
                      dividerHeight: 0,
                      isScrollable: true,
                      tabs: [
                        Tab(text: "All time"),
                        Tab(text: "Current season"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // TabBarView for the content of each tab
                  FutureBuilder<Map<String, dynamic>>(
                    future: _teamStatsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ); // Show loading while fetching
                      } else if (snapshot.hasError) {
                        return const Text(
                          'Error: Failed to load team stats',
                          style: TextStyle(color: Colors.white),
                        ); // Error handling
                      } else if (snapshot.hasData) {
                        Map<String, dynamic> data = snapshot.data!;

                        return Container(
                          height: 250,
                          child: TabBarView(
                            children: [
                              _buildCareerStats(true, data),
                              _buildCareerStats(false, data),
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'SEASONS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),
                  FutureBuilder<Map<String, dynamic>>(
                    future: _teamStatsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ); // Show loading while fetching
                      } else if (snapshot.hasError) {
                        return const Text(
                          'Error: Failed to load team stats',
                          style: TextStyle(color: Colors.white),
                        ); // Error handling
                      } else if (snapshot.hasData) {
                        Map<String, dynamic> data = snapshot.data!;

                        return Center(
                          child: TeamSeasonsTable(
                              seasonsData: data['season_results']),
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*Widget _buildTeamDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<Team>(
        value: selectedTeam,
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: const SizedBox(),
        items: widget.teamsSeason.map<DropdownMenuItem<Team>>((Team team) {
          return DropdownMenuItem<Team>(
            value: team,
            child: Text(
              team.name,
              style: TextStyle(color: Colors.black),
            ), // Display the team name
          );
        }).toList(),
        onChanged: (Team? newValue) {
          setState(() {
            selectedTeam = newValue;
          });
        },
      ),
    );
  }*/

  Widget _buildCareerStats(bool allTime, Map<String, dynamic>? driversStats) {
    int wins = 0;
    int races = 0;
    int podiums = 0;
    int championships = 0;
    int polePositions = 0;

    if (allTime) {
      wins = driversStats!['all_time_stats']['total_wins'];
      races = driversStats!['all_time_stats']['total_races'];
      podiums = driversStats!['all_time_stats']['total_podiums'];
      championships = driversStats!['all_time_stats']['total_championships'];
      polePositions = driversStats!['all_time_stats']['total_pole_positions'];
    } else {
      wins = driversStats!['current_season_stats']['wins'];
      races = driversStats!['current_season_stats']['num_races'];
      podiums = driversStats!['current_season_stats']['podiums'];
      polePositions = driversStats!['current_season_stats']['pole_positions'];
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _buildStatCard(wins, races, 'WINS', true),
            ),
            const SizedBox(width: 16),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _buildStatCard(podiums, races, 'PODIUMS', true),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _buildStatCard(championships, 10, 'CHAMPIONSHIPS', false),
            ),
            const SizedBox(width: 16),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child:
                  _buildStatCard(polePositions, races, 'POLE POSITIONS', false),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(int stat, int total, String label, bool hasPercentage) {
    int percentage = -1;
    try {
      percentage = ((stat / total) * 100).round();
    } catch (e) {
      print('Error calculating percentage: $e');
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
              Text(
                '/$total',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
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
          ),
        ],
      ),
    );
  }
}
