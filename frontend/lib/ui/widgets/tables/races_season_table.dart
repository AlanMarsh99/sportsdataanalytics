import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/ui/screens/races/races_detail_screen.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/ui/theme.dart';

class RacesSeasonTable extends StatefulWidget {
  const RacesSeasonTable({Key? key, required this.races}) : super(key: key);

  final List<dynamic> races;

  @override
  State<RacesSeasonTable> createState() => _RacesSeasonTableState();
}

class _RacesSeasonTableState extends State<RacesSeasonTable>
    with SingleTickerProviderStateMixin {
  List<Race> racesList = [];
  List<Race> filteredRacesList = [];
  bool isAscending = true; // Tracks sorting order
  int? sortColumnIndex;

  // Animation controller for the chart
  late AnimationController _animationController;

  // Data structures for driver statistics
  Map<String, int> driverWins = {};
  Map<String, int> driverPolePositions = {};
  List<String> topDrivers = [];

  @override
  void initState() {
    super.initState();
    racesList = parseRaces(widget.races);
    filteredRacesList = List.from(racesList);

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration of the animation
    );

    // Process data and identify top 5 drivers
    processDriverStatistics();

    // Start the animation when the widget is built
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Race> parseRaces(List<dynamic> jsonList) {
    return jsonList.map((json) => Race.fromJson(json)).toList();
  }

  void updateFilter(String value) {
    setState(() {
      final filter = value.toLowerCase();
      filteredRacesList = racesList.where((race) {
        return race.raceName.toLowerCase().contains(filter) ||
            race.date.toLowerCase().contains(filter) ||
            race.circuitName.toLowerCase().contains(filter) ||
            race.winner.toLowerCase().contains(filter) ||
            race.polePosition.toLowerCase().contains(filter);
      }).toList();

      // Recompute driver statistics based on filtered data
      processDriverStatistics();

      // Restart the animation when data changes
      _animationController.reset();
      _animationController.forward();
    });
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
      if (columnIndex == 0) {
        // Sort by Date
        filteredRacesList.sort((a, b) {
          final dateA = DateTime.parse(a.date);
          final dateB = DateTime.parse(b.date);
          return ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
        });
      } else if (columnIndex == 1) {
        // Sort by Race Name
        filteredRacesList.sort((a, b) {
          return ascending
              ? a.raceName.compareTo(b.raceName)
              : b.raceName.compareTo(a.raceName);
        });
      } else if (columnIndex == 2) {
        // Sort by Circuit Name
        filteredRacesList.sort((a, b) {
          return ascending
              ? a.circuitName.compareTo(b.circuitName)
              : b.circuitName.compareTo(a.circuitName);
        });
      } else if (columnIndex == 3) {
        // Sort by Winner
        filteredRacesList.sort((a, b) {
          return ascending
              ? a.winner.compareTo(b.winner)
              : b.winner.compareTo(a.winner);
        });
      } else if (columnIndex == 4) {
        // Sort by Pole Position
        filteredRacesList.sort((a, b) {
          return ascending
              ? a.polePosition.compareTo(b.polePosition)
              : b.polePosition.compareTo(a.polePosition);
        });
      }

      // Recompute driver statistics if sorting affects data
      processDriverStatistics();

      // Restart the animation when sorting changes
      _animationController.reset();
      _animationController.forward();
    });
  }

  void processDriverStatistics() {
    driverWins.clear();
    driverPolePositions.clear();

    for (var race in filteredRacesList) {
      // Count wins
      String winner = race.winner;
      driverWins[winner] = (driverWins[winner] ?? 0) + 1;

      // Count pole positions
      String poleDriver = race.polePosition;
      driverPolePositions[poleDriver] = (driverPolePositions[poleDriver] ?? 0) + 1;
    }

    // Determine top 5 drivers based on wins
    var sortedWins = driverWins.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Extract the top 5 driver names
    topDrivers = sortedWins.take(5).map((e) => e.key).toList();

    // If there are fewer than 5 drivers with wins, include drivers with highest pole positions
    if (topDrivers.length < 5) {
      var additionalDrivers = driverPolePositions.entries
          .where((entry) => !topDrivers.contains(entry.key))
          .toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      for (var entry in additionalDrivers) {
        if (topDrivers.length >= 5) break;
        topDrivers.add(entry.key);
      }
    }
  }

  // Generate chart data
  List<BarChartGroupData> generateChartData(double animationValue) {
    return topDrivers.asMap().entries.map((entry) {
      int index = entry.key;
      String driver = entry.value;
      Color driverColor = getDriverColor(driver); // Updated method

      double animatedWins = (driverWins[driver] ?? 0) * animationValue;
      double animatedPoles = (driverPolePositions[driver] ?? 0) * animationValue;

      return BarChartGroupData(
        x: index,
        barsSpace: 11,
        barRods: [
          BarChartRodData(
            toY: animatedWins,
            width: 20,
            color: driverColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), // Rounded top-left corner
              topRight: Radius.circular(10), // Rounded top-right corner
            ),
            borderSide: const BorderSide(
              color: Colors.black, // Black outline
              width: 1.0,
            ),
          ),
          BarChartRodData(
            toY: animatedPoles,
            width: 20,
            color: driverColor.withOpacity(0.5), // Lighter shade for pole positions
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), // Rounded top-left corner
              topRight: Radius.circular(10), // Rounded top-right corner
            ),
            borderSide: const BorderSide(
              color: Colors.black, // Black outline
              width: 0.7,
            ),
          ),
        ],
      );
    }).toList();
  }

  Color getDriverColor(String driverName) {
    return Globals.driverColors[driverName] ?? Colors.grey;
  }

  double getMaxYValue() {
    int maxWins = topDrivers
        .map((driver) => driverWins[driver] ?? 0)
        .fold(0, (prev, curr) => curr > prev ? curr : prev);
    int maxPoles = topDrivers
        .map((driver) => driverPolePositions[driver] ?? 0)
        .fold(0, (prev, curr) => curr > prev ? curr : prev);
    return (maxWins > maxPoles ? maxWins : maxPoles).toDouble() + 2;
  }

  double getLeftTitlesInterval() {
    double maxY = getMaxYValue();
    if (maxY <= 10) {
      return 1;
    } else if (maxY <= 50) {
      return 5;
    } else {
      return 10;
    }
  }

  Widget leftTitles(double value, TitleMeta meta) {
    return Text(
      value.toInt().toString(),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 10,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    int index = value.toInt();
    if (index >= 0 && index < topDrivers.length) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 8.0,
        child: Text(
          topDrivers[index],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Enter a driver, race, or circuit',
              hintStyle: const TextStyle(color: Colors.white70),
              labelText: 'Filter races',
              labelStyle: const TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            onChanged: updateFilter,
          ),
        ),
        Expanded(
          flex: 2,
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DataTable(
                      sortColumnIndex: sortColumnIndex,
                      sortAscending: isAscending,
                      columns: [
                        DataColumn(
                          label: InkWell(
                            onTap: () => onSort(0, !isAscending),
                            child: Row(
                              children: [
                                const Text(
                                  'Date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(
                                  isAscending
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataColumn(
                          label: InkWell(
                            onTap: () => onSort(1, !isAscending),
                            child: Row(
                              children: [
                                const Text(
                                  'Race',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(
                                  isAscending
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataColumn(
                          label: InkWell(
                            onTap: () => onSort(2, !isAscending),
                            child: Row(
                              children: [
                                const Text(
                                  'Circuit',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(
                                  isAscending
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataColumn(
                          label: InkWell(
                            onTap: () => onSort(3, !isAscending),
                            child: Row(
                              children: [
                                const Text(
                                  'Winner',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(
                                  isAscending
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataColumn(
                          label: InkWell(
                            onTap: () => onSort(4, !isAscending),
                            child: Row(
                              children: [
                                const Text(
                                  'Pole Position',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(
                                  isAscending
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      rows: filteredRacesList.map((race) {
                        return DataRow(cells: [
                          DataCell(
                            Text(
                              race.date,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          DataCell(
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RacesDetailScreen(race: race),
                                  ),
                                );
                              },
                              child: Text(
                                race.raceName,
                                style: const TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              race.circuitName,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          DataCell(
                            Text(
                              race.winner,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          DataCell(
                            Text(
                              race.polePosition,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Add space between table and graph
        const SizedBox(height: 16),
        // Expanded widget for chart
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chart Title
                  const Text(
                    'Top 5 Drivers - Wins and Pole Positions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16), // Space between title and chart
                  // Animated Chart
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceBetween,
                            maxY: getMaxYValue(),
                            barGroups:
                                generateChartData(_animationController.value),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: getLeftTitlesInterval(),
                                  reservedSize: 40,
                                  getTitlesWidget: leftTitles,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: bottomTitles,
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: getLeftTitlesInterval(),
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey.shade300,
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  String driverName =
                                      topDrivers[group.x.toInt()];
                                  String title =
                                      rodIndex == 0 ? 'Wins' : 'Pole Positions';
                                  return BarTooltipItem(
                                    '$driverName\n$title: ${rod.toY.toInt()}',
                                    const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration:
              BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
