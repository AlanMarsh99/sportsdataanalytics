import 'package:flutter/material.dart';
import 'package:frontend/ui/responsive.dart';

class DriverSeasonsTable extends StatefulWidget {
  const DriverSeasonsTable({Key? key, required this.data}) : super(key: key);

  final Map<String, dynamic> data;

  @override
  _DriverSeasonsTableState createState() => _DriverSeasonsTableState();
}

class _DriverSeasonsTableState extends State<DriverSeasonsTable> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  // State variables for sorting
  int? _sortColumnIndex;
  bool _sortAscending = true;

  // Mutable list to hold and sort the season results
  late List<Map<String, dynamic>> _seasonResults;
  List<Map<String, dynamic>> filteredResultsList = [];
  String filter = '';

  @override
  void initState() {
    super.initState();
    // Initialize the mutable list from widget data
    _seasonResults = List<Map<String, dynamic>>.from(
        widget.data['season_results'] as List<dynamic>);
    filteredResultsList = List.from(_seasonResults);
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  void updateFilter(String value) {
    setState(() {
      filter = value.toLowerCase();
      filteredResultsList = _seasonResults.where((result) {
        final matchesYear =
            result['year'].toString().toLowerCase().contains(filter);
        final matchesPosition =
            result['position'].toString().toLowerCase().contains(filter);
        final matchesTeam =
            result['team'].toString().toLowerCase().contains(filter);
        return matchesYear || matchesPosition || matchesTeam;
      }).toList();

      if (_sortColumnIndex != null) {
        _onSort(_sortColumnIndex!, _sortAscending);
      }
    });
  }

  // Sorting function
  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      // Define the list of all possible columns with their keys
      final allColumns = [
        {'label': 'Year', 'key': 'year'},
        {'label': 'Position', 'key': 'position'},
        {'label': 'Points', 'key': 'points'},
        {'label': 'Races', 'key': 'num_races'},
        {'label': 'Wins', 'key': 'wins'},
        {'label': 'Podiums', 'key': 'podiums'},
        {'label': 'Pole Positions', 'key': 'pole_positions'},
        {'label': 'Team(s)', 'key': 'team'},
      ];

      // Determine if we're on mobile to exclude certain columns
      bool isMobile = Responsive.isMobile(context);
      // Filter columns based on screen size
      final visibleColumns = isMobile
          ? allColumns
              .where((col) =>
                  col['label'] != 'Podiums' &&
                  col['label'] != 'Pole Positions' &&
                  col['label'] != 'Team(s)')
              .toList()
          : allColumns;

      // Get the key of the column to sort by
      final sortColumn = visibleColumns[columnIndex]['key'];

      filteredResultsList.sort((a, b) {
        var aValue = a[sortColumn];
        var bValue = b[sortColumn];

        // Handle different data types
        if (sortColumn == 'year' ||
            sortColumn == 'position' ||
            sortColumn == 'num_races' ||
            sortColumn == 'wins' ||
            sortColumn == 'podiums' ||
            sortColumn == 'pole_positions') {
          int aInt = int.tryParse(aValue.toString()) ?? 0;
          int bInt = int.tryParse(bValue.toString()) ?? 0;
          return ascending ? aInt.compareTo(bInt) : bInt.compareTo(aInt);
        } else if (sortColumn == 'points') {
          double aDouble = double.tryParse(aValue.toString()) ?? 0.0;
          double bDouble = double.tryParse(bValue.toString()) ?? 0.0;
          return ascending
              ? aDouble.compareTo(bDouble)
              : bDouble.compareTo(aDouble);
        } else if (sortColumn == 'team') {
          String aStr = aValue.toString();
          String bStr = bValue.toString();
          return ascending
              ? aStr.compareTo(bStr)
              : bStr.compareTo(aStr);
        }
        return 0;
      });
    });
  }

  /// Helper method to determine column spacing based on screen width
  double _getColumnSpacing(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      // Mobile
      return 5.0;
    } else if (screenWidth >= 600 && screenWidth < 1200) {
      // Tablet
      return 30.0;
    } else {
      // Desktop
      return 56.0;
    }
  }

  Widget _buildFilter(bool isMobile) {
    return SizedBox(
      width: isMobile ? double.infinity : 500,
      child: TextField(
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'Enter a year, position or team',
          hintStyle: const TextStyle(color: Colors.white70),
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
    );
  }

  Widget _buildTable(bool isMobile) {
    double columnSpacing = _getColumnSpacing(context);

    // Define all possible columns with their labels and keys
    final allColumns = [
      {'label': 'Year', 'key': 'year', 'numeric': true},
      {'label': 'Position', 'key': 'position', 'numeric': true},
      {'label': 'Points', 'key': 'points', 'numeric': true},
      {'label': 'Races', 'key': 'num_races', 'numeric': true},
      {'label': 'Wins', 'key': 'wins', 'numeric': true},
      {'label': 'Podiums', 'key': 'podiums', 'numeric': true},
      {'label': 'Pole Positions', 'key': 'pole_positions', 'numeric': true},
      {'label': 'Team(s)', 'key': 'team', 'numeric': false},
    ];

    // Filter columns based on screen size
    final visibleColumns = isMobile
        ? allColumns
            .where((col) =>
                col['label'] != 'Podiums' &&
                col['label'] != 'Pole Positions' &&
                col['label'] != 'Team(s)')
            .toList()
        : allColumns;

    return Scrollbar(
      thumbVisibility: true,
      controller: _horizontalController,
      notificationPredicate: (notif) => notif.metrics.axis == Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _horizontalController,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: DataTable(
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            columnSpacing: columnSpacing,
            columns: List.generate(visibleColumns.length, (index) {
              return DataColumn(
                label: Text(
                  visibleColumns[index]['label'] as String,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                numeric: visibleColumns[index]['numeric'] as bool,
                onSort: (columnIndex, ascending) {
                  _onSort(columnIndex, ascending);
                },
              );
            }),
            rows: filteredResultsList.map((seasonResult) {
              return DataRow(cells: List.generate(visibleColumns.length, (index) {
                String key = visibleColumns[index]['key'] as String;
                Widget cellContent;

                switch (key) {
                  case 'year':
                    cellContent = Text(
                      seasonResult['year'].toString(),
                      style: const TextStyle(color: Colors.black),
                    );
                    break;
                  case 'position':
                    cellContent = _buildPositionContainer(
                        seasonResult['position'].toString());
                    break;
                  case 'points':
                    cellContent = Text(
                      seasonResult['points'].toString(),
                      style: const TextStyle(color: Colors.black),
                    );
                    break;
                  case 'num_races':
                    cellContent = Text(
                      seasonResult['num_races'].toString(),
                      style: const TextStyle(color: Colors.black),
                    );
                    break;
                  case 'wins':
                    cellContent = Text(
                      seasonResult['wins'].toString(),
                      style: const TextStyle(color: Colors.black),
                    );
                    break;
                  case 'podiums':
                    cellContent = Text(
                      seasonResult['podiums'].toString(),
                      style: const TextStyle(color: Colors.black),
                    );
                    break;
                  case 'pole_positions':
                    cellContent = Text(
                      seasonResult['pole_positions'].toString(),
                      style: const TextStyle(color: Colors.black),
                    );
                    break;
                  case 'team':
                    cellContent = SizedBox(
                      width: isMobile ? 120 : 200,
                      child: Text(
                        seasonResult['team'].toString(),
                        style: const TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                    break;
                  default:
                    cellContent = const SizedBox.shrink();
                }

                return DataCell(cellContent);
              }));
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget table() {
    return Scrollbar(
      thumbVisibility: true,
      controller: _verticalController,
      child: SingleChildScrollView(
        controller: _verticalController,
        child: _buildTable(Responsive.isMobile(context)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Section
        _buildFilter(isMobile),
        SizedBox(height: 16.0), // Spacing between filter and table
        // Table Section
        table(),
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
      debugPrint(e.toString());
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
