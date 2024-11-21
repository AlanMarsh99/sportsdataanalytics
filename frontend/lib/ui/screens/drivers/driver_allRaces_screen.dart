import 'package:flutter/material.dart';
import 'package:frontend/core/services/API_service.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/tables/driver_allRaces_table.dart';

class DriverAllRacesScreen extends StatefulWidget {
  const DriverAllRacesScreen(
      {Key? key,
      required this.selectedDriver,
      required this.driversMap,
      required this.driversNames,
      required this.driversStats})
      : super(key: key);

  final String selectedDriver;
  final Map<String, dynamic> driversMap;
  final List<String> driversNames;
  final Map<String, dynamic> driversStats;

  _DriverAllRacesScreenState createState() => _DriverAllRacesScreenState();
}

class _DriverAllRacesScreenState extends State<DriverAllRacesScreen> {
  List<String> seasons = [];
  String selectedSeason = '2024';
  String selectedDriver = '';
  late Future<List<dynamic>> _driverRaceStats;
  late Future<Map<String, dynamic>> _driversStatsFuture;
  bool driverChanged = false;
  bool seasonChanged = false;

  @override
  void initState() {
    super.initState();
    int currentYear = DateTime.now().year;
    _driverRaceStats = APIService().getDriverRaceStats(
        widget.driversMap[widget.selectedDriver], currentYear);
    selectedDriver = widget.selectedDriver;
    selectedSeason = currentYear.toString();
  }

