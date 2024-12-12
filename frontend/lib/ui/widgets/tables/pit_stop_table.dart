import 'package:flutter/material.dart';
import 'package:frontend/ui/responsive.dart';
import '/core/models/pit_stops.dart';

class PitStopsTable extends StatefulWidget {
  final PitStopDataResponse data;

  const PitStopsTable({Key? key, required this.data}) : super(key: key);

  @override
  State<PitStopsTable> createState() => _PitStopsTableState();
}

class _PitStopsTableState extends State<PitStopsTable> {
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    return Scrollbar(
      controller: _verticalScrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _verticalScrollController,
        scrollDirection: Axis.vertical,
        child: Scrollbar(
          controller: _horizontalScrollController,
          thumbVisibility: true,
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
                rows: _buildRows(widget.data, isMobile),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _getColumns(bool isMobile) {
    return [
      const DataColumn(
        label: Text(
          'Driver',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          'Team',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          'Lap',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          'Duration(s)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      if (!isMobile)
        const DataColumn(
          label: Text(
            'Time of day',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
    ];
  }

  List<DataRow> _buildRows(PitStopDataResponse data, bool isMobile) {
    List<DataRow> rows = [];
    for (var driver in data.drivers) {
      for (var stop in driver.stops) {
        rows.add(
          DataRow(
            cells: [
              DataCell(SizedBox(
                width: isMobile ? 80 : null,
                child: Text(
                  _capitaliseLastName(driver.driver),
                  style: const TextStyle(color: Colors.black),
                ),
              )),
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
                  stop.duration.toStringAsFixed(3),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              if (!isMobile)
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
    List<String> parts = name.split(' ');
    if (parts.length > 1) {
      String lastName = parts.last;
      lastName = lastName[0].toUpperCase() + lastName.substring(1).toLowerCase();
      return '${parts.first} $lastName';
    } else {
      return name[0].toUpperCase() + name.substring(1).toLowerCase();
    }
  }
}
