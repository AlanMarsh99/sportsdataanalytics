import 'package:flutter/material.dart';
import 'package:frontend/ui/theme.dart';

class DriverSeasonsTable extends StatelessWidget {
  final List<Map<String, dynamic>> driverSeasons = [
    {
      'year': '2024 Singapore Grand Prix',
      'position': 1,
      'points': 331,
      'races': 18,
      'wins': 7,
      'podiums': 11,
      'polePositions': 8,
      'team': 'Red Bull',
    },
    {
      'year': '2024 Singapore Grand Prix',
      'position': 1,
      'points': 331,
      'races': 18,
      'wins': 7,
      'podiums': 11,
      'polePositions': 8,
      'team': 'Red Bull',
    },
    {
      'year': '2024 Singapore Grand Prix',
      'position': 1,
      'points': 331,
      'races': 18,
      'wins': 7,
      'podiums': 11,
      'polePositions': 8,
      'team': 'Red Bull',
    },
    {
      'year': '2024 Singapore Grand Prix',
      'position': 1,
      'points': 331,
      'races': 18,
      'wins': 7,
      'podiums': 11,
      'polePositions': 8,
      'team': 'Red Bull',
    },
    {
      'year': '2024 Singapore Grand Prix',
      'position': 1,
      'points': 331,
      'races': 18,
      'wins': 7,
      'podiums': 11,
      'polePositions': 8,
      'team': 'Red Bull',
    },
    {
      'year': '2024 Singapore Grand Prix',
      'position': 1,
      'points': 331,
      'races': 18,
      'wins': 7,
      'podiums': 11,
      'polePositions': 8,
      'team': 'Red Bull',
    },
    {
      'year': '2024 Singapore Grand Prix',
      'position': 1,
      'points': 331,
      'races': 18,
      'wins': 7,
      'podiums': 11,
      'polePositions': 8,
      'team': 'Red Bull',
    },
    {
      'year': '2024 Singapore Grand Prix',
      'position': 1,
      'points': 331,
      'races': 18,
      'wins': 7,
      'podiums': 11,
      'polePositions': 8,
      'team': 'Red Bull',
    },
    {
      'year': '2024 Singapore Grand Prix',
      'position': 1,
      'points': 331,
      'races': 18,
      'wins': 7,
      'podiums': 11,
      'polePositions': 8,
      'team': 'Red Bull',
    },
    {
      'year': '2024 Singapore Grand Prix',
      'position': 1,
      'points': 331,
      'races': 18,
      'wins': 7,
      'podiums': 11,
      'polePositions': 8,
      'team': 'Red Bull',
    },
    {
      'year': '2024 Singapore Grand Prix',
      'position': 1,
      'points': 331,
      'races': 18,
      'wins': 7,
      'podiums': 11,
      'polePositions': 8,
      'team': 'Red Bull',
    },
    {
      'year': '2024 Singapore Grand Prix',
      'position': 1,
      'points': 331,
      'races': 18,
      'wins': 7,
      'podiums': 11,
      'polePositions': 8,
      'team': 'Red Bull',
    },
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
                  'Races',
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
                  'Team(s)',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ],
            rows: driverSeasons.map((race) {
              return DataRow(cells: [
                DataCell(
                  GestureDetector(
                    onTap: () {
                      // Navigate to the race details screen
                      /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RaceDetailsScreen(race['name'])),
                    );*/
                    },
                    child: Text(
                      race['year'],
                      style: const TextStyle(
                          color: lightGradient, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataCell(
                  _buildPositionContainer(race['position']),
                ),
                DataCell(
                  Text(
                    race['points'].toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                DataCell(
                  Text(
                    race['races'].toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                DataCell(
                  Text(
                    race['wins'].toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                DataCell(
                  Text(
                    race['podiums'].toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                DataCell(
                  Text(
                    race['polePositions'].toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                DataCell(
                  Text(
                    race['team'].toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
      ),),),
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
