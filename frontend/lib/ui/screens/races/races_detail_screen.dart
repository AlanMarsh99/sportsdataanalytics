import 'package:flutter/material.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/core/services/API_service.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/graphs/lap_graph.dart';
import 'package:frontend/ui/widgets/tables/race_results_table.dart';
import 'package:fl_chart/fl_chart.dart'; // Added for charting
import 'package:frontend/core/models/race_positions.dart'; // Added for race positions
import 'package:frontend/core/models/pit_stops.dart';
import 'package:frontend/ui/widgets/tables/pit_stop_table.dart';
import 'package:frontend/ui/widgets/tables/lap_comparison_table.dart';
import 'package:frontend/core/models/lap_data.dart';

class RacesDetailScreen extends StatefulWidget {
  const RacesDetailScreen({Key? key, required this.race}) : super(key: key);

  final Race race;

  _RacesDetailScreenState createState() => _RacesDetailScreenState();
}

class _RacesDetailScreenState extends State<RacesDetailScreen> {
  late Future<List<dynamic>> raceResults;
  bool resultsError = false;

  // Added for lap comparison
  Future<LapDataResponse?>? driver1LapDataFuture;
  Future<LapDataResponse?>? driver2LapDataFuture;
  String? selectedDriver1Id;
  String? selectedDriver2Id;
  List<DriverInfo> driversInRace = [];
  int year = -1;
  int round = -1;

  // Added for race positions
  late Future<RacePositions?> racePositions;
  bool racePositionsError = false;

  // Added for pit stops
  late Future<PitStopDataResponse?> pitStopData;
  bool pitStopError = false;

