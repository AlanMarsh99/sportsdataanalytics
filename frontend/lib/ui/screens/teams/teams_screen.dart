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
  List<String> seasons = [];
  String selectedSeason = '2024';

  List<Team> teamsSeason = [
    Team(
      id: 1,
      name: 'McLaren Racing',
      wins: 8,
      podiums: 18,
      polePositions: 6,
      points: 331,
      position: 1,
      drivers: 'Lando Norris & Oscar Piastri',
      seasonYear: 2024,
      championshipsWins: 8,
      championshipsParticipated: 68,
      totalRaces: 850,
    ),
    Team(
      id: 2,
      name: 'Red Bull Racing',
      wins: 5,
      podiums: 15,
      polePositions: 92,
      points: 310,
      position: 2,
      drivers: 'Max Verstappen & Sergio Pérez',
      seasonYear: 2024,
      championshipsWins: 5,
      championshipsParticipated: 20,
      totalRaces: 380,
    ),
    Team(
      id: 3,
      name: 'Ferrari',
      wins: 3,
      podiums: 12,
      polePositions: 5,
      points: 245,
      position: 3,
      drivers: 'Charles Leclerc & Carlos Sainz Jr.',
      seasonYear: 2024,
      championshipsWins: 16,
      championshipsParticipated: 75,
      totalRaces: 1000,
    ),
    Team(
      id: 4,
      name: 'Mercedes',
      wins: 2,
      podiums: 10,
      polePositions: 3,
      points: 190,
      position: 4,
      drivers: 'Lewis Hamilton & George Russell',
      seasonYear: 2024,
      championshipsWins: 8,
      championshipsParticipated: 10,
      totalRaces: 200,
    ),
    Team(
      id: 5,
      name: 'Aston Martin',
      wins: 1,
      podiums: 8,
      polePositions: 2,
      points: 160,
      position: 5,
      drivers: 'Fernando Alonso & Lance Stroll',
      seasonYear: 2024,
      championshipsWins: 0,
      championshipsParticipated: 15,
      totalRaces: 300,
    ),
    Team(
      id: 6,
      name: 'Alpine',
      wins: 0,
      podiums: 4,
      polePositions: 1,
      points: 90,
      position: 6,
      drivers: 'Esteban Ocon & Pierre Gasly',
      seasonYear: 2024,
      championshipsWins: 0,
      championshipsParticipated: 5,
      totalRaces: 100,
    ),
    Team(
      id: 7,
      name: 'AlphaTauri',
      wins: 0,
      podiums: 2,
      polePositions: 0,
      points: 30,
      position: 7,
      drivers: 'Yuki Tsunoda & Daniel Ricciardo',
      seasonYear: 2024,
      championshipsWins: 1,
      championshipsParticipated: 10,
      totalRaces: 200,
    ),
    Team(
      id: 8,
      name: 'Haas F1 Team',
      wins: 0,
      podiums: 1,
      polePositions: 0,
      points: 25,
      position: 8,
      drivers: 'Kevin Magnussen & Nico Hülkenberg',
      seasonYear: 2024,
      championshipsWins: 0,
      championshipsParticipated: 5,
      totalRaces: 100,
    ),
    Team(
      id: 9,
      name: 'Alfa Romeo',
      wins: 0,
      podiums: 0,
      polePositions: 0,
      points: 15,
      position: 9,
      drivers: 'Guanyu Zhou & Valtteri Bottas',
      seasonYear: 2024,
      championshipsWins: 0,
      championshipsParticipated: 8,
      totalRaces: 150,
    ),
    Team(
      id: 10,
      name: 'Williams Racing',
      wins: 0,
      podiums: 0,
      polePositions: 0,
      points: 5,
      position: 10,
      drivers: 'Alex Albon & Logan Sargeant',
      seasonYear: 2024,
      championshipsWins: 9,
      championshipsParticipated: 45,
      totalRaces: 800,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Generate a list with the years from 1950 to the current year
    int currentYear = DateTime.now().year;
    for (int i = currentYear; i >= 1950; i--) {
      seasons.add(i.toString());
    }
    selectedSeason = currentYear.toString();

    teamsSeason.sort((a, b) => b.wins.compareTo(a.wins));
  }

  @override
  Widget build(BuildContext context) {
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
          });
        },
      ),
    );
  }
}
