import 'package:flutter/material.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/core/services/API_service.dart';
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
  late Future<List<dynamic>> _racesFuture;

  @override
  void initState() {
    super.initState();
    // Generate a list with the years from 1950 to the current year
    int currentYear = DateTime.now().year;
    for (int i = currentYear; i >= 1950; i--) {
      seasons.add(i.toString());
    }
    selectedSeason = currentYear.toString();
    _racesFuture = APIService().getRaces(year: selectedSeason);
  }

  @override
  Widget build(BuildContext context) {
    List<Race> racesSeason = [
      Race(
        id: 1,
        name: 'Bahrain Grand Prix',
        date: DateTime(2024, 3, 3),
        circuit: 'Bahrain International Circuit',
        winner: 'Charles Leclerc',
        polePosition: 'Lewis Hamilton',
        round: '1/24',
        location: 'Sakhir, Bahrain',
        winningTime: '1:31:10.456',
        fastestLap: 'Max Verstappen',
        fastestLapTime: '1:30:452',
        fastestPitStop: 'Red Bull Racing',
        fastestPitStopTime: '21.456',
      ),
      Race(
        id: 2,
        name: 'Saudi Arabian Grand Prix',
        date: DateTime(2024, 3, 17),
        circuit: 'Jeddah Corniche Circuit',
        winner: 'Lewis Hamilton',
        polePosition: 'Max Verstappen',
        round: '2/24',
        location: 'Jeddah, Saudi Arabia',
        winningTime: '1:27:43.203',
        fastestLap: 'Carlos Sainz Jr.',
        fastestLapTime: '1:28.905',
        fastestPitStop: 'Ferrari',
        fastestPitStopTime: '22.129',
      ),
      Race(
        id: 3,
        name: 'Australian Grand Prix',
        date: DateTime(2024, 4, 7),
        circuit: 'Albert Park Circuit',
        winner: 'Max Verstappen',
        polePosition: 'Charles Leclerc',
        round: '3/24',
        location: 'Melbourne, Australia',
        winningTime: '1:32:44.874',
        fastestLap: 'Lando Norris',
        fastestLapTime: '1:29.782',
        fastestPitStop: 'McLaren',
        fastestPitStopTime: '22.356',
      ),
      Race(
        id: 4,
        name: 'Azerbaijan Grand Prix',
        date: DateTime(2024, 4, 21),
        circuit: 'Baku City Circuit',
        winner: 'Sergio Pérez',
        polePosition: 'Lewis Hamilton',
        round: '4/24',
        location: 'Baku, Azerbaijan',
        winningTime: '1:39:21.890',
        fastestLap: 'Fernando Alonso',
        fastestLapTime: '1:42.200',
        fastestPitStop: 'Aston Martin',
        fastestPitStopTime: '22.654',
      ),
      Race(
        id: 5,
        name: 'Miami Grand Prix',
        date: DateTime(2024, 5, 5),
        circuit: 'Miami International Autodrome',
        winner: 'Charles Leclerc',
        polePosition: 'Charles Leclerc',
        round: '5/24',
        location: 'Miami, USA',
        winningTime: '1:38:56.912',
        fastestLap: 'Max Verstappen',
        fastestLapTime: '1:29.321',
        fastestPitStop: 'Ferrari',
        fastestPitStopTime: '21.899',
      ),
      Race(
        id: 6,
        name: 'Monaco Grand Prix',
        date: DateTime(2024, 5, 26),
        circuit: 'Circuit de Monaco',
        winner: 'Sergio Pérez',
        polePosition: 'Charles Leclerc',
        round: '6/24',
        location: 'Monte Carlo, Monaco',
        winningTime: '1:47:15.045',
        fastestLap: 'Lewis Hamilton',
        fastestLapTime: '1:12.145',
        fastestPitStop: 'Red Bull Racing',
        fastestPitStopTime: '23.233',
      ),
      Race(
        id: 7,
        name: 'Spanish Grand Prix',
        date: DateTime(2024, 6, 2),
        circuit: 'Circuit de Barcelona-Catalunya',
        winner: 'Max Verstappen',
        polePosition: 'Max Verstappen',
        round: '7/24',
        location: 'Barcelona, Spain',
        winningTime: '1:33:34.557',
        fastestLap: 'Carlos Sainz Jr.',
        fastestLapTime: '1:24.928',
        fastestPitStop: 'Ferrari',
        fastestPitStopTime: '21.321',
      ),
      Race(
        id: 8,
        name: 'Canadian Grand Prix',
        date: DateTime(2024, 6, 9),
        circuit: 'Circuit Gilles Villeneuve',
        winner: 'Lewis Hamilton',
        polePosition: 'Charles Leclerc',
        round: '8/24',
        location: 'Montreal, Canada',
        winningTime: '1:32:41.907',
        fastestLap: 'Lando Norris',
        fastestLapTime: '1:29.156',
        fastestPitStop: 'McLaren',
        fastestPitStopTime: '22.002',
      ),
      Race(
        id: 9,
        name: 'British Grand Prix',
        date: DateTime(2024, 7, 7),
        circuit: 'Silverstone Circuit',
        winner: 'Lewis Hamilton',
        polePosition: 'Lewis Hamilton',
        round: '9/24',
        location: 'Silverstone, UK',
        winningTime: '1:27:24.125',
        fastestLap: 'Max Verstappen',
        fastestLapTime: '1:27.899',
        fastestPitStop: 'Red Bull Racing',
        fastestPitStopTime: '22.475',
      ),
      Race(
        id: 10,
        name: 'Hungarian Grand Prix',
        date: DateTime(2024, 7, 21),
        circuit: 'Hungaroring',
        winner: 'Charles Leclerc',
        polePosition: 'Charles Leclerc',
        round: '10/24',
        location: 'Budapest, Hungary',
        winningTime: '1:38:41.214',
        fastestLap: 'Sergio Pérez',
        fastestLapTime: '1:32.456',
        fastestPitStop: 'Ferrari',
        fastestPitStopTime: '22.809',
      ),
      Race(
        id: 11,
        name: 'Belgian Grand Prix',
        date: DateTime(2024, 8, 4),
        circuit: 'Circuit de Spa-Francorchamps',
        winner: 'Max Verstappen',
        polePosition: 'Max Verstappen',
        round: '11/24',
        location: 'Spa, Belgium',
        winningTime: '1:30:22.678',
        fastestLap: 'Carlos Sainz Jr.',
        fastestLapTime: '1:46.123',
        fastestPitStop: 'Ferrari',
        fastestPitStopTime: '22.654',
      ),
      Race(
        id: 12,
        name: 'Dutch Grand Prix',
        date: DateTime(2024, 8, 25),
        circuit: 'Circuit Zandvoort',
        winner: 'Max Verstappen',
        polePosition: 'Max Verstappen',
        round: '12/24',
        location: 'Zandvoort, Netherlands',
        winningTime: '1:29:30.490',
        fastestLap: 'Lewis Hamilton',
        fastestLapTime: '1:30.899',
        fastestPitStop: 'Mercedes',
        fastestPitStopTime: '22.789',
      ),
      Race(
        id: 13,
        name: 'Italian Grand Prix',
        date: DateTime(2024, 9, 1),
        circuit: 'Autodromo Nazionale Monza',
        winner: 'Charles Leclerc',
        polePosition: 'Charles Leclerc',
        round: '13/24',
        location: 'Monza, Italy',
        winningTime: '1:22:12.345',
        fastestLap: 'Carlos Sainz Jr.',
        fastestLapTime: '1:23.456',
        fastestPitStop: 'Ferrari',
        fastestPitStopTime: '21.456',
      ),
      Race(
        id: 14,
        name: 'Singapore Grand Prix',
        date: DateTime(2024, 9, 22),
        circuit: 'Marina Bay Street Circuit',
        winner: 'Max Verstappen',
        polePosition: 'Max Verstappen',
        round: '14/24',
        location: 'Singapore',
        winningTime: '1:40:52.571',
        fastestLap: 'Sainz Jr.',
        fastestLapTime: '1:32.608',
        fastestPitStop: 'Sainz Jr.',
        fastestPitStopTime: '23.866',
      ),
      Race(
        id: 15,
        name: 'Japanese Grand Prix',
        date: DateTime(2024, 10, 6),
        circuit: 'Suzuka International Racing Course',
        winner: 'Lewis Hamilton',
        polePosition: 'Charles Leclerc',
        round: '15/24',
        location: 'Suzuka, Japan',
        winningTime: '1:30:00.123',
        fastestLap: 'Max Verstappen',
        fastestLapTime: '1:29.890',
        fastestPitStop: 'Mercedes',
        fastestPitStopTime: '22.123',
      ),
      Race(
        id: 16,
        name: 'United States Grand Prix',
        date: DateTime(2024, 10, 20),
        circuit: 'Circuit of the Americas',
        winner: 'Max Verstappen',
        polePosition: 'Lewis Hamilton',
        round: '16/24',
        location: 'Austin, USA',
        winningTime: '1:35:18.456',
        fastestLap: 'Lando Norris',
        fastestLapTime: '1:32.001',
        fastestPitStop: 'McLaren',
        fastestPitStopTime: '22.789',
      ),
      Race(
        id: 17,
        name: 'Mexican Grand Prix',
        date: DateTime(2024, 10, 27),
        circuit: 'Autódromo Hermanos Rodríguez',
        winner: 'Sergio Pérez',
        polePosition: 'Max Verstappen',
        round: '17/24',
        location: 'Mexico City, Mexico',
        winningTime: '1:35:47.890',
        fastestLap: 'Carlos Sainz Jr.',
        fastestLapTime: '1:30.456',
        fastestPitStop: 'Ferrari',
        fastestPitStopTime: '22.001',
      ),
      Race(
        id: 18,
        name: 'Brazilian Grand Prix',
        date: DateTime(2024, 11, 10),
        circuit: 'Autódromo José Carlos Pace',
        winner: 'Charles Leclerc',
        polePosition: 'Lewis Hamilton',
        round: '18/24',
        location: 'São Paulo, Brazil',
        winningTime: '1:30:33.789',
        fastestLap: 'Max Verstappen',
        fastestLapTime: '1:29.123',
        fastestPitStop: 'Mercedes',
        fastestPitStopTime: '21.899',
      ),
      Race(
        id: 19,
        name: 'Las Vegas Grand Prix',
        date: DateTime(2024, 11, 24),
        circuit: 'Las Vegas Strip Circuit',
        winner: 'Lewis Hamilton',
        polePosition: 'Max Verstappen',
        round: '19/24',
        location: 'Las Vegas, USA',
        winningTime: '1:37:15.555',
        fastestLap: 'Sergio Pérez',
        fastestLapTime: '1:31.990',
        fastestPitStop: 'Red Bull Racing',
        fastestPitStopTime: '22.800',
      ),
      Race(
        id: 20,
        name: 'Abu Dhabi Grand Prix',
        date: DateTime(2024, 12, 1),
        circuit: 'Yas Marina Circuit',
        winner: 'Max Verstappen',
        polePosition: 'Charles Leclerc',
        round: '20/24',
        location: 'Abu Dhabi, UAE',
        winningTime: '1:38:00.987',
        fastestLap: 'Carlos Sainz Jr.',
        fastestLapTime: '1:28.456',
        fastestPitStop: 'Ferrari',
        fastestPitStopTime: '22.333',
      ),
    ];

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
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FutureBuilder<List<dynamic>>(
                    future: _racesFuture,
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
                        //selectedRace ??= snapshot.data![0]['name'];
                        //racesSeason = [];
                        for (var item in snapshot.data!) {
                          //Race race = Race();
                          print(item);

                        }

                        return RacesSeasonTable(races: racesSeason);
                      }
                      return Container();
                    },
                  ),
                ),
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
            _racesFuture = APIService().getRaces(year: selectedSeason);
          });
        },
      ),
    );
  }
}
