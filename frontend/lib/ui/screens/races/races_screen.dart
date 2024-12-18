import 'package:flutter/material.dart';
import 'package:frontend/core/services/API_service.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/tables/races_season_table.dart';

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
    selectedSeason = currentYear.toString();
    _racesSeasonFuture =
        APIService().getAllRacesInYear(int.parse(selectedSeason));
    for (int i = currentYear; i >= 1950; i--) {
      seasons.add(i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
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
                  Text(
                    'Season: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 16 : 18,
                    ),
                  ),
                  const SizedBox(width: 15),
                  _buildSeasonDropdown()
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                  child: FutureBuilder<void>(
                future: _racesSeasonFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                    List<dynamic> races = snapshot.data as List<dynamic>;
                    if (races.isEmpty) {
                      return const Text(
                        'Error: Data for this season is currently unavailable. Please try again later or select a different season.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      );
                    } else {
                      return RacesSeasonTable(races: races);
                    }
                  }
                  return Container();
                },
              )),
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
