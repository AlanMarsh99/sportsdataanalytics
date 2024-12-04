import 'package:flutter/material.dart';
import 'package:frontend/core/models/result.dart';
import 'package:frontend/ui/screens/drivers/drivers_screen.dart';
import 'package:frontend/ui/theme.dart';

class RaceResultsTable extends StatefulWidget {
  const RaceResultsTable({Key? key, required this.data}) : super(key: key);

  final List<dynamic> data;

  @override
  State<RaceResultsTable> createState() => _RaceResultsTableState();
}

class _RaceResultsTableState extends State<RaceResultsTable> {
  List<Result> results = [];
  List<Result> filteredResultsList = [];
  String filter = '';

  @override
  void initState() {
    super.initState();
    results = widget.data.map((json) => Result.fromJson(json)).toList();
    filteredResultsList = List.from(results);
  }

  void updateFilter(String value) {
    setState(() {
      filter = value.toLowerCase();
      filteredResultsList = results
          .where((race) =>
              race.driver.toLowerCase().contains(filter) ||
              race.team.toLowerCase().contains(filter) ||
              race.laps.toLowerCase().contains(filter))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextField(
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Enter a driver, team, or number of laps',
              hintStyle: TextStyle(color: Colors.white70),
              labelText: 'Filter results',
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
                    //padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: DataTable(
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Position',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Driver',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Team',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Time',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Grid',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Laps',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Points',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ],
                      rows: filteredResultsList.map((result) {
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
                                    builder: (context) => DriversScreen(
                                      driverId: result.driverId,
                                      driverName: result.driver,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                result.driver,
                                style: const TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
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
          ),
        ),
      ],
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
