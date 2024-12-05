import 'package:flutter/material.dart';
import 'package:frontend/core/models/team.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/ui/screens/teams/teams_detail_screen.dart';
import 'package:frontend/ui/theme.dart';

class TeamsSeasonTable extends StatefulWidget {
  const TeamsSeasonTable({Key? key, required this.data}) : super(key: key);

  final List<dynamic> data;

  @override
  _TeamsSeasonTableState createState() => _TeamsSeasonTableState();
}

class _TeamsSeasonTableState extends State<TeamsSeasonTable> {
  List<Team> teamsList = [];
  List<Team> filteredTeamsList = [];

  @override
  void initState() {
    super.initState();
    teamsList = widget.data.map((json) => Team.fromJson(json)).toList();
    filteredTeamsList = List.from(teamsList);
  }

  static String getMappedTeamName(String apiTeamName) {
    return Globals.teamNameMapping[apiTeamName] ?? apiTeamName;
  }

  static String? getBadgePath(String teamName) {
    String mappedName = getMappedTeamName(teamName);
    return Globals.teamBadges[mappedName] ?? 'assets/teams/logos/placeholder.png';
  }

  void updateFilter(String value) {
    setState(() {
      final filter = value.toLowerCase();
      filteredTeamsList = teamsList.where((team) {
        // Check if the team name matches the filter
        final teamNameMatch = team.name.toLowerCase().contains(filter);
        // Check if any driver in the team matches the filter
        final driversMatch = team.driversList.any((driver) => driver.toLowerCase().contains(filter));
        // Check if wins or podiums match the filter
        final winsMatch = team.yearWins.toString().contains(filter);
        final podiumsMatch = team.yearPodiums.toString().contains(filter);

        return teamNameMatch || driversMatch || winsMatch || podiumsMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filtering TextField
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Enter a team, driver, wins, or podiums',
              hintStyle: const TextStyle(color: Colors.white70),
              labelText: 'Filter teams',
              labelStyle: const TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            onChanged: updateFilter,
          ),
        ),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: DataTable(
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Team',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Wins',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Podiums',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Drivers',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ],
                      rows: filteredTeamsList.map((team) {
                        return DataRow(cells: [
                          DataCell(
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TeamsDetailScreen(
                                      teamId: team.id,
                                      teamName: team.name,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    getBadgePath(team.name)!,
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    team.name,
                                    style: const TextStyle(
                                        color: primary,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              team.yearWins.toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          DataCell(
                            Text(
                              team.yearPodiums.toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          DataCell(
                            Text(
                              team.driversList.join(', '),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
