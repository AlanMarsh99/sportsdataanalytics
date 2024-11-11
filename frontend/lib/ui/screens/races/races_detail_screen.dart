import 'package:flutter/material.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/core/models/result.dart';
import 'package:frontend/core/services/API_service.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/ui/screens/drivers/driver_allRaces_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/tables/driver_seasons_table.dart';
import 'package:frontend/ui/widgets/tables/race_results_table.dart';

class RacesDetailScreen extends StatefulWidget {
  const RacesDetailScreen({Key? key, required this.race}) : super(key: key);

  final Race race;

  _RacesDetailScreenState createState() => _RacesDetailScreenState();
}

class _RacesDetailScreenState extends State<RacesDetailScreen> {
  late Future<List<dynamic>> raceResults;
  bool resultsError = false;

  @override
  void initState() {
    super.initState();
    int round = -1;
    int year = -1;
    try {
      round = int.parse(widget.race.round.split('/').first);
      year = int.parse(widget.race.date.split('-').first);
      raceResults = APIService().getRaceResults(year, round);
    } catch (e) {
      print(e);
      resultsError = true;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          body: Padding(
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
                          'Location',
                          widget.race.location,
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
                  _buildInfoContainer('Winning time', widget.race.winningTime),
                  const SizedBox(height: 12),
                  _buildInfoContainer(
                      'Pole position', widget.race.polePosition),
                  const SizedBox(height: 12),
                  _buildInfoContainer('Fastest lap', widget.race.fastestLap),
                  const SizedBox(height: 12),
                  _buildInfoContainer(
                      'Fastest lap time', widget.race.fastestLapTime),
                  const SizedBox(height: 12),
                  _buildInfoContainer(
                      'Fastest pitstop', widget.race.fastestPitStopDriver),
                  const SizedBox(height: 12),
                  _buildInfoContainer(
                      'Fastest pitstop time', widget.race.fastestPitStopTime),
                  const SizedBox(height: 12),
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
                        Container(),
                        Container(),
                        Container(),
                      ],
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
