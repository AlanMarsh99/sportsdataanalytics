import 'package:flutter/material.dart';
import 'package:frontend/core/models/team_season_result.dart';
import 'package:frontend/ui/responsive.dart';

class TeamSeasonsTable extends StatefulWidget {
  const TeamSeasonsTable({Key? key, required this.seasonsData})
      : super(key: key);

  final List<dynamic> seasonsData;

  @override
  _TeamSeasonsTableState createState() => _TeamSeasonsTableState();
}

class _TeamSeasonsTableState extends State<TeamSeasonsTable> {
  List<TeamSeasonResult> teamSeasonsList = [];
  List<TeamSeasonResult> filteredTeamSeasonsList = [];
  int? _sortColumnIndex;
  bool _isAscending = true;

  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    teamSeasonsList = widget.seasonsData
        .map((json) => TeamSeasonResult.fromJson(json))
        .toList();
    filteredTeamSeasonsList = List.from(teamSeasonsList);
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void updateFilter(String value) {
    setState(() {
      final filter = value.toLowerCase();
      filteredTeamSeasonsList = teamSeasonsList.where((teamSeasonResult) {
        final yearMatch = teamSeasonResult.year.toLowerCase().contains(filter);
        final positionMatch =
            teamSeasonResult.position.toLowerCase().contains(filter);
        final driversMatch = teamSeasonResult.driversList
            .any((driver) => driver.toLowerCase().contains(filter));

        return yearMatch || positionMatch || driversMatch;
      }).toList();

      if (_sortColumnIndex != null) {
        // Map the _sortColumnIndex to the corresponding sort function
        switch (_sortColumnIndex) {
          case 0:
            _sortByColumn<String>((team) => team.year, _sortColumnIndex!);
            break;
          case 1:
            _sortByColumn<String>((team) => team.position, _sortColumnIndex!);
            break;
          case 2:
            _sortByColumn<num>((team) => team.points, _sortColumnIndex!);
            break;
          case 3:
            _sortByColumn<num>((team) => team.wins, _sortColumnIndex!);
            break;
          case 4:
            _sortByColumn<num>((team) => team.podiums, _sortColumnIndex!);
            break;
          case 5:
            _sortByColumn<num>((team) => team.polePositions, _sortColumnIndex!);
            break;
          default:
            break;
        }
      }
    });
  }

  void _sortByColumn<T>(
      Comparable<T> Function(TeamSeasonResult team) getField, int columnIndex) {
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        _isAscending = !_isAscending;
      } else {
        _isAscending = true;
      }
      _sortColumnIndex = columnIndex;

      filteredTeamSeasonsList.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return _isAscending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  Widget _buildPositionContainer(String position) {
    Color color;
    switch (position) {
      case "1":
        color = const Color.fromARGB(255, 220, 148, 4);
        break;
      case "2":
        color = const Color.fromARGB(255, 136, 136, 136);
        break;
      case "3":
        color = const Color.fromARGB(255, 106, 74, 62);
        break;
      default:
        color = Colors.transparent;
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

  /// Helper method to determine column spacing based on screen width
  double _getColumnSpacing(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      // Mobile
      return 1.0;
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
          hintText: 'Enter year, position or driver',
          hintStyle: const TextStyle(color: Colors.white70),
          labelText: 'Filter team seasons',
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

    // Define columns with conditional rendering
    List<DataColumn> columns = [
      DataColumn(
        label: const Text(
          'Year',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        onSort: (columnIndex, _) =>
            _sortByColumn<String>((team) => team.year, columnIndex),
      ),
      DataColumn(
        label: const Text(
          'Position',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        onSort: (columnIndex, _) =>
            _sortByColumn<String>((team) => team.position, columnIndex),
      ),
      DataColumn(
        label: const Text(
          'Points',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        numeric: true,
        onSort: (columnIndex, _) =>
            _sortByColumn<num>((team) => team.points, columnIndex),
      ),
      DataColumn(
        label: const Text(
          'Wins',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        numeric: true,
        onSort: (columnIndex, _) =>
            _sortByColumn<num>((team) => team.wins, columnIndex),
      ),
      DataColumn(
        label: const Text(
          'Podiums',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        numeric: true,
        onSort: (columnIndex, _) =>
            _sortByColumn<num>((team) => team.podiums, columnIndex),
      ),
      // Conditionally add Pole Positions column
      if (!isMobile)
        DataColumn(
          label: const Text(
            'Pole Positions',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          numeric: true,
          onSort: (columnIndex, _) =>
              _sortByColumn<num>((team) => team.polePositions, columnIndex),
        ),
      // Conditionally add Drivers column
      if (!isMobile)
        const DataColumn(
          label: Text(
            'Drivers',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
    ];

    return Container(
      height: isMobile ? null : MediaQuery.of(context).size.height * 0.67,
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
                  sortAscending: _isAscending,
                  sortColumnIndex: _sortColumnIndex,
                  columnSpacing: columnSpacing,
                  columns: columns,
                  rows: filteredTeamSeasonsList.map((teamSeasonResult) {
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
                      // Conditionally add Pole Positions cell
                      if (!isMobile)
                        DataCell(
                          Text(
                            teamSeasonResult.polePositions.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      // Conditionally add Drivers cell
                      if (!isMobile)
                        DataCell(
                          SizedBox(
                            width: 200,
                            child: Text(
                              teamSeasonResult.driversList.join(', '),
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
          ),
        ),
      ),
    );
  }

  Widget table() {
    return Scrollbar(
      thumbVisibility: true,
      controller: _verticalScrollController,
      child: SingleChildScrollView(
        controller: _verticalScrollController,
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
}
