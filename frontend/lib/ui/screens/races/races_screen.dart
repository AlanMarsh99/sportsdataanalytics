import 'package:flutter/material.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/core/providers/data_provider.dart';
import 'package:frontend/core/services/API_service.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/tables/races_season_table.dart';
import 'package:provider/provider.dart';

class RacesScreen extends StatefulWidget {
  const RacesScreen({
    Key? key,
  }) : super(key: key);

  _RacesScreenState createState() => _RacesScreenState();
}

class _RacesScreenState extends State<RacesScreen> {
  List<String> seasons = [];
  String selectedSeason = '2024';
  Future<List<dynamic>>? _racesSeasonFuture;
  List<dynamic>? racesSeason;
  bool seasonChanged = false;

  @override
  void initState() {
    super.initState();
    // Generate a list with the years from 1950 to the current year
    int currentYear = DateTime.now().year;
    for (int i = currentYear; i >= 1950; i--) {
      seasons.add(i.toString());
    }
    selectedSeason = currentYear.toString();
  }

  @override
  Widget build(BuildContext context) {

    // Access the provider
    final dataProvider = Provider.of<DataProvider>(context);

    // Extract data from provider
    racesSeason = dataProvider.racesSeason;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [darkGradient, lightGradient],
        ),
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'RACES',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Season: ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 15),
                  _buildSeasonDropdown()
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: seasonChanged
                      ? FutureBuilder<void>(
                          future: _racesSeasonFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ); // Show loading while fetching
                            } else if (snapshot.hasError) {
                              return const Text(
                                'Error: Failed to load races',
                                style: TextStyle(color: Colors.white),
                              ); // Error handling
                            } else if (snapshot.hasData) {
                              List<dynamic> races =
                                  snapshot.data as List<dynamic>;
                              return RacesSeasonTable(races: races);
                            }
                            return Container();
                          },
                        )
                      : racesSeason == null
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : RacesSeasonTable(races: racesSeason!),
                
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeasonDropdown() {
    return Container(
      width: 150,
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<String>(
        value: selectedSeason,
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: const SizedBox(),
        items: seasons.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(color: Colors.black)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedSeason = newValue!;
            seasonChanged = true;
            _racesSeasonFuture =
                APIService().getAllRacesInYear(int.parse(selectedSeason));
          });
        },
      ),
    );
  }
}
