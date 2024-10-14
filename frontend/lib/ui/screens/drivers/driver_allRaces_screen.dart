import 'package:flutter/material.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/tables/driver_allRaces_table.dart';

class DriverAllRacesScreen extends StatefulWidget {
  const DriverAllRacesScreen({
    Key? key,
  }) : super(key: key);

  _DriverAllRacesScreenState createState() => _DriverAllRacesScreenState();
}

class _DriverAllRacesScreenState extends State<DriverAllRacesScreen> {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DRIVERS',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 16),
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
              Expanded(
                child: Center(
                  child: DriverAllRacesTableScreen(),
                ),
              ),
            ],
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
        value: 'Max Verstappen',
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: const SizedBox(),
        items: <String>['Max Verstappen', 'Lewis Hamilton', 'Sebastian Vettel']
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
        value: '2024',
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: const SizedBox(),
        items: <String>['2024', '2023', '2022', '2021', '2020', '2019', '2018']
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
