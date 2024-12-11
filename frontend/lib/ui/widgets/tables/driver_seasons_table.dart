import 'package:flutter/material.dart';
import 'package:frontend/ui/responsive.dart'; // Ensure this is your responsive helper

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
        final matchesYear = result['year']
            .toString()
            .toLowerCase()
            .contains(filter);
        final matchesPosition = result['position']
            .toString()
            .toLowerCase()
            .contains(filter);
        final matchesTeam = result['team']
            .toString()
            .toLowerCase()
            .contains(filter);
        return matchesYear || matchesPosition || matchesTeam;
      }).toList(); // Added .toList() to convert Iterable to List

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

      switch (columnIndex) {
        case 0: // Year
          filteredResultsList.sort((a, b) {
            int yearA = int.tryParse(a['year'].toString()) ?? 0;
            int yearB = int.tryParse(b['year'].toString()) ?? 0;
            return ascending ? yearA.compareTo(yearB) : yearB.compareTo(yearA);
          });
          break;
        case 1: // Position
          filteredResultsList.sort((a, b) {
            int posA = int.tryParse(a['position'].toString()) ?? 0;
            int posB = int.tryParse(b['position'].toString()) ?? 0;
            return ascending ? posA.compareTo(posB) : posB.compareTo(posA);
          });
          break;
        case 2: // Points
          filteredResultsList.sort((a, b) {
            double pointsA = double.tryParse(a['points'].toString()) ?? 0.0;
            double pointsB = double.tryParse(b['points'].toString()) ?? 0.0;
            return ascending
                ? pointsA.compareTo(pointsB)
                : pointsB.compareTo(pointsA);
          });
          break;
        case 3: // Races
          filteredResultsList.sort((a, b) {
            int racesA = int.tryParse(a['num_races'].toString()) ?? 0;
            int racesB = int.tryParse(b['num_races'].toString()) ?? 0;
            return ascending
                ? racesA.compareTo(racesB)
                : racesB.compareTo(racesA);
          });
          break;
        case 4: // Wins
          filteredResultsList.sort((a, b) {
            int winsA = int.tryParse(a['wins'].toString()) ?? 0;
            int winsB = int.tryParse(b['wins'].toString()) ?? 0;
            return ascending ? winsA.compareTo(winsB) : winsB.compareTo(winsA);
          });
          break;
        case 5: // Podiums
          filteredResultsList.sort((a, b) {
            int podiumsA = int.tryParse(a['podiums'].toString()) ?? 0;
            int podiumsB = int.tryParse(b['podiums'].toString()) ?? 0;
            return ascending
                ? podiumsA.compareTo(podiumsB)
                : podiumsB.compareTo(podiumsA);
          });
          break;
        case 6: // Pole positions
          filteredResultsList.sort((a, b) {
            int polesA = int.tryParse(a['pole_positions'].toString()) ?? 0;
            int polesB = int.tryParse(b['pole_positions'].toString()) ?? 0;
            return ascending
                ? polesA.compareTo(polesB)
                : polesB.compareTo(polesA);
          });
          break;
        // No sorting for Team(s) column
      }
    });
  }

  /// Helper method to determine column spacing based on screen width
  double _getColumnSpacing(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      // Mobile
      return 15.0;
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
            columns: [
              DataColumn(
                label: const Text(
                  'Year',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                numeric: true,
                onSort: (columnIndex, ascending) {
                  _onSort(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text(
                  'Position',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                numeric: true,
                onSort: (columnIndex, ascending) {
                  _onSort(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text(
                  'Points',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                numeric: true,
                onSort: (columnIndex, ascending) {
                  _onSort(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text(
                  'Races',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                numeric: true,
                onSort: (columnIndex, ascending) {
                  _onSort(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text(
                  'Wins',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                numeric: true,
                onSort: (columnIndex, ascending) {
                  _onSort(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text(
                  'Podiums',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                numeric: true,
                onSort: (columnIndex, ascending) {
                  _onSort(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text(
                  'Pole Positions',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                numeric: true,
                onSort: (columnIndex, ascending) {
                  _onSort(columnIndex, ascending);
                },
              ),
              const DataColumn(
                label: Text(
                  'Team(s)',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ],
            rows: filteredResultsList.map((seasonResult) {
              return DataRow(cells: [
                DataCell(
                  Text(
                    seasonResult['year'].toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                DataCell(
                  _buildPositionContainer(seasonResult['position']),
                ),
                DataCell(
                  Text(
                    seasonResult['points'].toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                DataCell(
                  Text(
                    seasonResult['num_races'].toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                DataCell(
                  Text(
                    seasonResult['wins'].toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                DataCell(
                  Text(
                    seasonResult['podiums'].toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                DataCell(
                  Text(
                    seasonResult['pole_positions'].toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: isMobile ? 120 : 200, // Adjust width based on device
                    child: Text(
                      seasonResult['team'].toString(),
                      style: const TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ]);
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
