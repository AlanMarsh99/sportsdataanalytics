import 'package:flutter/material.dart';
import 'package:frontend/core/models/team.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/tables/teams_season_table.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({
    Key? key,
  }) : super(key: key);

  _TeamsScreenState createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  @override
  Widget build(BuildContext context) {
    List<Team> teamsSeason = [
      Team(
          id: 1,
          name: 'McLaren Racing',
          wins: 5,
          podiums: 18,
          polePositions: 6,
          points: 331,
          position: 1,
          drivers: 'Lando Norris & Oscar Piastri',
          seasonYear: 2024),
      Team(
          id: 1,
          name: 'McLaren Racing',
          wins: 5,
          podiums: 18,
          polePositions: 6,
          points: 331,
          position: 1,
          drivers: 'Lando Norris & Oscar Piastri',
          seasonYear: 2024),
      Team(
          id: 1,
          name: 'McLaren Racing',
          wins: 5,
          podiums: 18,
          polePositions: 6,
          points: 331,
          position: 1,
          drivers: 'Lando Norris & Oscar Piastri',
          seasonYear: 2024),
      Team(
          id: 1,
          name: 'McLaren Racing',
          wins: 5,
          podiums: 18,
          polePositions: 6,
          points: 331,
          position: 1,
          drivers: 'Lando Norris & Oscar Piastri',
          seasonYear: 2024),
      Team(
          id: 1,
          name: 'McLaren Racing',
          wins: 5,
          podiums: 18,
          polePositions: 6,
          points: 331,
          position: 1,
          drivers: 'Lando Norris & Oscar Piastri',
          seasonYear: 2024),
      Team(
          id: 1,
          name: 'McLaren Racing',
          wins: 5,
          podiums: 18,
          polePositions: 6,
          points: 331,
          position: 1,
          drivers: 'Lando Norris & Oscar Piastri',
          seasonYear: 2024),
      Team(
          id: 1,
          name: 'McLaren Racing',
          wins: 5,
          podiums: 18,
          polePositions: 6,
          points: 331,
          position: 1,
          drivers: 'Lando Norris & Oscar Piastri',
          seasonYear: 2024),
      Team(
          id: 1,
          name: 'McLaren Racing',
          wins: 5,
          podiums: 18,
          polePositions: 6,
          points: 331,
          position: 1,
          drivers: 'Lando Norris & Oscar Piastri',
          seasonYear: 2024),
      Team(
          id: 1,
          name: 'McLaren Racing',
          wins: 5,
          podiums: 18,
          polePositions: 6,
          points: 331,
          position: 1,
          drivers: 'Lando Norris & Oscar Piastri',
          seasonYear: 2024),
      Team(
          id: 1,
          name: 'McLaren Racing',
          wins: 5,
          podiums: 18,
          polePositions: 6,
          points: 331,
          position: 1,
          drivers: 'Lando Norris & Oscar Piastri',
          seasonYear: 2024),
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
                'TEAMS',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 25),
              // Graph teams ranking
              Text('Ranking (2018 - 2024):',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 300,
                color: Colors.white,
              ),
              const SizedBox(height: 25),
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
                  child: TeamsSeasonTable(teams: teamsSeason),
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
