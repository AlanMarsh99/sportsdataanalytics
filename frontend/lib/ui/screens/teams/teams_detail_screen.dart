import 'package:flutter/material.dart';
import 'package:frontend/core/models/team.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/tables/team_seasons_table.dart';

class TeamsDetailScreen extends StatefulWidget {
  const TeamsDetailScreen(
      {Key? key, required this.team, required this.teamsSeason})
      : super(key: key);

  final Team team;
  final List<Team> teamsSeason;

  _TeamsDetailScreenState createState() => _TeamsDetailScreenState();
}

class _TeamsDetailScreenState extends State<TeamsDetailScreen> {
  Team? selectedTeam;

  @override
  void initState() {
    super.initState();
    selectedTeam = widget.team;
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
                  const Text(
                    'TEAMS',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  _buildTeamDropdown(),
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
                      //padding: EdgeInsets.only(left: 6),
                      labelColor: redAccent,
                      unselectedLabelColor: Colors.white,
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
                  Container(
                    height: 250,
                    child: TabBarView(
                      children: [
                        _buildCareerStats(),
                        _buildCareerStats(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'SEASONS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),
                  Container(
                    height: 400,
                    child: Center(
                      child: TeamSeasonsTable(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamDropdown() {
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
  }

  Widget _buildCareerStats() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _buildStatCard(368, selectedTeam!.totalRaces, 'WINS', true),
            ),
            SizedBox(width: 16),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _buildStatCard(584, selectedTeam!.totalRaces, 'PODIUMS', true),
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
              child: _buildStatCard(selectedTeam!.championshipsWins, selectedTeam!.championshipsParticipated, 'CHAMPIONSHIPS', false),
            ),
            SizedBox(width: 16),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _buildStatCard(683, selectedTeam!.totalRaces, 'POLE POSITIONS', false),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(int stat, int total, String label, bool hasPercentage) {
    int percentage = (stat * 100 / total).truncate();
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
                visible: hasPercentage,
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
