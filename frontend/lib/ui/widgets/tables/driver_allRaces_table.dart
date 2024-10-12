import 'package:flutter/material.dart';
import 'package:frontend/ui/theme.dart';

class RaceTableScreen extends StatelessWidget {
  final List<Map<String, dynamic>> races = [
    {
      'name': '2024 Singapore Grand Prix',
      'result': 2,
      'qualifying': 1,
      'grid': 2,
    },
    {
      'name': '2024 Azerbaijan Grand Prix',
      'result': 5,
      'qualifying': 3,
      'grid': 6,
    },
    {
      'name': '2024 Italian Grand Prix',
      'result': 1,
      'qualifying': 2,
      'grid': 1,
    },
     {
      'name': '2024 Singapore Grand Prix',
      'result': 2,
      'qualifying': 1,
      'grid': 2,
    },
    {
      'name': '2024 Azerbaijan Grand Prix',
      'result': 5,
      'qualifying': 3,
      'grid': 6,
    },
    {
      'name': '2024 Italian Grand Prix',
      'result': 1,
      'qualifying': 2,
      'grid': 1,
    },
     {
      'name': '2024 Singapore Grand Prix',
      'result': 2,
      'qualifying': 1,
      'grid': 2,
    },
    {
      'name': '2024 Azerbaijan Grand Prix',
      'result': 5,
      'qualifying': 3,
      'grid': 6,
    },
    {
      'name': '2024 Italian Grand Prix',
      'result': 1,
      'qualifying': 2,
      'grid': 1,
    },
     {
      'name': '2024 Singapore Grand Prix',
      'result': 2,
      'qualifying': 1,
      'grid': 2,
    },
    {
      'name': '2024 Azerbaijan Grand Prix',
      'result': 5,
      'qualifying': 3,
      'grid': 6,
    },
    {
      'name': '2024 Italian Grand Prix',
      'result': 1,
      'qualifying': 2,
      'grid': 1,
    },
    // Add more races as needed
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                'Race',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            DataColumn(
              label: Text(
                'Qualifying',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            DataColumn(
              label: Text(
                'Grid',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            DataColumn(
              label: Text(
                'Result',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ],
          rows: races.map((race) {
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
                    race['name'],
                    style: const TextStyle(
                        color: lightGradient, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataCell(
                _buildPositionContainer(race['qualifying']),
              ),
              DataCell(
                Text(
                  race['grid'].toString(),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              DataCell(
                _buildPositionContainer(race['result']),
              ),
            ]);
          }).toList(),
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
