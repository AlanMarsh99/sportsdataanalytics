import 'package:flutter/material.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/ui/screens/drivers/driver_allRaces_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/tables/driver_seasons_table.dart';

class RacesDetailScreen extends StatefulWidget {
  const RacesDetailScreen({Key? key, required this.race}) : super(key: key);

  final Race race;

  _RacesDetailScreenState createState() => _RacesDetailScreenState();
}

class _RacesDetailScreenState extends State<RacesDetailScreen> {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.race.name,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 16),
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
                _buildInfoContainer('Pole position', widget.race.polePosition),
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
                Expanded(
                  child: TabBarView(
                    children: [
                      Center(
                        child: DriverSeasonsTable(),
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
