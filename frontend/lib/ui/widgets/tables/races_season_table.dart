import 'package:flutter/material.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/screens/races/races_detail_screen.dart';
import 'package:frontend/ui/theme.dart';

class RacesSeasonTable extends StatefulWidget {
  const RacesSeasonTable({Key? key, required this.races}) : super(key: key);

  final List<dynamic> races;

  @override
  State<RacesSeasonTable> createState() => _RacesSeasonTableState();
}

class _RacesSeasonTableState extends State<RacesSeasonTable> {
  List<Race> racesList = [];
  List<Race> filteredRacesList = [];
  bool isAscending = true; // Tracks sorting order
  int? sortColumnIndex;

  List<Race> parseRaces(List<dynamic> jsonList) {
    return jsonList.map((json) => Race.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    racesList = parseRaces(widget.races);
    filteredRacesList = List.from(racesList);
  }

  void updateFilter(String value) {
    setState(() {
      final filter = value.toLowerCase();
      filteredRacesList = racesList
          .where((race) =>
              race.raceName.toLowerCase().contains(filter) ||
              race.date.toLowerCase().contains(filter) ||
              race.circuitName.toLowerCase().contains(filter) ||
              race.winner.toLowerCase().contains(filter) ||
              race.polePosition.toLowerCase().contains(filter))
          .toList();
    });
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
      if (columnIndex == 0) {
        // Sort by Date
        filteredRacesList.sort((a, b) {
          final dateA = DateTime.parse(a.date);
          final dateB = DateTime.parse(b.date);
          return ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            width: isMobile ? double.infinity : 500,
            child: TextField(
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'Enter a driver, race, or circuit',
                hintStyle: const TextStyle(color: Colors.white70),
                labelText: 'Filter races',
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: DataTable(
                      showCheckboxColumn:
                          false, // Disable default checkbox and sort indicators
                      sortColumnIndex: 0, // Index of the column being sorted
                      sortAscending:
                          isAscending, // Reflect the current sort order
                      columns: [
                        DataColumn(
                          label: InkWell(
                            onTap: () => onSort(0, !isAscending),
                            child: Row(
                              children: [
                                const Text(
                                  'Date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(
                                  isAscending
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const DataColumn(
                          label: Text(
                            'Race',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const DataColumn(
                          label: Text(
                            'Circuit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const DataColumn(
                          label: Text(
                            'Winner',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const DataColumn(
                          label: Text(
                            'Pole position',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ],
                      rows: filteredRacesList.map((race) {
                        return DataRow(cells: [
                          DataCell(
                            Text(
                              race.date,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          DataCell(
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RacesDetailScreen(race: race),
                                  ),
                                );
                              },
                              child: Text(
                                race.raceName,
                                style: const TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              race.circuitName,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          DataCell(
                            Text(
                              race.winner,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          DataCell(
                            Text(
                              race.polePosition,
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
}
