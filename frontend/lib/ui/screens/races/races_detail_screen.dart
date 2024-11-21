import 'package:flutter/material.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/core/models/result.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/core/services/API_service.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/screens/drivers/driver_allRaces_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/app_bar.dart';
import 'package:frontend/ui/widgets/drawer.dart';
import 'package:frontend/ui/widgets/tables/driver_seasons_table.dart';
import 'package:frontend/ui/widgets/tables/race_results_table.dart';
import 'package:fl_chart/fl_chart.dart'; // Added for charting
import 'package:provider/provider.dart';
import '../../widgets/end_drawer.dart'; // Added for race positions
import 'package:frontend/core/models/race_positions.dart'; // Added for race positions
import 'package:frontend/core/models/pit_stops.dart';
import 'package:frontend/ui/widgets/tables/pit_stop_table.dart';

class RacesDetailScreen extends StatefulWidget {
  const RacesDetailScreen({Key? key, required this.race}) : super(key: key);

  final Race race;

  _RacesDetailScreenState createState() => _RacesDetailScreenState();
}

class _RacesDetailScreenState extends State<RacesDetailScreen>
    with TickerProviderStateMixin {
  late Future<List<dynamic>> raceResults;
  bool resultsError = false;

  // Added for race positions
  late Future<RacePositions?> racePositions;
  bool racePositionsError = false;
  late AnimationController _controller;
  late Animation<double> _myAnimation;
  bool _flag = true;
  late List<NavigationRailDestination> _destinations;
  //var user = Provider.of<AuthProvider>(context).userCNC4;

  // Added for pit stops
  late Future<PitStopDataResponse?> pitStopData;
  bool pitStopError = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _myAnimation = CurvedAnimation(curve: Curves.linear, parent: _controller);
    int round = -1;
    int year = -1;
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
  }

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationProvider>(context);
    _destinations = nav.destinations;
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [darkGradient, lightGradient],
          ),
        ),
        child: Scaffold(
          appBar: MyAppBar(
            nav: nav,
            isMobile: Responsive.isMobile(context),
          ),
          drawer: MyDrawer(
            nav: nav,
            isMobile: Responsive.isMobile(context),
          ),
          endDrawer: const EndDrawer(),
          body: Responsive.isMobile(context)
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
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
                            SizedBox(width: 10),
                            Text(
                              widget.race.raceName,
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: _buildSquareCard(
                              'Round',
                              widget.race.round,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: _buildSquareCard(
                              'Date',
                              widget.race.date,
                              //Globals.toDateFormat(widget.race.date),
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
                                            return LapGraphWidget(
                                                racePositions: snapshot.data!);
                                          } else {
                                            return const Text(
                                                'No data available',
                                                style: TextStyle(
                                                    color: Colors.white));
                                          }
                                        },
                                      ),
                                Container(),
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
                          const SizedBox(width: 16),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: _buildSquareCard(
                                'Circuit', widget.race.circuitName),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      _buildInfoContainer('Winner', widget.race.winner),
                      const SizedBox(height: 12),
                      _buildInfoContainer(
                          'Winning time', widget.race.winningTime),
                      const SizedBox(height: 12),
                      _buildInfoContainer(
                          'Pole position', widget.race.polePosition),
                      const SizedBox(height: 12),
                      _buildInfoContainer(
                          'Fastest lap', widget.race.fastestLap),
                      const SizedBox(height: 12),
                      _buildInfoContainer(
                          'Fastest lap time', widget.race.fastestLapTime),
                      const SizedBox(height: 12),
                      _buildInfoContainer(
                          'Fastest pitstop', widget.race.fastestPitStopDriver),
                      const SizedBox(height: 12),
                      _buildInfoContainer('Fastest pitstop time',
                          widget.race.fastestPitStopTime),
                      const SizedBox(height: 12),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const TabBar(
                          labelColor: redAccent,
                          unselectedLabelColor: Colors.white,
                          unselectedLabelStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          indicatorColor: redAccent,
                          dividerHeight: 0,
                          isScrollable: true,
                          tabs: [
                            Tab(text: "Results"),
                            Tab(text: "Lap graphs"),
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
                                          style: TextStyle(color: Colors.white),
                                        );
                                      } else if (snapshot.hasData) {
                                        List<dynamic> results = snapshot.data!;
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
                                            style:
                                                TextStyle(color: Colors.white));
                                      } else if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        return LapGraphWidget(
                                            racePositions: snapshot.data!);
                                      } else {
                                        return const Text('No data available',
                                            style:
                                                TextStyle(color: Colors.white));
                                      }
                                    },
                                  ),
                            Container(),
                            Container(),
                          ],
                        ),
                      ),
                    ],
                  )),
                )
              : Row(
                  children: [
                    NavigationRail(
                      selectedIconTheme: IconThemeData(color: secondary),
                      unselectedIconTheme:
                          IconThemeData(color: Colors.white, opacity: 1),
                      extended: nav.extended,
                      selectedIndex: nav.selectedIndex,
                      destinations: _destinations,
                      onDestinationSelected: (value) {
                        nav.updateIndex(value);
                        Navigator.pop(context);
                      },
                      leading: IconButton(
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.menu_close,
                          color: Colors.white,
                          progress: _myAnimation,
                        ),
                        onPressed: () {
                          if (_flag) {
                            _controller.forward();
                          } else {
                            _controller.reverse();
                          }

                          _flag = !_flag;
                          if (nav.extended) {
                            nav.setExtended(false);
                          } else {
                            nav.setExtended(true);
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 25),
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
                                    SizedBox(width: 10),
                                    Text(
                                      widget.race.raceName,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        const Text(
                                          'GENERAL INFO',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 26),
                                        Row(
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              fit: FlexFit.tight,
                                              child: _buildSquareCard(
                                                'Round',
                                                widget.race.round,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Flexible(
                                              flex: 2,
                                              fit: FlexFit.tight,
                                              child: _buildSquareCard(
                                                'Date',
                                                widget.race.date,
                                                //Globals.toDateFormat(widget.race.date),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              fit: FlexFit.tight,
                                              child: _buildSquareCard(
                                                'Location',
                                                widget.race.location,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Flexible(
                                              flex: 2,
                                              fit: FlexFit.tight,
                                              child: _buildSquareCard('Circuit',
                                                  widget.race.circuitName),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        _buildInfoContainer(
                                            'Winner', widget.race.winner),
                                        const SizedBox(height: 12),
                                        _buildInfoContainer('Winning time',
                                            widget.race.winningTime),
                                        const SizedBox(height: 12),
                                        _buildInfoContainer('Pole position',
                                            widget.race.polePosition),
                                        const SizedBox(height: 12),
                                        _buildInfoContainer('Fastest lap',
                                            widget.race.fastestLap),
                                        const SizedBox(height: 12),
                                        _buildInfoContainer('Fastest lap time',
                                            widget.race.fastestLapTime),
                                        const SizedBox(height: 12),
                                        _buildInfoContainer('Fastest pitstop',
                                            widget.race.fastestPitStopDriver),
                                        const SizedBox(height: 12),
                                        _buildInfoContainer(
                                            'Fastest pitstop time',
                                            widget.race.fastestPitStopTime),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 30),
                                  // TabBarView for the content of each tab
                                  Flexible(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: const TabBar(
                                              tabAlignment: TabAlignment.start,
                                              labelColor: redAccent,
                                              unselectedLabelColor:
                                                  Colors.white,
                                              unselectedLabelStyle: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              indicatorColor: redAccent,
                                              dividerHeight: 0,
                                              isScrollable: true,
                                              tabs: [
                                                Tab(text: "Results"),
                                                Tab(text: "Lap graphs"),
                                                Tab(text: "Lap times"),
                                                Tab(text: "Pit stops"),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                100,
                                            child: TabBarView(
                                              children: [
                                                resultsError
                                                    ? const Text(
                                                        'Error loading results')
                                                    : FutureBuilder<
                                                            List<dynamic>>(
                                                        future: raceResults,
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            );
                                                          } else if (snapshot
                                                              .hasError) {
                                                            return const Text(
                                                              'Error: Failed to load',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            );
                                                          } else if (snapshot
                                                              .hasData) {
                                                            List<dynamic>
                                                                results =
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
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : FutureBuilder<
                                                        RacePositions?>(
                                                        future: racePositions,
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const Center(
                                                              child: CircularProgressIndicator(
                                                                  color: Colors
                                                                      .white),
                                                            );
                                                          } else if (snapshot
                                                              .hasError) {
                                                            return const Text(
                                                                'Error: Failed to load',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white));
                                                          } else if (snapshot
                                                                  .hasData &&
                                                              snapshot.data !=
                                                                  null) {
                                                            return LapGraphWidget(
                                                                racePositions:
                                                                    snapshot
                                                                        .data!);
                                                          } else {
                                                            return const Text(
                                                                'No data available',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white));
                                                          }
                                                        },
                                                      ),
                                                Container(),
                                                pitStopError
                                                    ? const Text(
                                                        'Error loading pit stops',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : FutureBuilder<
                                                        PitStopDataResponse?>(
                                                        future: pitStopData,
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const Center(
                                                              child: CircularProgressIndicator(
                                                                  color: Colors
                                                                      .white),
                                                            );
                                                          } else if (snapshot
                                                              .hasError) {
                                                            return const Text(
                                                              'Error: Failed to load',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            );
                                                          } else if (snapshot
                                                                  .hasData &&
                                                              snapshot.data !=
                                                                  null) {
                                                            return PitStopsTable(
                                                                data: snapshot
                                                                    .data!);
                                                          } else {
                                                            return const Text(
                                                              'No data available',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            );
                                                          }
                                                        },
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildInfoContainer(String label, String stat) {
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

  Widget _buildSquareCard(String label, String data) {
    return Container(
      height: 90,
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
            style: const TextStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            data,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// LapGraphWidget to display the lap-by-lap graph
class LapGraphWidget extends StatelessWidget {
  final RacePositions racePositions;

  const LapGraphWidget({Key? key, required this.racePositions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<LineChartBarData> lineBarsData = [];
    List<DriverLegend> driverLegends = [];

    // Define colors for the drivers
    List<Color> availableColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.pink,
      Colors.teal,
      Colors.lime,
    ];

    int colorIndex = 0;

    for (var driver in racePositions.drivers) {
      List<FlSpot> spots = [];

      for (int i = 0; i < driver.positions.length; i++) {
        int? position = driver.positions[i];
        if (position != null) {
          double lapNumber = 1 + i * 3; // Updated line
          double positionValue = position.toDouble();
          positionValue =
              21 - positionValue; // Invert to make first position at the top
          spots.add(FlSpot(lapNumber, positionValue));
        }
      }

      // Assign a color to the driver
      Color color = availableColors[colorIndex % availableColors.length];
      colorIndex++;

      LineChartBarData lineChartBarData = LineChartBarData(
        spots: spots,
        isCurved: false,
        color: color,
        barWidth: 2,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      );

      lineBarsData.add(lineChartBarData);

      // Add to driver legends
      driverLegends.add(DriverLegend(name: driver.driverName, color: color));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                lineBarsData: lineBarsData,
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text('Lap',
                        style: TextStyle(color: Colors.white)),
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1, // Set to 1 to evaluate each lap number
                      getTitlesWidget: (double value, TitleMeta meta) {
                        // Display label if lap is 1 or every 3 laps after that
                        if (value.toInt() == 1 ||
                            (value.toInt() - 1) % 3 == 0) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          );
                        } else {
                          return Container(); // Return empty container for other laps
                        }
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: const Text('Position',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        int position = (21 - value).toInt();
                        if (position >= 1 && position <= 20) {
                          return Text(
                            '$position',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize:
                                  10, // Added fontSize to make text smaller
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                minY: 1,
                maxY: 20,
                minX: 1,
                maxX: 1 + (racePositions.laps.length - 1) * 3,

                borderData: FlBorderData(show: true),
                lineTouchData:
                    LineTouchData(enabled: false), // Disable touch interactions
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: driverLegends.map((driverLegend) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          width: 12, height: 12, color: driverLegend.color),
                      const SizedBox(width: 4),
                      Text(driverLegend.name,
                          style: const TextStyle(color: Colors.white)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DriverLegend {
  final String name;
  final Color color;

  DriverLegend({required this.name, required this.color});
}
