import 'package:flutter/material.dart';
import 'package:frontend/core/models/result.dart';
import 'package:frontend/ui/screens/drivers/drivers_screen.dart';
import 'package:frontend/ui/theme.dart';

class RaceResultsTable extends StatelessWidget {
  const RaceResultsTable({Key? key, required this.results}) : super(key: key);

  final List<Result> results;

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
                      'Position',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Driver',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Team',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Time',
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
                      'Laps',
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
                ],
                rows: results.map((result) {
                  return DataRow(cells: [
                    DataCell(
                      _buildPositionContainer(result.position),
                    ),
                    DataCell(
                      TextButton(
                        onPressed: () {
                          // Navigate to the race details screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DriversScreen(/*driver: result.driver*/),
                            ),
                          );
                        },
                        child: Text(
                          result.driver,
                          style: const TextStyle(
                              color: secondary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        result.team,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    DataCell(
                      Text(
                        result.time,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    DataCell(
                      Text(
                        result.grid.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    DataCell(
                      Text(
                        result.laps.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    DataCell(
                      Text(
                        result.points.toString(),
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

  Widget _buildPositionContainer(int position) {
    Color color;
    switch (position) {
      case 1:
        color = const Color.fromARGB(255, 220, 148, 4); // 1st position
        break;
      case 2:
        color = const Color.fromARGB(255, 136, 136, 136); // 2nd position
        break;
      case 3:
        color = const Color.fromARGB(255, 106, 74, 62); // 3rd position
        break;
      default:
        color = Colors.transparent; // Default color
        break;
    }
    return Container(
      width: 35,
      height: 35,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Text(
          position.toString(),
          style: TextStyle(color: position <= 3 ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
