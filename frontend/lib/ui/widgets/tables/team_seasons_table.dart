import 'package:flutter/material.dart';
import 'package:frontend/core/models/team_season_result.dart';

class TeamSeasonsTable extends StatelessWidget {
  const TeamSeasonsTable({Key? key, required this.seasonsData})
      : super(key: key);

  final List<dynamic> seasonsData;

  @override
  Widget build(BuildContext context) {
    List<TeamSeasonResult> teamSeasons =
        seasonsData.map((json) => TeamSeasonResult.fromJson(json)).toList();
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              //padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: DataTable(
                /*dataRowColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
        
            return Colors.white;
      
        }),*/
                columns: const [
                  DataColumn(
                    label: Text(
                      'Year',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Position',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Points',
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
                      'Pole positions',
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
                rows: teamSeasons.map((teamSeasonResult) {
                  return DataRow(cells: [
                    DataCell(
                      Text(
                        teamSeasonResult.year,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    DataCell(
                      _buildPositionContainer(teamSeasonResult.position),
                    ),
                    DataCell(
                      Text(
                        teamSeasonResult.points.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    DataCell(
                      Text(
                        teamSeasonResult.wins.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    DataCell(
                      Text(
                        teamSeasonResult.podiums.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    DataCell(
                      Text(
                        teamSeasonResult.polePositions.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    DataCell(
                      Text(
                        teamSeasonResult.driversList.join(', '),
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
          style: TextStyle(color: pos <= 3 ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
