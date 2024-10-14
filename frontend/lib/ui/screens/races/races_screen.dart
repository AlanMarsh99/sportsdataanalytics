import 'package:flutter/material.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/tables/races_season_table.dart';

class RacesScreen extends StatefulWidget {
  const RacesScreen({
    Key? key,
  }) : super(key: key);

  _RacesScreenState createState() => _RacesScreenState();
}

class _RacesScreenState extends State<RacesScreen> {
  @override
  Widget build(BuildContext context) {
    List<Race> racesSeason = [
      Race(
          id: 1,
          name: 'Singapore Grand Prix',
          date: DateTime(2024, 9, 22),
          circuit: 'Marina Bay Street Circuit',
          winner: 'Max Verstappen',
          polePosition: 'Max Verstappen',
          round: '1/24',
          location: 'Singapore',
          winningTime: '1:40:52.571',
          fastestLap: 'Sainz Jr.',
          fastestLapTime: '1:32.608',
          fastestPitStop: 'Sainz Jr.',
          fastestPitStopTime: '23.866'),
      Race(
          id: 2,
          name: 'Singapore Grand Prix',
          date: DateTime(2024, 9, 22),
          circuit: 'Marina Bay Street Circuit',
          winner: 'Max Verstappen',
          polePosition: 'Max Verstappen',
          round: '1/24',
          location: 'Singapore',
          winningTime: '1:40:52.571',
          fastestLap: 'Sainz Jr.',
          fastestLapTime: '1:32.608',
          fastestPitStop: 'Sainz Jr.',
          fastestPitStopTime: '23.866'),
      Race(
          id: 3,
          name: 'Singapore Grand Prix',
          date: DateTime(2024, 9, 22),
          circuit: 'Marina Bay Street Circuit',
          winner: 'Max Verstappen',
          polePosition: 'Max Verstappen',
          round: '1/24',
          location: 'Singapore',
          winningTime: '1:40:52.571',
          fastestLap: 'Sainz Jr.',
          fastestLapTime: '1:32.608',
          fastestPitStop: 'Sainz Jr.',
          fastestPitStopTime: '23.866'),
      Race(
          id: 4,
          name: 'Singapore Grand Prix',
          date: DateTime(2024, 9, 22),
          circuit: 'Marina Bay Street Circuit',
          winner: 'Max Verstappen',
          polePosition: 'Max Verstappen',
          round: '1/24',
          location: 'Singapore',
          winningTime: '1:40:52.571',
          fastestLap: 'Sainz Jr.',
          fastestLapTime: '1:32.608',
          fastestPitStop: 'Sainz Jr.',
          fastestPitStopTime: '23.866'),
      Race(
          id: 5,
          name: 'Singapore Grand Prix',
          date: DateTime(2024, 9, 22),
          circuit: 'Marina Bay Street Circuit',
          winner: 'Max Verstappen',
          polePosition: 'Max Verstappen',
          round: '1/24',
          location: 'Singapore',
          winningTime: '1:40:52.571',
          fastestLap: 'Sainz Jr.',
          fastestLapTime: '1:32.608',
          fastestPitStop: 'Sainz Jr.',
          fastestPitStopTime: '23.866'),
      Race(
          id: 5,
          name: 'Singapore Grand Prix',
          date: DateTime(2024, 9, 22),
          circuit: 'Marina Bay Street Circuit',
          winner: 'Max Verstappen',
          polePosition: 'Max Verstappen',
          round: '1/24',
          location: 'Singapore',
          winningTime: '1:40:52.571',
          fastestLap: 'Sainz Jr.',
          fastestLapTime: '1:32.608',
          fastestPitStop: 'Sainz Jr.',
          fastestPitStopTime: '23.866'),
      Race(
          id: 5,
          name: 'Singapore Grand Prix',
          date: DateTime(2024, 9, 22),
          circuit: 'Marina Bay Street Circuit',
          winner: 'Max Verstappen',
          polePosition: 'Max Verstappen',
          round: '1/24',
          location: 'Singapore',
          winningTime: '1:40:52.571',
          fastestLap: 'Sainz Jr.',
          fastestLapTime: '1:32.608',
          fastestPitStop: 'Sainz Jr.',
          fastestPitStopTime: '23.866'),
      Race(
          id: 5,
          name: 'Singapore Grand Prix',
          date: DateTime(2024, 9, 22),
          circuit: 'Marina Bay Street Circuit',
          winner: 'Max Verstappen',
          polePosition: 'Max Verstappen',
          round: '1/24',
          location: 'Singapore',
          winningTime: '1:40:52.571',
          fastestLap: 'Sainz Jr.',
          fastestLapTime: '1:32.608',
          fastestPitStop: 'Sainz Jr.',
          fastestPitStopTime: '23.866'),
      Race(
          id: 5,
          name: 'Singapore Grand Prix',
          date: DateTime(2024, 9, 22),
          circuit: 'Marina Bay Street Circuit',
          winner: 'Max Verstappen',
          polePosition: 'Max Verstappen',
          round: '1/24',
          location: 'Singapore',
          winningTime: '1:40:52.571',
          fastestLap: 'Sainz Jr.',
          fastestLapTime: '1:32.608',
          fastestPitStop: 'Sainz Jr.',
          fastestPitStopTime: '23.866'),
      Race(
          id: 5,
          name: 'Singapore Grand Prix',
          date: DateTime(2024, 9, 22),
          circuit: 'Marina Bay Street Circuit',
          winner: 'Max Verstappen',
          polePosition: 'Max Verstappen',
          round: '1/24',
          location: 'Singapore',
          winningTime: '1:40:52.571',
          fastestLap: 'Sainz Jr.',
          fastestLapTime: '1:32.608',
          fastestPitStop: 'Sainz Jr.',
          fastestPitStopTime: '23.866'),
      Race(
          id: 5,
          name: 'Singapore Grand Prix',
          date: DateTime(2024, 9, 22),
          circuit: 'Marina Bay Street Circuit',
          winner: 'Max Verstappen',
          polePosition: 'Max Verstappen',
          round: '1/24',
          location: 'Singapore',
          winningTime: '1:40:52.571',
          fastestLap: 'Sainz Jr.',
          fastestLapTime: '1:32.608',
          fastestPitStop: 'Sainz Jr.',
          fastestPitStopTime: '23.866'),
      Race(
          id: 5,
          name: 'Singapore Grand Prix',
          date: DateTime(2024, 9, 22),
          circuit: 'Marina Bay Street Circuit',
          winner: 'Max Verstappen',
          polePosition: 'Max Verstappen',
          round: '1/24',
          location: 'Singapore',
          winningTime: '1:40:52.571',
          fastestLap: 'Sainz Jr.',
          fastestLapTime: '1:32.608',
          fastestPitStop: 'Sainz Jr.',
          fastestPitStopTime: '23.866'),
      Race(
          id: 5,
          name: 'Singapore Grand Prix',
          date: DateTime(2024, 9, 22),
          circuit: 'Marina Bay Street Circuit',
          winner: 'Max Verstappen',
          polePosition: 'Max Verstappen',
          round: '1/24',
          location: 'Singapore',
          winningTime: '1:40:52.571',
          fastestLap: 'Sainz Jr.',
          fastestLapTime: '1:32.608',
          fastestPitStop: 'Sainz Jr.',
          fastestPitStopTime: '23.866'),
      Race(
          id: 5,
          name: 'Singapore Grand Prix',
          date: DateTime(2024, 9, 22),
          circuit: 'Marina Bay Street Circuit',
          winner: 'Max Verstappen',
          polePosition: 'Max Verstappen',
          round: '1/24',
          location: 'Singapore',
          winningTime: '1:40:52.571',
          fastestLap: 'Sainz Jr.',
          fastestLapTime: '1:32.608',
          fastestPitStop: 'Sainz Jr.',
          fastestPitStopTime: '23.866'),
      Race(
          id: 5,
          name: 'Singapore Grand Prix',
          date: DateTime(2024, 9, 22),
          circuit: 'Marina Bay Street Circuit',
          winner: 'Max Verstappen',
          polePosition: 'Max Verstappen',
          round: '1/24',
          location: 'Singapore',
          winningTime: '1:40:52.571',
          fastestLap: 'Sainz Jr.',
          fastestLapTime: '1:32.608',
          fastestPitStop: 'Sainz Jr.',
          fastestPitStopTime: '23.866'),
      Race(
          id: 5,
          name: 'Singapore Grand Prix',
          date: DateTime(2024, 9, 22),
          circuit: 'Marina Bay Street Circuit',
          winner: 'Max Verstappen',
          polePosition: 'Max Verstappen',
          round: '1/24',
          location: 'Singapore',
          winningTime: '1:40:52.571',
          fastestLap: 'Sainz Jr.',
          fastestLapTime: '1:32.608',
          fastestPitStop: 'Sainz Jr.',
          fastestPitStopTime: '23.866'),
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
                  _buildSeasonDropdown(),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: RacesSeasonTable(races: racesSeason),
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
        value: '2024',
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: const SizedBox(),
        items: <String>['2020', '2021', '2022', '2023', '2024']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(color: Colors.black)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          // Handle driver selection
        },
      ),
    );
  }
}