  @override
  void initState() {
    super.initState();
    try {
      round = int.parse(widget.race.round.split('/').first);
      year = int.parse(widget.race.date.split('-').first);
      raceResults = APIService().getRaceResults(year, round);
      racePositions = APIService().fetchRacePositions(year, round);
      pitStopData = APIService()
          .getPitStops(year, round)
          .then((jsonList) => PitStopDataResponse.fromJson(jsonList));
    } catch (e) {
      print(e);
      resultsError = true;
      racePositionsError = true;
      pitStopError = true;
    }

    selectedDriver1Id = widget.race.winnerDriverId;

    APIService()
        .fetchDriverLapData(year, round, selectedDriver1Id!)
        .then((response) {
      if (response != null) {
        setState(() {
          driversInRace = response.drivers;
          // Initialize selected drivers
          if (driversInRace.length >= 2) {
            selectedDriver1Id = driversInRace[0].driverId;
            selectedDriver2Id = driversInRace[1].driverId;
            // Fetch lap data for the selected drivers
            driver1LapDataFuture = APIService()
                .fetchDriverLapData(year, round, selectedDriver1Id!);
            driver2LapDataFuture = APIService()
                .fetchDriverLapData(year, round, selectedDriver2Id!);
          }
        });
      }
    }).catchError((error) {
      print('Error fetching drivers: $error');
    });
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
      child: Responsive.isMobile(context)
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                        Text(
                          widget.race.raceName,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: _buildSquareCard(
                              'Round', widget.race.round, true),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child:
                              _buildSquareCard('Date', widget.race.date, true),
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
                          child: _buildSquareCard(
                              'Location', widget.race.location, true),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: _buildSquareCard(
                              'Circuit', widget.race.circuitName, true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoContainer('Winner', widget.race.winner, true),
                    const SizedBox(height: 12),
                    _buildInfoContainer(
                        'Winning time', widget.race.winningTime, true),
                    const SizedBox(height: 12),
                    _buildInfoContainer(
                        'Pole position', widget.race.polePosition, true),
                    const SizedBox(height: 12),
                    _buildInfoContainer(
                        'Fastest lap', widget.race.fastestLap, true),
                    const SizedBox(height: 12),
                    _buildInfoContainer(
                        'Fastest lap time', widget.race.fastestLapTime, true),
                    const SizedBox(height: 12),
                    _buildInfoContainer('Fastest pitstop',
                        widget.race.fastestPitStopDriver, true),
                    const SizedBox(height: 12),
                    _buildInfoContainer('Fastest pitstop time',
                        widget.race.fastestPitStopTime, true),
                    const SizedBox(height: 12),
                    DefaultTabController(
                      length: 4, // Number of tabs
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const TabBar(
                              tabAlignment: TabAlignment.start,
                              labelColor: redAccent,
                              unselectedLabelColor: Colors.white,
                              unselectedLabelStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              indicatorColor: redAccent,
                              dividerHeight: 0,
                              isScrollable: true,
                              tabs: [
                                Tab(text: "Results"),
                                Tab(text: "Lap graph"),
                                Tab(text: "Lap times"),
                                Tab(text: "Pit stops"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // TabBarView for the content of each tab
                          Container(
                            height: 500,
                            child: TabBarView(
                              children: [
                                resultsError
                                    ? const Text('Error loading results')
                                    : FutureBuilder<List<dynamic>>(
                                        future: raceResults,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return const Text(
                                              'Error: Failed to load',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            );
                                          } else if (snapshot.hasData) {
                                            List<dynamic> results =
                                                snapshot.data!;

                                            for (var driver in results) {
                                              DriverInfo driverInfo =
                                                  DriverInfo(
                                                      driverId:
                                                          driver['driver_id'],
                                                      driverName:
                                                          driver['driver']);

                                              driversInRace.add(driverInfo);
                                            }
                                            return RaceResultsTable(
                                              data: results,
                                            );
                                          }
                                          return Container();
                                        }),
                                // Lap graphs Tab (Updated)
                                racePositionsError
                                    ? const Text('Error loading race positions',
                                        style: TextStyle(color: Colors.white))
                                    : FutureBuilder<RacePositions?>(
                                        future: racePositions,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                  color: Colors.white),
                                            );
                                          } else if (snapshot.hasError) {
                                            return const Text(
                                                'Error: Failed to load',
                                                style: TextStyle(
                                                    color: Colors.white));
                                          } else if (snapshot.hasData &&
                                              snapshot.data != null) {
                                            return Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: primary,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: LapGraphWidget(
                                                  racePositions:
                                                      snapshot.data!),
                                            );
                                          } else {
                                            return const Text(
                                                'No data available',
                                                style: TextStyle(
                                                    color: Colors.white));
                                          }
                                        },
                                      ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child:
                                              DropdownButtonFormField<String>(
                                            dropdownColor: primary,
                                            value: selectedDriver1Id,
                                            items: driversInRace.map((driver) {
                                              return DropdownMenuItem(
                                                value: driver.driverId,
                                                child: Text(driver.driverName,
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedDriver1Id = value;
                                                // Fetch lap data for the new driver
                                                driver1LapDataFuture =
                                                    APIService()
                                                        .fetchDriverLapData(
                                                            year,
                                                            round,
                                                            selectedDriver1Id!);
                                              });
                                            },
                                            decoration: const InputDecoration(
                                              labelText: 'Select Driver 1',
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: redAccent),
                                              ),
                                            ),
                                            iconEnabledColor: Colors.red,
                                            iconDisabledColor: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child:
                                              DropdownButtonFormField<String>(
                                            dropdownColor: primary,
                                            value: selectedDriver2Id,
                                            items: driversInRace.map((driver) {
                                              return DropdownMenuItem(
                                                value: driver.driverId,
                                                child: Text(driver.driverName,
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedDriver2Id = value;
                                                // Fetch lap data for the new driver
                                                driver2LapDataFuture =
                                                    APIService()
                                                        .fetchDriverLapData(
                                                            year,
                                                            round,
                                                            selectedDriver2Id!);
                                              });
                                            },
                                            decoration: const InputDecoration(
                                              labelText: 'Select Driver 2',
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: redAccent),
                                              ),
                                            ),
                                            iconEnabledColor: Colors.red,
                                            iconDisabledColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // Display the comparison table or a loading indicator
                                    if (driver1LapDataFuture != null &&
                                        driver2LapDataFuture != null)
                                      FutureBuilder<List<LapDataResponse?>>(
                                        future: Future.wait([
                                          driver1LapDataFuture!,
                                          driver2LapDataFuture!,
                                        ]),
                                        builder: (context,
                                            AsyncSnapshot<
                                                    List<LapDataResponse?>>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                  color: Colors.white),
                                            );
                                          } else if (snapshot.hasError) {
                                            return const Text(
                                              'Error loading lap data',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            );
                                          } else if (snapshot.hasData) {
                                            // Get the data from the snapshot
                                            final List<LapDataResponse?>
                                                responses = snapshot.data!;

                                            if (responses[0] != null &&
                                                responses[1] != null) {
                                              driversInRace =
                                                  responses[0]!.drivers;
                                              final LapData
                                                  driver1DataResponse =
                                                  responses[0]!.lapData;
                                              final LapData
                                                  driver2DataResponse =
                                                  responses[1]!.lapData;

                                              return Expanded(
                                                child: LapComparisonTable(
                                                    driver1LapData:
                                                        driver1DataResponse,
                                                    driver2LapData:
                                                        driver2DataResponse),
                                              );
                                            } else {
                                              return const Text(
                                                'No lap data available',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              );
                                            }
                                          } else {
                                            // This else block handles any other unexpected state
                                            return const Text(
                                              'No lap data available',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            );
                                          }
                                        },
                                      )
                                  ],
                                ),
                                pitStopError
                                    ? const Text(
                                        'Error loading pit stops',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : FutureBuilder<PitStopDataResponse?>(
                                        future: pitStopData,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                  color: Colors.white),
                                            );
                                          } else if (snapshot.hasError) {
                                            return const Text(
                                              'Error: Failed to load',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            );
                                          } else if (snapshot.hasData &&
                                              snapshot.data != null) {
                                            return PitStopsTable(
                                                data: snapshot.data!);
                                          } else {
                                            return const Text(
                                              'No data available',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            );
                                          }
                                        },
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                      Text(
                        widget.race.raceName,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'GENERAL INFO',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 26),
                            Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  fit: FlexFit.tight,
                                  child: _buildSquareCard(
                                      'Round', widget.race.round, false),
                                ),
                                const SizedBox(width: 16),
                                Flexible(
                                  flex: 2,
                                  fit: FlexFit.tight,
                                  child: _buildSquareCard(
                                      'Date', widget.race.date, false),
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
                                  child: _buildSquareCard(
                                      'Location', widget.race.location, false),
                                ),
                                const SizedBox(width: 16),
                                Flexible(
                                  flex: 2,
                                  fit: FlexFit.tight,
                                  child: _buildSquareCard('Circuit',
                                      widget.race.circuitName, false),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildInfoContainer(
                                'Winner', widget.race.winner, false),
                            const SizedBox(height: 12),
                            _buildInfoContainer(
                                'Winning time', widget.race.winningTime, false),
                            const SizedBox(height: 12),
                            _buildInfoContainer('Pole position',
                                widget.race.polePosition, false),
                            const SizedBox(height: 12),
                            _buildInfoContainer(
                                'Fastest lap', widget.race.fastestLap, false),
                            const SizedBox(height: 12),
                            _buildInfoContainer('Fastest lap time',
                                widget.race.fastestLapTime, false),
                            const SizedBox(height: 12),
                            _buildInfoContainer('Fastest pitstop',
                                widget.race.fastestPitStopDriver, false),
                            const SizedBox(height: 12),
                            _buildInfoContainer('Fastest pitstop time',
                                widget.race.fastestPitStopTime, false),
                          ],
                        ),
                      ),

                      const SizedBox(width: 30),
                      // TabBarView for the content of each tab

                      Flexible(
                        flex: 3,
                        child: DefaultTabController(
                          length: 4, // Number of tabs
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const TabBar(
                                  tabAlignment: TabAlignment.start,
                                  labelColor: redAccent,
                                  unselectedLabelColor: Colors.white,
                                  unselectedLabelStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  indicatorColor: redAccent,
                                  dividerHeight: 0,
                                  isScrollable: true,
                                  tabs: [
                                    Tab(text: "Results"),
                                    Tab(text: "Lap graph"),
                                    Tab(text: "Lap times"),
                                    Tab(text: "Pit stops"),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.78,
                                child: TabBarView(
                                  children: [
                                    resultsError
                                        ? const Text('Error loading results')
                                        : FutureBuilder<List<dynamic>>(
                                            future: raceResults,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return const Text(
                                                  'Error: Failed to load',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                );
                                              } else if (snapshot.hasData) {
                                                List<dynamic> results =
                                                    snapshot.data!;

                                                return RaceResultsTable(
                                                  data: results,
                                                );
                                              }
                                              return Container();
                                            }),
                                    // Lap graphs Tab (Updated)
                                    racePositionsError
                                        ? const Text(
                                            'Error loading race positions',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : FutureBuilder<RacePositions?>(
                                            future: racePositions,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: Colors.white),
                                                );
                                              } else if (snapshot.hasError) {
                                                return const Text(
                                                    'Error: Failed to load',
                                                    style: TextStyle(
                                                        color: Colors.white));
                                              } else if (snapshot.hasData &&
                                                  snapshot.data != null) {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    color: primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: LapGraphWidget(
                                                      racePositions:
                                                          snapshot.data!),
                                                );
                                              } else {
                                                return const Text(
                                                    'No data available',
                                                    style: TextStyle(
                                                        color: Colors.white));
                                              }
                                            },
                                          ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: DropdownButtonFormField<
                                                  String>(
                                                dropdownColor: primary,
                                                value: selectedDriver1Id,
                                                items:
                                                    driversInRace.map((driver) {
                                                  return DropdownMenuItem(
                                                    value: driver.driverId,
                                                    child: Text(
                                                        driver.driverName,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedDriver1Id = value;
                                                    // Fetch lap data for the new driver
                                                    driver1LapDataFuture =
                                                        APIService()
                                                            .fetchDriverLapData(
                                                                year,
                                                                round,
                                                                selectedDriver1Id!);
                                                  });
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Select Driver 1',
                                                  labelStyle: TextStyle(
                                                      color: Colors.white),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: redAccent),
                                                  ),
                                                ),
                                                iconEnabledColor: Colors.red,
                                                iconDisabledColor: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Flexible(
                                              child: DropdownButtonFormField<
                                                  String>(
                                                dropdownColor: primary,
                                                value: selectedDriver2Id,
                                                items:
                                                    driversInRace.map((driver) {
                                                  return DropdownMenuItem(
                                                    value: driver.driverId,
                                                    child: Text(
                                                        driver.driverName,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedDriver2Id = value;
                                                    // Fetch lap data for the new driver
                                                    driver2LapDataFuture =
                                                        APIService()
                                                            .fetchDriverLapData(
                                                                year,
                                                                round,
                                                                selectedDriver2Id!);
                                                  });
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Select Driver 2',
                                                  labelStyle: TextStyle(
                                                      color: Colors.white),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: redAccent),
                                                  ),
                                                ),
                                                iconEnabledColor: Colors.red,
                                                iconDisabledColor: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        // Display the comparison table or a loading indicator
                                        if (driver1LapDataFuture != null &&
                                            driver2LapDataFuture != null)
                                          FutureBuilder<List<LapDataResponse?>>(
                                            future: Future.wait([
                                              driver1LapDataFuture!,
                                              driver2LapDataFuture!,
                                            ]),
                                            builder: (context,
                                                AsyncSnapshot<
                                                        List<LapDataResponse?>>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: Colors.white),
                                                );
                                              } else if (snapshot.hasError) {
                                                return const Text(
                                                  'Error loading lap data',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                );
                                              } else if (snapshot.hasData) {
                                                // Get the data from the snapshot
                                                final List<LapDataResponse?>
                                                    responses = snapshot.data!;

                                                if (responses[0] != null &&
                                                    responses[1] != null) {
                                                  driversInRace =
                                                      responses[0]!.drivers;
                                                  final LapData
                                                      driver1DataResponse =
                                                      responses[0]!.lapData;
                                                  final LapData
                                                      driver2DataResponse =
                                                      responses[1]!.lapData;

                                                  return Expanded(
                                                    child: LapComparisonTable(
                                                        driver1LapData:
                                                            driver1DataResponse,
                                                        driver2LapData:
                                                            driver2DataResponse),
                                                  );
                                                } else {
                                                  return const Text(
                                                    'No lap data available',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  );
                                                }
                                              } else {
                                                // This else block handles any other unexpected state
                                                return const Text(
                                                  'No lap data available',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                );
                                              }
                                            },
                                          )
                                      ],
                                    ),
                                    pitStopError
                                        ? const Text(
                                            'Error loading pit stops',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : FutureBuilder<PitStopDataResponse?>(
                                            future: pitStopData,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: Colors.white),
                                                );
                                              } else if (snapshot.hasError) {
                                                return const Text(
                                                  'Error: Failed to load',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                );
                                              } else if (snapshot.hasData &&
                                                  snapshot.data != null) {
                                                return PitStopsTable(
                                                    data: snapshot.data!);
                                              } else {
                                                return const Text(
                                                  'No data available',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                );
                                              }
                                            },
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildInfoContainer(String label, String stat, bool isMobile) {
    return Container(
        height: isMobile ? 44 : 50,
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
              style: TextStyle(
                  fontSize: isMobile ? 14 : 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            Text(
              stat,
              style: TextStyle(
                  fontSize: isMobile ? 12 : 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ],
        ));
  }

  Widget _buildSquareCard(String label, String data, bool isMobile) {
    return Container(
      height: isMobile ? 90 : 100,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: isMobile ? 14 : 14,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            data,
            style: TextStyle(fontSize: isMobile ? 12 : 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
