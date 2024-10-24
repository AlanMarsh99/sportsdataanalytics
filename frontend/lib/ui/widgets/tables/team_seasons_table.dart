import 'package:flutter/material.dart';
import 'package:frontend/core/models/team.dart';
import 'package:frontend/ui/theme.dart';

class TeamSeasonsTable extends StatelessWidget {
  //const TeamSeasonsTable({Key? key, required this.teamSeasons}) : super(key: key);

  //final List<Team> teamSeasons;

  List<Team> teamSeasons = [
    Team(
        id: 1,
        name: 'McLaren Racing',
        wins: 5,
        podiums: 18,
        polePositions: 5,
        points: 516,
        position: 1,
        drivers: 'Lando Norris & Oscar Piastri',
        seasonYear: 2024,
        championshipsWins: 8,
        championshipsParticipated: 68,
        totalRaces: 850),
    Team(
        id: 1,
        name: 'McLaren Racing',
        wins: 5,
        podiums: 18,
        polePositions: 6,
        points: 302,
        position: 4,
        drivers: 'Lando Norris & Oscar Piastri',
        seasonYear: 2023,
        championshipsWins: 8,
        championshipsParticipated: 68,
        totalRaces: 850),
    Team(
        id: 1,
        name: 'McLaren Racing',
        wins: 5,
        podiums: 18,
        polePositions: 6,
        points: 159,
        position: 5,
        drivers: 'Lando Norris & Oscar Piastri',
        seasonYear: 2022,
        championshipsWins: 8,
        championshipsParticipated: 68,
        totalRaces: 850),
    Team(
        id: 1,
        name: 'McLaren Racing',
        wins: 5,
        podiums: 18,
        polePositions: 6,
        points: 275,
        position: 4,
        drivers: 'Lando Norris & Oscar Piastri',
        seasonYear: 2021,
        championshipsWins: 8,
        championshipsParticipated: 68,
        totalRaces: 850),
    Team(
        id: 1,
        name: 'McLaren Racing',
        wins: 5,
        podiums: 18,
        polePositions: 6,
        points: 202,
        position: 3,
        drivers: 'Lando Norris & Oscar Piastri',
        seasonYear: 2020,
        championshipsWins: 8,
        championshipsParticipated: 68,
        totalRaces: 850),
    Team(
        id: 1,
        name: 'McLaren Racing',
        wins: 5,
        podiums: 18,
        polePositions: 6,
        points: 145,
        position: 4,
        drivers: 'Lando Norris & Oscar Piastri',
        seasonYear: 2019,
        championshipsWins: 8,
        championshipsParticipated: 68,
        totalRaces: 850),
    Team(
        id: 1,
        name: 'McLaren Racing',
        wins: 5,
        podiums: 18,
        polePositions: 6,
        points: 62,
        position: 1,
        drivers: 'Lando Norris & Oscar Piastri',
        seasonYear: 2018,
        championshipsWins: 8,
        championshipsParticipated: 68,
        totalRaces: 850),
    Team(
        id: 1,
        name: 'McLaren Racing',
        wins: 5,
        podiums: 18,
        polePositions: 6,
        points: 30,
        position: 6,
        drivers: 'Lando Norris & Oscar Piastri',
        seasonYear: 2017,
        championshipsWins: 8,
        championshipsParticipated: 68,
        totalRaces: 850),
    Team(
        id: 1,
        name: 'McLaren Racing',
        wins: 5,
        podiums: 18,
        polePositions: 6,
        points: 76,
        position: 9,
        drivers: 'Lando Norris & Oscar Piastri',
        seasonYear: 2016,
        championshipsWins: 8,
        championshipsParticipated: 68,
        totalRaces: 850),
    Team(
        id: 1,
        name: 'McLaren Racing',
        wins: 5,
        podiums: 18,
        polePositions: 6,
        points: 27,
        position: 6,
        drivers: 'Lando Norris & Oscar Piastri',
        seasonYear: 2015,
        championshipsWins: 8,
        championshipsParticipated: 68,
        totalRaces: 850),
  ];

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              //padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: DataTable(
                /*dataRowColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
        
            return Colors.white;
      
        }),*/
                columns: const [
                  DataColumn(
                    label: Text(
                      'Year',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Position',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Points',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Wins',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Podiums',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Pole positions',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Drivers',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
                rows: teamSeasons.map((teamSeason) {
                  return DataRow(cells: [
                    DataCell(
                      Text(
                        teamSeason.seasonYear.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    DataCell(
                      _buildPositionContainer(teamSeason.position),
                    ),
                    DataCell(
                      Text(
                        teamSeason.points.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    DataCell(
                      Text(
                        teamSeason.wins.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    DataCell(
                      Text(
                        teamSeason.podiums.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    DataCell(
                      Text(
                        teamSeason.polePositions.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    DataCell(
                      Text(
                        teamSeason.drivers,
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

  Widget _buildPositionContainer(int position) {
    Color color;
    switch (position) {
      case 1:
        color = const Color.fromARGB(255, 220, 148, 4); // 1st position
        break;
      case 2:
        color = const Color.fromARGB(255, 136, 136, 136); // 2nd position
        break;
      case 3:
        color = const Color.fromARGB(255, 106, 74, 62); // 3rd position
        break;
      default:
        color = Colors.transparent; // Default color
        break;
    }
    return Container(
      width: 35,
      height: 35,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Text(
          position.toString(),
          style: TextStyle(color: position <= 3 ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