  /// Helper function to extract last name and retrieve image path
  String getDriverImagePath(String driverFullName) {
    // Split the full name into parts
    List<String> nameParts = driverFullName.trim().split(' ');

    // Assume the last part is the last name
    String lastName = nameParts.last;

    // Retrieve the image path from Globals.driverImages
    return Globals.driverImages[lastName] ?? 'assets/images/placeholder.png';
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
            child: Responsive.isMobile(context)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
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
                      _buildDriverDropdown(true),
                      const SizedBox(height: 40),
                      driverChanged || seasonChanged
                          ? FutureBuilder<Map<String, dynamic>>(
                              future: _driversStatsFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  /*return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ); // Show loading while fetching*/
                                  return Container();
                                } else if (snapshot.hasError) {
                                  return const Text(
                                    'Error: Failed to load driver race stats',
                                    style: TextStyle(color: Colors.white),
                                  ); // Error handling
                                } else if (snapshot.hasData) {
                                  Map<String, dynamic> data = snapshot.data!;

                                  return Column(children: [
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
                                        _buildYearDropdown(data),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    _buildRacesOverviewContainers(data),
                                  ]);
                                }
                                return Container();
                              },
                            )
                          : Column(
                              children: [
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
                                    _buildYearDropdown(widget.driversStats),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                _buildRacesOverviewContainers(
                                    widget.driversStats),
                              ],
                            ),
                      const SizedBox(height: 30),
                      FutureBuilder<List<dynamic>>(
                        future: _driverRaceStats,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ); // Show loading while fetching*/
                          } else if (snapshot.hasError) {
                            return const Text(
                              'Error: Failed to load driver race stats',
                              style: TextStyle(color: Colors.white),
                            ); // Error handling
                          } else if (snapshot.hasData) {
                            List<dynamic> data = snapshot.data!;

                            return Container(
                              height: 500,
                              child: Center(
                                child: DriverAllRacesTableScreen(data: data),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
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
                      _buildDriverDropdown(false),
                      const SizedBox(height: 40),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: driverChanged || seasonChanged
                                ? FutureBuilder<Map<String, dynamic>>(
                                    future: _driversStatsFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        /*return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ); // Show loading while fetching*/
                                        return Container();
                                      } else if (snapshot.hasError) {
                                        return const Text(
                                          'Error: Failed to load driver race stats',
                                          style: TextStyle(color: Colors.white),
                                        ); // Error handling
                                      } else if (snapshot.hasData) {
                                        Map<String, dynamic> data =
                                            snapshot.data!;

                                        return Column(children: [
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
                                              _buildYearDropdown(data),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          _buildRacesOverviewContainers(data),
                                          const SizedBox(height: 40),
                                          Center(
                                            child: CircleAvatar(
                                              radius: 120,
                                              backgroundColor: Colors.white,
                                              backgroundImage: AssetImage(
                                                getDriverImagePath(
                                                    selectedDriver!),
                                              ),
                                            ),
                                          ),
                                        ]);
                                      }
                                      return Container();
                                    },
                                  )
                                : Column(
                                    children: [
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
                                          _buildYearDropdown(
                                              widget.driversStats),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      _buildRacesOverviewContainers(
                                          widget.driversStats),
                                      const SizedBox(height: 40),
                                      Center(
                                        child: CircleAvatar(
                                          radius: 120,
                                          backgroundColor: Colors.white,
                                          backgroundImage: AssetImage(
                                            getDriverImagePath(selectedDriver!),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: FutureBuilder<List<dynamic>>(
                              future: _driverRaceStats,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ); // Show loading while fetching*/
                                } else if (snapshot.hasError) {
                                  return const Text(
                                    'Error: Failed to load driver race stats',
                                    style: TextStyle(color: Colors.white),
                                  ); // Error handling
                                } else if (snapshot.hasData) {
                                  List<dynamic> data = snapshot.data!;

                                  return Center(
                                      child:
                                          DriverAllRacesTableScreen(data: data),
                                    
                                  );
                                }
                                return Container();
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildRacesOverviewContainers(Map<String, dynamic> driversStats) {
    Map<String, dynamic> latestSeason = driversStats["season_results"].last;

    // Extrae los valores que te interesan
    //int numRaces = latestSeason["num_races"];
    int podiums = latestSeason["podiums"];
    String points = latestSeason["points"];
    int polePositions = latestSeason["pole_positions"];
    String position = latestSeason["position"];
    //String team = latestSeason["team"];
    int wins = latestSeason["wins"];
    //int year = latestSeason["year"];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildRaceOverviewContainer('Position', position, true),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildRaceOverviewContainer('Points', points, false),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child:
                  _buildRaceOverviewContainer('Wins', wins.toString(), false),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildRaceOverviewContainer(
                  'Podiums', podiums.toString(), false),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildRaceOverviewContainer(
            'Pole positions', polePositions.toString(), false),
        /*const SizedBox(height: 12),
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
        ),*/
      ],
    );
  }

  Widget _buildDriverDropdown(bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 300,
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
        items: widget.driversNames
            .map<DropdownMenuItem<String>>((String driverName) {
          return DropdownMenuItem<String>(
            value: driverName,
            child:
                Text(driverName, style: const TextStyle(color: Colors.black)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedDriver = newValue!;
            _driversStatsFuture = APIService().getDriverStats(
                widget.driversMap[selectedDriver], int.parse(selectedSeason));
            _driverRaceStats = APIService().getDriverRaceStats(
                widget.driversMap[selectedDriver], int.parse(selectedSeason));
            driverChanged = true;
          });
        },
      ),
    );
  }

  Widget _buildRaceOverviewContainer(
      String label, String stat, bool isPosition) {
    if (isPosition) {
      if (stat.endsWith('1')) {
        if (stat == '11') {
          stat += 'th';
        } else {
          stat += 'st';
        }
      } else {
        if (stat.endsWith('2')) {
          if (stat == '12') {
            stat += 'th';
          } else {
            stat += 'nd';
          }
        } else {
          if (stat.endsWith('3')) {
            if (stat == '13') {
              stat += 'th';
            } else {
              stat += 'rd';
            }
          } else {
            stat += 'th';
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
              stat,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ],
        ));
  }

  Widget _buildYearDropdown(Map<String, dynamic> driversStats) {
    List<String> years = (driversStats["season_results"] as List)
        .map((season) => season["year"].toString())
        .toList();

    if (!years.contains(selectedSeason)) {
      selectedSeason = years.last;
    }

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
        items: years.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(color: Colors.black)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedSeason = newValue!;
            seasonChanged = true;
            _driversStatsFuture = APIService().getDriverStats(
                widget.driversMap[selectedDriver], int.parse(selectedSeason));
            _driverRaceStats = APIService().getDriverRaceStats(
                widget.driversMap[selectedDriver], int.parse(selectedSeason));
          });
        },
      ),
    );
  }
}
