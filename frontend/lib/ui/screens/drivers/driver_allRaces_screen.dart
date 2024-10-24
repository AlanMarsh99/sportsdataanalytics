import 'package:flutter/material.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/tables/driver_allRaces_table.dart';

class DriverAllRacesScreen extends StatefulWidget {
  const DriverAllRacesScreen({
    Key? key,
    required this.driver,

  }) : super(key: key);

  final String driver;

  _DriverAllRacesScreenState createState() => _DriverAllRacesScreenState();
}

class _DriverAllRacesScreenState extends State<DriverAllRacesScreen> {
  List<String> seasons = [];
  String selectedSeason = '2024';
  String selectedDriver = '';

  @override
  void initState() {
    super.initState();
    // Generate a list with the years from 1950 to the current year
    int currentYear = DateTime.now().year;
    for (int i = currentYear; i >= 1950; i--) {
      seasons.add(i.toString());
    }
    selectedSeason = currentYear.toString();
    selectedDriver = widget.driver;
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
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 25, bottom: 10),
                  child: Text(
                    'DRIVERS',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                _buildDriverDropdown(),
                const SizedBox(height: 40),
                Row(
                  children: [
                    const Text(
                      'RACES OVERVIEW',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 29),
                    _buildYearDropdown(),
                  ],
                ),
                const SizedBox(height: 20),
                _buildRacesOverviewContainers(),
                const SizedBox(height: 30),
                Container(
                  height: 500,
                  child: Center(
                    child: DriverAllRacesTableScreen(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRacesOverviewContainers() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildRaceOverviewContainer('Position', 1, true),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildRaceOverviewContainer('Points', 575, false),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildRaceOverviewContainer('Wins', 19, false),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildRaceOverviewContainer('Podiums', 21, false),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildRaceOverviewContainer('Pole positions', 12, false),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildRaceOverviewContainer('DNF', 0, false),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildRaceOverviewContainer('DNS', 0, false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDriverDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<String>(
        value: selectedDriver,
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: const SizedBox(),
        items: <String>['Max Verstappen', 'Lewis Hamilton', 'Sebastian Vettel', widget.driver]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(color: Colors.black)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedDriver = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildRaceOverviewContainer(String label, int stat, bool isPosition) {
    String statString = stat.toString();
    if (isPosition) {
      if (statString.endsWith('1')) {
        if (statString == '11') {
          statString += 'th';
        } else {
          statString += 'st';
        }
      } else {
        if (statString.endsWith('2')) {
          if (statString == '12') {
            statString += 'th';
          } else {
            statString += 'nd';
          }
        } else {
          if (statString.endsWith('3')) {
            if (statString == '13') {
              statString += 'th';
            } else {
              statString += 'rd';
            }
          } else {
            statString += 'th';
          }
        }
      }
    }
    return Container(
        height: 40,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            Text(
              statString,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ],
        ));
  }

  Widget _buildYearDropdown() {
    return Container(
      width: 100,
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<String>(
        value: selectedSeason,
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: const SizedBox(),
        items: seasons
            .map<DropdownMenuItem<String>>((String value) {
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
