import 'package:flutter/material.dart';
import 'package:frontend/core/providers/data_provider.dart';
import 'package:frontend/ui/screens/drivers/driver_allRaces_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/tables/driver_seasons_table.dart';
import 'package:frontend/data/data_provider.dart';

class DriversScreen extends StatefulWidget {
  const DriversScreen({
    Key? key,
  }) : super(key: key);

  _DriversScreenState createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen> {
  late Future<List<dynamic>> _driversFuture;
  String? selectedDriver;
  int currentOffset = 0;
  final int limit = 50;
  List<String> seasons = [];
  String selectedSeason = '2024';

  @override
  void initState() {
    super.initState();
    // Generate a list with the years from 1950 to the current year
    int currentYear = DateTime.now().year;
    for (int i = currentYear; i >= 1950; i--) {
      seasons.add(i.toString());
    }
    selectedSeason = currentYear.toString();
    _driversFuture = DataProvider().getAllDrivers(
        /*limit: limit, offset: currentOffset*/); // Fetch the drivers
  }

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
            child: SingleChildScrollView(
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
                  Row(
                    children: [
                      FutureBuilder<List<dynamic>>(
                        future: _driversFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ); // Show loading while fetching
                          } else if (snapshot.hasError) {
                            return const Text(
                              'Error: Failed to load drivers',
                              style: TextStyle(color: Colors.white),
                            ); // Error handling
                          } else if (snapshot.hasData) {
                            selectedDriver ??= snapshot.data![0]['name'];
                            return _buildDriverDropdown(snapshot.data!);
                          }
                          return Container();
                        },
                      ),
                      SizedBox(width: 20),
                      _buildYearDropdown()
                    ],
                  ),

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
                            builder: (context) =>
                                DriverAllRacesScreen(driver: selectedDriver!),
                          ),
                        );
                      },
                      child: const Text(
                        'All races >',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 400,
                    child: Center(
                      child: DriverSeasonsTable(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildYearDropdown() {
    return Container(
      width: 100,
      height: 50,
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

  Widget _buildDriverDropdown(List<dynamic> drivers) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<String>(
        value: selectedDriver,
        hint: const Text(
          'Select a driver',
          style: TextStyle(color: Colors.black),
        ),
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: const SizedBox(),
        items: drivers.map<DropdownMenuItem<String>>((dynamic driver) {
          return DropdownMenuItem<String>(
            value:
                driver['name'], // Assuming the driver object has a 'name' field
            child: Text(driver['name'],
                style: const TextStyle(color: Colors.black)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedDriver = newValue;
          });
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
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _buildStatCard(61, 203, 'WINS', true),
            ),
            SizedBox(width: 16),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _buildStatCard(109, 203, 'PODIUMS', true),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _buildStatCard(3, 10, 'CHAMPIONSHIPS', false),
            ),
            SizedBox(width: 16),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _buildStatCard(40, 203, 'POLE POSITIONS', false),
            )
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
