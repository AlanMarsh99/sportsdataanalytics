import 'package:flutter/material.dart';
import 'package:frontend/core/models/result.dart';
import 'package:frontend/ui/responsive.dart';
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

  // Scroll controllers for the vertical and horizontal scrollbars
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    results = widget.data.map((json) => Result.fromJson(json)).toList();
    filteredResultsList = List.from(results);
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
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
    bool isMobile = Responsive.isMobile(context);

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
            controller: _verticalScrollController,
            child: SingleChildScrollView(
              controller: _verticalScrollController,
              scrollDirection: Axis.vertical,
              child: Scrollbar(
                thumbVisibility: true,
                controller: _horizontalScrollController,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: DataTable(
                      columnSpacing: isMobile ? 15 : 56,
                      columns: _getColumns(isMobile),
                      rows: filteredResultsList.map((result) {
                        return DataRow(
                          cells: _getCells(result, isMobile),
                        );
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

  List<DataColumn> _getColumns(bool isMobile) {
    return [
      const DataColumn(
        label: Text(
          'Position',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      const DataColumn(
        label: Text(
          'Driver',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      if (!isMobile)
        const DataColumn(
          label: Text(
            'Team',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      const DataColumn(
        label: Text(
          'Time',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      if (!isMobile)
        const DataColumn(
          label: Text(
            'Grid',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      if (!isMobile)
        const DataColumn(
          label: Text(
            'Laps',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      const DataColumn(
        label: Text(
          'Points',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    ];
  }

  List<DataCell> _getCells(Result result, bool isMobile) {
    return [
      DataCell(_buildPositionContainer(result.position)),
      DataCell(
        // Wrap with Align to left-align the content
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: isMobile ? 90 : null,
            child: TextButton(
              onPressed: () {
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
                overflow: TextOverflow.ellipsis, // Prevent overflow
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: isMobile ? 12 : 14, // Conditional font size
                ),
              ),
            ),
          ),
        ),
      ),
      if (!isMobile)
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
      if (!isMobile)
        DataCell(
          Text(
            result.grid.toString(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      if (!isMobile)
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
    ];
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
      width: position == "N/A" ? 40 : 35,
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
