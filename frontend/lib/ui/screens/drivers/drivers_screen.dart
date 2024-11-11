import 'package:flutter/material.dart';
import 'package:frontend/core/providers/data_provider.dart';
import 'package:frontend/core/services/API_service.dart';
import 'package:frontend/ui/screens/drivers/driver_allRaces_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/tables/driver_seasons_table.dart';
import 'package:frontend/data/data_provider.dart';
import 'package:provider/provider.dart';

class DriversScreen extends StatefulWidget {
  const DriversScreen({Key? key, this.driverId, this.driverName})
      : super(key: key);

  final String? driverId;
  final String? driverName;

  _DriversScreenState createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen> {
  late Future<List<dynamic>> _driversNamesFuture;
  late Future<Map<String, dynamic>> _driversStatsFuture;
  String? selectedDriver;
  int currentOffset = 0;
  final int limit = 50;
  List<String> seasons = [];
  String selectedSeason = '2024';
  Map<String, dynamic> driversMap = {};
  List<String> driversNames = [];
  bool firstTime = true;

  bool seasonChanged = false;
  bool driverChanged = false;

  @override
  void initState() {
    super.initState();
    // Generate a list with the years from 1950 to the current year
    int currentYear = DateTime.now().year;

    if (widget.driverId != null) {
      _driversStatsFuture =
          APIService().getDriverStats(widget.driverId!, currentYear);
      selectedDriver = widget.driverName;
    }
    for (int i = currentYear; i >= 1950; i--) {
      seasons.add(i.toString());
    }
    selectedSeason = currentYear.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Access the provider
    final dataProvider = Provider.of<DataProvider>(context);

    // Extract data from provider
    List<dynamic>? driversList = dataProvider.driversList;
    Map<String, dynamic>? driverStats = dataProvider.driverStats;

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
                  widget.driverId == null
                      ? const Text(
                          'DRIVERS',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 25, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'DRIVERS',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      seasonChanged
                          ? FutureBuilder<List<dynamic>>(
                              future: _driversNamesFuture,
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
                                  return _buildDriverDropdown(snapshot.data!);
                                }
                                return Container();
                              },
                            )
                          : driversList == null
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : _buildDriverDropdown(driversList),
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
                  driverChanged || widget.driverId != null
                      ? FutureBuilder<Map<String, dynamic>>(
                          future: _driversStatsFuture,
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
                                'Error: Failed to load driver stats',
                                style: TextStyle(color: Colors.white),
                              ); // Error handling
                            } else if (snapshot.hasData) {
                              Map<String, dynamic> data = snapshot.data!;

                              return Container(
                                height: 250,
                                child: TabBarView(
                                  children: [
                                    _buildCareerStats(true, data),
                                    _buildCareerStats(false, data),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          },
                        )
                      : driverStats == null
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Container(
                              height: 250,
                              child: TabBarView(
                                children: [
                                  _buildCareerStats(true, driverStats),
                                  _buildCareerStats(false, driverStats),
                                ],
                              ),
                            ),
                  const SizedBox(height: 5),
                  const Text(
                    'SEASONS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  //const Spacer(),

                  Container(
                    //height: 400,
                    child: Center(
                      child: driverChanged || widget.driverId != null
                          ? FutureBuilder<Map<String, dynamic>>(
                              future: _driversStatsFuture,
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
                                    'Error: Failed to load driver stats',
                                    style: TextStyle(color: Colors.white),
                                  ); // Error handling
                                } else if (snapshot.hasData) {
                                  Map<String, dynamic> data = snapshot.data!;

                                  return Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: TextButton(
                                          onPressed: () {
                                            // Navigate to the "All Races" screen
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DriverAllRacesScreen(
                                                  selectedDriver:
                                                      selectedDriver!,
                                                  driversMap: driversMap,
                                                  driversNames: driversNames,
                                                  driversStats: data,
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'All races >',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      DriverSeasonsTable(data: data)
                                    ],
                                  );
                                }
                                return Container();
                              },
                            )
                          : driverStats == null
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: TextButton(
                                        onPressed: () {
                                          // Navigate to the "All Races" screen
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DriverAllRacesScreen(
                                                selectedDriver: selectedDriver!,
                                                driversMap: driversMap,
                                                driversNames: driversNames,
                                                driversStats: driverStats!,
                                              ),
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
                                    DriverSeasonsTable(data: driverStats)
                                  ],
                                ),
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
            seasonChanged = true;
            _driversNamesFuture =
                APIService().getDriversInYear(int.parse(selectedSeason));
          });
        },
      ),
    );
  }

  Widget _buildDriverDropdown(List<dynamic> driversList) {
    if (driversList.isNotEmpty) {
      driversNames = [];
      driversMap = {};
      for (var driver in driversList) {
        driversMap[driver['driver_name']] = driver['driver_id'];
        driversNames.add(driver['driver_name']);
      }
      selectedDriver ??= driversNames[0];
      if (!driversNames.contains(selectedDriver)) {
        selectedDriver = driversNames[0];
      }
    }
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
        items: driversNames.map<DropdownMenuItem<String>>((String driverName) {
          return DropdownMenuItem<String>(
            value: driverName,
            child:
                Text(driverName, style: const TextStyle(color: Colors.black)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedDriver = newValue;
            driverChanged = true;
            _driversStatsFuture = APIService().getDriverStats(
                driversMap[selectedDriver], DateTime.now().year);
          });
        },
      ),
    );
  }

  Widget _buildCareerStats(bool allTime, Map<String, dynamic>? driversStats) {
    int wins = 0;
    int races = 0;
    int podiums = 0;
    int championships = 0;
    int polePositions = 0;

    if (allTime) {
      wins = driversStats!['all_time_stats']['total_wins'];
      races = driversStats!['all_time_stats']['total_races'];
      podiums = driversStats!['all_time_stats']['total_podiums'];
      championships = driversStats!['all_time_stats']['total_championships'];
      polePositions = driversStats!['all_time_stats']['total_pole_positions'];
    } else {
      wins = driversStats!['current_season_stats']['wins'];
      races = driversStats!['current_season_stats']['num_races'];
      podiums = driversStats!['current_season_stats']['podiums'];
      polePositions = driversStats!['current_season_stats']['pole_positions'];
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _buildStatCard(wins, races, 'WINS', true),
            ),
            SizedBox(width: 16),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _buildStatCard(podiums, races, 'PODIUMS', true),
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
              child: _buildStatCard(championships, 10, 'CHAMPIONSHIPS', false),
            ),
            SizedBox(width: 16),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child:
                  _buildStatCard(polePositions, races, 'POLE POSITIONS', false),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(int stat, int total, String label, bool hasPercentage) {
    int percentage = 0;
    try {
      percentage = (stat * 100 / total).truncate();
    } catch (e) {
      percentage = 0;
    }

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
