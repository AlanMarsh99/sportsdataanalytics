import 'package:flutter/material.dart';
import '/core/models/pit_stops.dart';

class PitStopsTable extends StatelessWidget {
  final PitStopDataResponse data;

  const PitStopsTable({Key? key, required this.data}) : super(key: key);

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
                columnSpacing: 16.0,
                columns: const [
                  DataColumn(
                    label: Text(
                      'Driver',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Team',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Lap',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Duration (s)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Time of day',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
                rows: _buildRows(data),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataRow> _buildRows(PitStopDataResponse data) {
    List<DataRow> rows = [];
    for (var driver in data.drivers) {
      for (var stop in driver.stops) {
        rows.add(
          DataRow(
            cells: [
              DataCell(
                Text(
                  _capitaliseLastName(driver.driver), // Capitalise only the first letter of the last name
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              DataCell(
                Text(
                  driver.team,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              DataCell(
                Text(
                  stop.lap,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              DataCell(
                Text(
                  stop.duration.toStringAsFixed(3), // Format duration to 3 decimal places
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              DataCell(
                Text(
                  stop.timeOfDay,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      }
    }
    return rows;
  }

  String _capitaliseLastName(String name) {
    // Split the name into parts (assumes "first last" format)
    List<String> parts = name.split(' ');
    if (parts.length > 1) {
      // Capitalise the last name only
      String lastName = parts.last;
      lastName = lastName[0].toUpperCase() + lastName.substring(1).toLowerCase();
      // Recombine with the first name
      return '${parts.first} $lastName';
    } else {
      // If there's only one part, just capitalise the first letter
      return name[0].toUpperCase() + name.substring(1).toLowerCase();
    }
  }
}
