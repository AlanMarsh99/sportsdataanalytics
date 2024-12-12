import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/screens/races/races_detail_screen.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/ui/theme.dart';

/// Helper class to define table columns
class TableColumnDefinition {
  final String label;
  final String key;

  TableColumnDefinition({required this.label, required this.key});
}

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

  // Define a list to hold the current visible columns
  List<TableColumnDefinition> visibleColumns = [];

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
      if (sortColumnIndex == columnIndex) {
        isAscending = !isAscending; // Toggle sort order if the same column is tapped
      } else {
        sortColumnIndex = columnIndex;
        isAscending = true; // Default to ascending when a new column is tapped
      }

      // Get the column key based on the current visible columns
      String? sortKey = visibleColumns.length > columnIndex
          ? visibleColumns[columnIndex].key
          : null;

      if (sortKey != null) {
        filteredRacesList.sort((a, b) {
          int comparison = 0;
          switch (sortKey) {
            case 'date':
              comparison =
                  DateTime.parse(a.date).compareTo(DateTime.parse(b.date));
              break;
            case 'raceName':
              comparison = a.raceName.compareTo(b.raceName);
              break;
            case 'circuitName':
              comparison = a.circuitName.compareTo(b.circuitName);
              break;
            case 'winner':
              comparison = a.winner.compareTo(b.winner);
              break;
            case 'polePosition':
              comparison = a.polePosition.compareTo(b.polePosition);
              break;
          }
          return ascending ? comparison : -comparison;
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
      driverPolePositions[poleDriver] =
          (driverPolePositions[poleDriver] ?? 0) + 1;
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

  /// Helper method to build DataColumn with required features
  DataColumn buildDataColumn(String label, int columnIndex) {
    return DataColumn(
      label: InkWell(
        onTap: () => onSort(columnIndex, isAscending),
        child: Container(
          padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min, // Adjusts to the content size
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4), // Spacing between text and icon
              // Conditionally display the sorting arrow
              if (sortColumnIndex == columnIndex)
                Icon(
                  isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  color: Colors.black,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Method to define visible columns based on screen size
  List<TableColumnDefinition> getVisibleColumns(bool isMobile) {
    if (isMobile) {
      return [
        TableColumnDefinition(label: 'Date', key: 'date'),
        TableColumnDefinition(label: 'Race', key: 'raceName'),
        TableColumnDefinition(label: 'Winner', key: 'winner'),
      ];
    } else {
      return [
        TableColumnDefinition(label: 'Date', key: 'date'),
        TableColumnDefinition(label: 'Race', key: 'raceName'),
        TableColumnDefinition(label: 'Circuit', key: 'circuitName'),
        TableColumnDefinition(label: 'Winner', key: 'winner'),
        TableColumnDefinition(label: 'Pole Position', key: 'polePosition'),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    visibleColumns = getVisibleColumns(isMobile);
    int totalVisibleColumns = visibleColumns.length;

    return Scrollbar(
      thumbVisibility: true,
      controller: _verticalScrollController,
      child: SingleChildScrollView(
        controller: _verticalScrollController,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
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
                      columnSpacing: isMobile ? 10 : 56,
                      columns: List.generate(visibleColumns.length, (index) {
                        return buildDataColumn(
                            visibleColumns[index].label, index);
                      }),
                      rows: filteredRacesList.map((race) {
                      List<DataCell> cells = [];

                      for (var column in visibleColumns) {
                        switch (column.key) {
                          case 'date':
                            cells.add(
                              DataCell(
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    race.date,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            );
                            break;
                          case 'raceName':
                            cells.add(
                              DataCell(
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    width: isMobile ? 130 : null,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RacesDetailScreen(race: race),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        race.raceName,
                                        style: TextStyle(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          fontSize: isMobile ? 14 : 16, // Slightly smaller font size on mobile
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                            break;
                          case 'circuitName':
                            cells.add(
                              DataCell(
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    width: isMobile ? 135 : null,
                                    child: Text(
                                      race.circuitName,
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            );
                            break;
                          case 'winner':
                            cells.add(
                              DataCell(
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    width: isMobile ? 80 : null,
                                    child: Text(
                                      race.winner,
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            );
                            break;
                          case 'polePosition':
                            cells.add(
                              DataCell(
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    width: isMobile ? 80 : null,
                                    child: Text(
                                      race.polePosition,
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            );
                            break;
                        }
                      }

                      return DataRow(cells: cells);
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
                                            : topDrivers
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                                int index = entry.key;
                                                String driver = entry.value;
                                                Color driverColor =
                                                    getDriverColor(driver);
                                                double animatedWins =
                                                    (driverWins[driver] ?? 0) *
                                                        _animationController
                                                            .value;
                                                double animatedPoles =
                                                    (driverPolePositions[
                                                                driver] ??
                                                            0) *
                                                        _animationController
                                                            .value;

                                                return BarChartGroupData(
                                                  x: index,
                                                  barsSpace: barSpace,
                                                  barRods: [
                                                    BarChartRodData(
                                                      toY: animatedWins,
                                                      width: barWidth,
                                                      color: driverColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors.black,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    BarChartRodData(
                                                      toY: animatedPoles,
                                                      width: barWidth,
                                                      color: driverColor
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                      borderSide:
                                                          const BorderSide(
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
                                              getTitlesWidget:
                                                  (value, meta) {
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
                                              getTitlesWidget:
                                                  (value, meta) {
                                                int idx = value.toInt();
                                                if (idx >= 0 &&
                                                    idx < topDrivers.length) {
                                                  return Transform.rotate(
                                                    angle:
                                                        isMobile ? -0.5 : 0.0,
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
                                                  return const SizedBox
                                                      .shrink();
                                                }
                                              },
                                            ),
                                          ),
                                          topTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                                showTitles: false),
                                          ),
                                          rightTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                                showTitles: false),
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
                                              color:
                                                  Colors.grey.shade300,
                                              strokeWidth: 1,
                                            );
                                          },
                                        ),
                                        barTouchData: BarTouchData(
                                          enabled: true,
                                          touchTooltipData:
                                              BarTouchTooltipData(
                                            getTooltipItem: (group,
                                                groupIndex, rod,
                                                rodIndex) {
                                              String driverName =
                                                  topDrivers[
                                                      group.x.toInt()];
                                              String title = rodIndex == 0
                                                  ? 'Wins'
                                                  : 'Pole Positions';
                                              return BarTooltipItem(
                                                '$driverName\n$title: ${rod.toY.toInt()}',
                                                const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.bold,
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
