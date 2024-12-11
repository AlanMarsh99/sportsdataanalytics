import 'package:flutter/material.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/core/services/API_service.dart';
import 'package:frontend/ui/screens/races/races_detail_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/responsive.dart';

class DriverAllRacesTableScreen extends StatefulWidget {
  const DriverAllRacesTableScreen({Key? key, required this.data})
      : super(key: key);

  final List<dynamic> data;

  @override
  _DriverAllRacesTableScreenState createState() =>
      _DriverAllRacesTableScreenState();
}

class _DriverAllRacesTableScreenState extends State<DriverAllRacesTableScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  // State variables for sorting
  int? _sortColumnIndex;
  bool _sortAscending = true;

  // Mutable list to hold and sort the race data
  late List<Map<String, dynamic>> _raceData;
  List<Map<String, dynamic>> filteredResultsList = [];
  String filter = '';

  @override
  void initState() {
    super.initState();
    // Initialize the mutable list from widget data
    _raceData = widget.data
        .map<Map<String, dynamic>>((race) => Map<String, dynamic>.from(race))
        .toList();
    filteredResultsList = List.from(_raceData);
  }

  void updateFilter(String value) {
    filter = value;
    setState(() {
      filteredResultsList = _raceData.where((result) {
        final matchesRaceName = result['race_name']
            .toString()
            .toLowerCase()
            .contains(filter.toLowerCase());
        final matchesResult = result['result'].toString() == filter;
        return matchesRaceName || matchesResult;
      }).toList();

      // Re-apply sorting after filtering
      if (_sortColumnIndex != null) {
        _onSort(_sortColumnIndex!, _sortAscending);
      }
    });
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  // Sorting function
  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      switch (columnIndex) {
        case 0: // Race
          filteredResultsList.sort((a, b) {
            String raceA = a['race_name'].toString();
            String raceB = b['race_name'].toString();
            return ascending ? raceA.compareTo(raceB) : raceB.compareTo(raceA);
          });
          break;
        case 1: // Qualifying
          filteredResultsList.sort((a, b) {
            int qualA = int.tryParse(a['qualifying_position'].toString()) ?? 0;
            int qualB = int.tryParse(b['qualifying_position'].toString()) ?? 0;
            return ascending ? qualA.compareTo(qualB) : qualB.compareTo(qualA);
          });
          break;
        case 2: // Grid
          filteredResultsList.sort((a, b) {
            int gridA = int.tryParse(a['grid'].toString()) ?? 0;
            int gridB = int.tryParse(b['grid'].toString()) ?? 0;
            return ascending ? gridA.compareTo(gridB) : gridB.compareTo(gridA);
          });
          break;
        case 3: // Result
          filteredResultsList.sort((a, b) {
            int resultA = int.tryParse(a['result'].toString()) ?? 0;
            int resultB = int.tryParse(b['result'].toString()) ?? 0;
            return ascending
                ? resultA.compareTo(resultB)
                : resultB.compareTo(resultA);
          });
          break;
        default:
          break;
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
          hintText: 'Enter a race name or a result',
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
                  'Race',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                onSort: (columnIndex, ascending) {
                  _onSort(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text(
                  'Qualifying',
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
                  'Grid',
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
                  'Result',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                numeric: true,
                onSort: (columnIndex, ascending) {
                  _onSort(columnIndex, ascending);
                },
              ),
            ],
            rows: filteredResultsList.map((race) {
              return DataRow(cells: [
                DataCell(
                  InkWell(
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
                          color: primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                DataCell(
                  _buildPositionContainer(race['qualifying_position']),
                ),
                DataCell(
                  Text(
                    race['grid'].toString(),
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
    );
  }

  Widget table() {
    return Expanded(
      child: Scrollbar(
        thumbVisibility: true,
        controller: _verticalController,
        child: SingleChildScrollView(
          controller: _verticalController,
          child: _buildTable(Responsive.isMobile(context)),
        ),
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
          position.toString(),
          style: TextStyle(color: pos <= 3 ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
