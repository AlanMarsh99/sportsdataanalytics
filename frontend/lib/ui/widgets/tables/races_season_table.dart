import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/ui/responsive.dart';
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
  bool isAscending = true;
  int? sortColumnIndex;
  late AnimationController _animationController;
  Map<String, int> driverWins = {};
  Map<String, int> driverPolePositions = {};
  List<String> topDrivers = [];
  final ScrollController _chartScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _tableHorizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
    racesList = parseRaces(widget.races);
    filteredRacesList = List.from(racesList);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    processDriverStatistics();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _chartScrollController.dispose();
    _verticalScrollController.dispose();
    _tableHorizontalController.dispose();
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

      processDriverStatistics();
      _animationController.reset();
      _animationController.forward();
    });
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
      if (columnIndex == 0) {
        filteredRacesList.sort((a, b) {
          final dateA = DateTime.parse(a.date);
          final dateB = DateTime.parse(b.date);
          return ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
        });
      } else if (columnIndex == 1) {
        filteredRacesList.sort((a, b) {
          return ascending
              ? a.raceName.compareTo(b.raceName)
              : b.raceName.compareTo(a.raceName);
        });
      } else if (columnIndex == 2) {
        filteredRacesList.sort((a, b) {
          return ascending
              ? a.circuitName.compareTo(b.circuitName)
              : b.circuitName.compareTo(a.circuitName);
        });
      } else if (columnIndex == 3) {
        filteredRacesList.sort((a, b) {
          return ascending
              ? a.winner.compareTo(b.winner)
              : b.winner.compareTo(a.winner);
        });
      } else if (columnIndex == 4) {
        filteredRacesList.sort((a, b) {
          return ascending
              ? a.polePosition.compareTo(b.polePosition)
              : b.polePosition.compareTo(a.polePosition);
        });
      }

      processDriverStatistics();
      _animationController.reset();
      _animationController.forward();
    });
  }

  void processDriverStatistics() {
    driverWins.clear();
    driverPolePositions.clear();

    for (var race in filteredRacesList) {
      String winner = race.winner;
      driverWins[winner] = (driverWins[winner] ?? 0) + 1;

      String poleDriver = race.polePosition;
      driverPolePositions[poleDriver] = (driverPolePositions[poleDriver] ?? 0) + 1;
    }

    var sortedWins = driverWins.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    topDrivers = sortedWins.take(5).map((e) => e.key).toList();

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

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    return Scrollbar(
      thumbVisibility: true,
      controller: _verticalScrollController,
      child: SingleChildScrollView(
        controller: _verticalScrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: isMobile ? double.infinity : 500,
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
              const SizedBox(height: 16),

              // Table section with horizontal scrolling
              Scrollbar(
                thumbVisibility: true,
                controller: _tableHorizontalController,
                notificationPredicate: (notif) =>
                    notif.metrics.axis == Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _tableHorizontalController,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
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

              const SizedBox(height: 32),

              // Chart section below the table
              LayoutBuilder(
                builder: (context, constraints) {
                  bool isMobile = Responsive.isMobile(context);
                  double barWidth = isMobile ? 12 : 20;
                  double barSpace = isMobile ? 8 : 11;
                  double fontSize = isMobile ? 10 : 12;
                  double totalBarsWidth = topDrivers.isNotEmpty
                      ? (topDrivers.length * (barWidth * 2 + barSpace + 20))
                      : constraints.maxWidth;

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Top 5 Drivers - Wins and Pole Positions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 400,
                          child: Scrollbar(
                            thumbVisibility: true,
                            controller: _chartScrollController,
                            notificationPredicate: (scrollNotification) {
                              return scrollNotification.metrics.axis ==
                                  Axis.horizontal;
                            },
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _chartScrollController,
                              child: SizedBox(
                                width: totalBarsWidth < constraints.maxWidth
                                    ? constraints.maxWidth
                                    : totalBarsWidth,
                                child: AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return BarChart(
                                      BarChartData(
                                        alignment:
                                            BarChartAlignment.spaceBetween,
                                        maxY: getMaxYValue(),
                                        barGroups: topDrivers.isEmpty
                                            ? []
                                            : topDrivers.asMap().entries.map((entry) {
                                                int index = entry.key;
                                                String driver = entry.value;
                                                Color driverColor = getDriverColor(driver);
                                                double animatedWins = (driverWins[driver] ?? 0) * _animationController.value;
                                                double animatedPoles = (driverPolePositions[driver] ?? 0) * _animationController.value;

                                                return BarChartGroupData(
                                                  x: index,
                                                  barsSpace: barSpace,
                                                  barRods: [
                                                    BarChartRodData(
                                                      toY: animatedWins,
                                                      width: barWidth,
                                                      color: driverColor,
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(10),
                                                        topRight: Radius.circular(10),
                                                      ),
                                                      borderSide: const BorderSide(
                                                        color: Colors.black,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    BarChartRodData(
                                                      toY: animatedPoles,
                                                      width: barWidth,
                                                      color: driverColor.withOpacity(0.5),
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(10),
                                                        topRight: Radius.circular(10),
                                                      ),
                                                      borderSide: const BorderSide(
                                                        color: Colors.black,
                                                        width: 0.7,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                        titlesData: FlTitlesData(
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              interval: getLeftTitlesInterval(),
                                              reservedSize: 40,
                                              getTitlesWidget: (value, meta) {
                                                return Text(
                                                  value.toInt().toString(),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: fontSize,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                );
                                              },
                                            ),
                                          ),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              interval: 1,
                                              getTitlesWidget: (value, meta) {
                                                int idx = value.toInt();
                                                if (idx >= 0 &&
                                                    idx < topDrivers.length) {
                                                  return Transform.rotate(
                                                    angle: isMobile ? -0.5 : 0.0,
                                                    child: Text(
                                                      topDrivers[idx],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: fontSize,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return const SizedBox.shrink();
                                                }
                                              },
                                            ),
                                          ),
                                          topTitles: AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                          rightTitles: AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                        ),
                                        borderData: FlBorderData(show: false),
                                        gridData: FlGridData(
                                          show: true,
                                          drawVerticalLine: false,
                                          horizontalInterval:
                                              getLeftTitlesInterval(),
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
                                              String driverName = topDrivers[group.x.toInt()];
                                              String title = rodIndex == 0
                                                  ? 'Wins'
                                                  : 'Pole Positions';
                                              return BarTooltipItem(
                                                '$driverName\n$title: ${rod.toY.toInt()}',
                                                const TextStyle(
                                                  color: Colors.white,
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
