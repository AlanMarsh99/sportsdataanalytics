import 'package:flutter/material.dart';
import 'package:frontend/core/models/team.dart';
import 'package:frontend/ui/screens/teams/teams_detail_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/core/constants/team_assets.dart';

class TeamsSeasonTable extends StatelessWidget {
  const TeamsSeasonTable({Key? key, required this.data}) : super(key: key);

  final List<dynamic> data;

  // Add the mapping and functions here
  static const Map<String, String> teamNameMapping = {
    'Red Bull Racing': 'Red Bull',
    'Scuderia Ferrari': 'Ferrari',
    'Mercedes AMG Petronas': 'Mercedes',
    'McLaren F1 Team': 'McLaren',
    'Aston Martin': 'Aston Martin',
    'Alpine F1 Team': 'Alpine F1 Team',
    'Williams Racing': 'Williams',
    'Haas F1 Team': 'Haas F1 Team',
    'Alfa Romeo': 'Sauber',
    'AlphaTauri': 'RB F1 Team',
    // Add other mappings as needed
  };

  static String getMappedTeamName(String apiTeamName) {
    return teamNameMapping[apiTeamName] ?? apiTeamName;
  }

  static String? getBadgePath(String teamName) {
    String mappedName = getMappedTeamName(teamName);
    return teamBadges[mappedName] ?? 'assets/teams/logos/placeholder.png';
  }
  // End of added mapping and functions

  @override
  Widget build(BuildContext context) {
    List<Team> teams = data.map((json) => Team.fromJson(json)).toList();
    return Scrollbar(
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
                rows: teams.map((team) {
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
                              ),
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
    );
  }
}