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

  @override
  void initState() {
    super.initState();
    teamSeasonsList = widget.seasonsData
        .map((json) => TeamSeasonResult.fromJson(json))
        .toList();
    filteredTeamSeasonsList = List.from(teamSeasonsList);
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
    });
  }

  void _sort<T>(
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

  Widget table() {
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
                sortAscending: _isAscending,
                sortColumnIndex: _sortColumnIndex,
                columns: [
                  DataColumn(
                    label: const Text(
                      'Year',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    onSort: (columnIndex, _) =>
                        _sort((team) => team.year, columnIndex),
                  ),
                  DataColumn(
                    label: const Text(
                      'Position',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    onSort: (columnIndex, _) =>
                        _sort((team) => team.position, columnIndex),
                  ),
                  DataColumn(
                    label: const Text(
                      'Points',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    onSort: (columnIndex, _) =>
                        _sort((team) => team.points, columnIndex),
                  ),
                  DataColumn(
                    label: const Text(
                      'Wins',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    onSort: (columnIndex, _) =>
                        _sort((team) => team.wins, columnIndex),
                  ),
                  DataColumn(
                    label: const Text(
                      'Podiums',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    onSort: (columnIndex, _) =>
                        _sort((team) => team.podiums, columnIndex),
                  ),
                  DataColumn(
                    label: const Text(
                      'Pole positions',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    onSort: (columnIndex, _) =>
                        _sort((team) => team.polePositions, columnIndex),
                  ),
                  const DataColumn(
                    label: Text(
                      'Drivers',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
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
                    DataCell(
                      Text(
                        teamSeasonResult.polePositions.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    DataCell(
                      Text(
                        teamSeasonResult.driversList.join(', '),
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

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
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
          ),
        ),
        isMobile ? table() : Expanded(child: table()),
      ],
    );
  }
}
