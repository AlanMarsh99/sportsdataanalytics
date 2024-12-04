import 'package:flutter/material.dart';
import 'package:frontend/core/models/race.dart';
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
  String filter = '';

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
      filter = value.toLowerCase();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Enter a driver, race, or circuit',
              hintStyle: TextStyle(color: Colors.white70),
              labelText: 'Filter races',
              labelStyle: const TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.white,),
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: DataTable(
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Date',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Race',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Circuit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Winner',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
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
