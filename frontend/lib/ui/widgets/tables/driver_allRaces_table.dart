import 'package:flutter/material.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/core/services/API_service.dart';
import 'package:frontend/ui/screens/races/races_detail_screen.dart';
import 'package:frontend/ui/theme.dart';

class DriverAllRacesTableScreen extends StatelessWidget {
  const DriverAllRacesTableScreen({Key? key, required this.data})
      : super(key: key);

  final List<dynamic> data;

  @override
  Widget build(BuildContext context) {
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
                      'Race',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Qualifying',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Grid',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Result',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
                rows: data.map((race) {
                  return DataRow(cells: [
                    DataCell(
                      GestureDetector(
                        onTap: () async {
                          // Navigate to the race details screen
                          int year = int.parse(race['year']);
                          int round = int.parse(race['round']);

                          Map<String, dynamic> json =
                              await APIService().getRaceInfo(year, round);
                          Race r = Race.fromJson(json);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RacesDetailScreen(race: r)),
                          );
                        },
                        child: Text(
                          race['race_name'],
                          style: const TextStyle(
                              color: primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataCell(
                      _buildPositionContainer(race['qualifying_position']),
                    ),
                    DataCell(
                      Text(
                        race['grid'],
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    DataCell(
                      _buildPositionContainer(race['result']),
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
          position.toString(),
          style: TextStyle(color: pos <= 3 ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
