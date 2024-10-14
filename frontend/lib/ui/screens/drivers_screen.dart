import 'package:flutter/material.dart';
import 'package:frontend/ui/screens/driver_allRaces_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/tables/driver_seasons_table.dart';

class DriversScreen extends StatefulWidget {
  const DriversScreen({
    Key? key,
  }) : super(key: key);

  _DriversScreenState createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Container(
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
                  'DRIVERS',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 16),
                _buildDriverDropdown(),
                const SizedBox(height: 40),
                const Text(
                  'CAREER STATS',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const TabBar(
                    //padding: EdgeInsets.only(left: 6),
                    labelColor: redAccent,
                    unselectedLabelColor: Colors.white,
                    indicatorColor: redAccent,
                    dividerHeight: 0,
                    isScrollable: true,
                    tabs: [
                      Tab(text: "All time"),
                      Tab(text: "Current season"),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // TabBarView for the content of each tab
                Container(
                  height: 250,
                  child: TabBarView(
                    children: [
                      _buildCareerStats(),
                      _buildCareerStats(),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'SEASONS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                //const Spacer(),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to the "All Races" screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DriverAllRacesScreen()),
                      );
                    },
                    child: const Text(
                      'All races >',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Center(child: DriverSeasonsTable(),
                ),),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildCareerStats() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCard(61, 203, 'WINS', true),
            _buildStatCard(109, 203, 'PODIUMS', true),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCard(3, 10, 'CHAMPIONSHIPS', false),
            _buildStatCard(40, 203, 'POLE POSITIONS', false),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(int stat, int total, String label, bool hasPercentage) {
    int percentage = (stat * 100 / total).truncate();
    return Container(
      width: 155,
      height: 100,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                stat.toString(),
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                '/$total',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
              Visibility(
                visible: hasPercentage,
                child: const SizedBox(width: 10),
              ),
              Visibility(
                visible: hasPercentage,
                child: Text(
                  '($percentage %)',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: redAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
