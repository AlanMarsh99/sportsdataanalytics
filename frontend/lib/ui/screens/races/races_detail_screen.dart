import 'package:flutter/material.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/core/models/result.dart';
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
  List<Result> raceResults = [
    Result(
      id: 1,
      raceId: 'race1',
      driver: 'Max Verstappen',
      team: 'Red Bull Racing',
      position: 1,
      time: '1:30:45.300',
      grid: 1,
      laps: 70,
      points: 25,
    ),
    Result(
      id: 2,
      raceId: 'race1',
      driver: 'Lewis Hamilton',
      team: 'Mercedes',
      position: 2,
      time: '1:30:50.400',
      grid: 2,
      laps: 70,
      points: 18,
    ),
    Result(
      id: 3,
      raceId: 'race1',
      driver: 'Charles Leclerc',
      team: 'Ferrari',
      position: 3,
      time: '1:31:00.200',
      grid: 3,
      laps: 70,
      points: 15,
    ),
    Result(
      id: 4,
      raceId: 'race1',
      driver: 'Sergio Perez',
      team: 'Red Bull Racing',
      position: 4,
      time: '1:31:05.500',
      grid: 4,
      laps: 70,
      points: 12,
    ),
    Result(
      id: 5,
      raceId: 'race1',
      driver: 'Carlos Sainz',
      team: 'Ferrari',
      position: 5,
      time: '1:31:10.000',
      grid: 5,
      laps: 70,
      points: 10,
    ),
    Result(
      id: 6,
      raceId: 'race1',
      driver: 'Lando Norris',
      team: 'McLaren',
      position: 6,
      time: '1:31:15.800',
      grid: 6,
      laps: 70,
      points: 8,
    ),
    Result(
      id: 7,
      raceId: 'race1',
      driver: 'George Russell',
      team: 'Mercedes',
      position: 7,
      time: '1:31:20.900',
      grid: 7,
      laps: 70,
      points: 6,
    ),
    Result(
      id: 8,
      raceId: 'race1',
      driver: 'Fernando Alonso',
      team: 'Aston Martin',
      position: 8,
      time: '1:31:25.300',
      grid: 8,
      laps: 70,
      points: 4,
    ),
    Result(
      id: 9,
      raceId: 'race1',
      driver: 'Esteban Ocon',
      team: 'Alpine',
      position: 9,
      time: '1:31:30.100',
      grid: 9,
      laps: 70,
      points: 2,
    ),
    Result(
      id: 10,
      raceId: 'race1',
      driver: 'Pierre Gasly',
      team: 'Alpine',
      position: 10,
      time: '1:31:35.400',
      grid: 10,
      laps: 70,
      points: 1,
    ),
  ];

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
                    child: Text(
                      widget.race.name,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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
                          Globals.toDateFormat(widget.race.date),
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
                        child: _buildSquareCard('Circuit', widget.race.circuit),
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
                      'Fastest pitstop', widget.race.fastestPitStop),
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
                        Center(
                          child: RaceResultsTable(
                            results: raceResults,
                          ),
                        ),
                        Center(
                          child: DriverSeasonsTable(),
                        ),
                        Center(
                          child: DriverSeasonsTable(),
                        ),
                        Center(
                          child: DriverSeasonsTable(),
                        ),
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
