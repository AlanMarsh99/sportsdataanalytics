import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/core/models/team.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/screens/teams/teams_detail_screen.dart';
import 'package:frontend/ui/theme.dart';

class TeamsSeasonTable extends StatefulWidget {
  const TeamsSeasonTable({Key? key, required this.data}) : super(key: key);

  final List<dynamic> data;

  @override
  _TeamsSeasonTableState createState() => _TeamsSeasonTableState();
}

class _TeamsSeasonTableState extends State<TeamsSeasonTable>
    with SingleTickerProviderStateMixin {
  List<Team> teamsList = [];
  List<Team> filteredTeamsList = [];
  bool sortAscending = true;
  int? sortColumnIndex;
  bool isAscending = true;
  late AnimationController _animationController;

  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _tableHorizontalController = ScrollController();
  final ScrollController _chartHorizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
    teamsList = widget.data.map((json) => Team.fromJson(json)).toList();
    filteredTeamsList = List.from(teamsList);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _verticalScrollController.dispose();
    _tableHorizontalController.dispose();
    _chartHorizontalController.dispose();
    super.dispose();
  }

  static String getMappedTeamName(String apiTeamName) {
    return Globals.teamNameMapping[apiTeamName] ?? apiTeamName;
  }

  static String? getBadgePath(String teamName) {
    String mappedName = getMappedTeamName(teamName);
    return Globals.teamBadges[mappedName] ??
        'assets/teams/logos/placeholder.png';
  }

  Color getTeamColor(String teamName) {
    String mappedName = getMappedTeamName(teamName);
    return Globals.teamColors[mappedName] ?? Colors.grey;
  }

  void updateFilter(String value) {
    setState(() {
      final filter = value.toLowerCase();
      filteredTeamsList = teamsList.where((team) {
        final teamNameMatch = team.name.toLowerCase().contains(filter);
        final driversMatch = team.driversList
            .any((driver) => driver.toLowerCase().contains(filter));
        final winsMatch = team.yearWins.toString().contains(filter);
        final podiumsMatch = team.yearPodiums.toString().contains(filter);
        return teamNameMatch || driversMatch || winsMatch || podiumsMatch;
      }).toList();

      if (sortColumnIndex != null) {
        onSort(sortColumnIndex!, isAscending);
      }

      _animationController.reset();
      _animationController.forward();
    });
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      if (columnIndex == 1) {
        filteredTeamsList.sort((a, b) {
          return compareNumeric(a.yearWins, b.yearWins, ascending);
        });
      } else if (columnIndex == 2) {
        filteredTeamsList.sort((a, b) {
          return compareNumeric(a.yearPodiums, b.yearPodiums, ascending);
        });
      }
      sortColumnIndex = columnIndex;
      isAscending = ascending;

      _animationController.reset();
      _animationController.forward();
    });
  }

  int compareNumeric(int a, int b, bool ascending) {
    return ascending ? a.compareTo(b) : b.compareTo(a);
  }

  double getMaxYValue() {
    double maxWins = filteredTeamsList
        .map((team) => team.yearWins.toDouble())
        .fold(0, (prev, curr) => curr > prev ? curr : prev);
    double maxPodiums = filteredTeamsList
        .map((team) => team.yearPodiums.toDouble())
        .fold(0, (prev, curr) => curr > prev ? curr : prev);
    return (maxWins > maxPodiums ? maxWins : maxPodiums) + 2;
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
            padding: const EdgeInsets.only(top: 10),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      filter(isMobile),
                      const SizedBox(height: 16),

                      // Table section with horizontal scrolling
                      teamTable(isMobile),
                      const SizedBox(height: 16),

                      // Chart section below the table
                      seasonPerformanceGraph(isMobile)
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        filter(isMobile),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 3,
                              child: teamTable(isMobile),
                            ),
                            const SizedBox(width: 16),
                            Flexible(
                              flex: 4,
                              child: seasonPerformanceGraph(isMobile),
                            ),
                          ],
                        )
                      ])),
      ),
    );
  }

  Widget filter(bool isMobile) {
    return SizedBox(
      width: isMobile ? double.infinity : 500,
      child: TextField(
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'Enter a team, driver, wins, or podiums',
          hintStyle: const TextStyle(color: Colors.white70),
          labelText: 'Filter teams',
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
    );
  }

  Widget teamTable(bool isMobile) {
    return Scrollbar(
      thumbVisibility: true,
      controller: _tableHorizontalController,
      notificationPredicate: (notif) => notif.metrics.axis == Axis.horizontal,
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
            columnSpacing: isMobile ? 12 : 56, // Increased spacing for Team
            columns: [
              DataColumn(
                label: Text(
                  'Team',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              DataColumn(
                label: const Text(
                  'Wins',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                numeric: true,
                onSort: (columnIndex, ascending) {
                  onSort(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text(
                  'Podiums',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                numeric: true,
                onSort: (columnIndex, ascending) {
                  onSort(columnIndex, ascending);
                },
              ),
              if (!isMobile) // Conditionally include Drivers column
                const DataColumn(
                  label: Text(
                    'Drivers',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
            ],
            rows: filteredTeamsList.map((team) {
              return DataRow(cells: [
                DataCell(
                  SizedBox(
                    width: isMobile ? 150 : null, // Increased width on mobile
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamsDetailScreen(
                              teamId: team.id,
                              teamName: team.name,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            getBadgePath(team.name)!,
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 4),
                          Expanded( // Use Expanded to utilize available space
                            child: Text(
                              team.name,
                              style: const TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                              overflow: TextOverflow.ellipsis, // Handle overflow
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    team.yearWins.toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                DataCell(
                  Text(
                    team.yearPodiums.toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                if (!isMobile) // Conditionally include Drivers cell
                  DataCell(
                    SizedBox(
                      width: 140,
                      child: Text(
                        team.driversList.join(', '),
                        style: const TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis, // Handle overflow
                      ),
                    ),
                  ),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget seasonPerformanceGraph(bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double chartWidth = constraints.maxWidth;
        double barWidth = isMobile ? 12 : 20;
        double barSpace = isMobile ? 8 : 11;
        double fontSize = isMobile ? 10 : 12;

        double totalBarsWidth =
            (filteredTeamsList.length * (barWidth * 2 + barSpace + 20))
                .clamp(chartWidth, double.infinity);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Season Performance',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: isMobile ? 400 : 460,
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _chartHorizontalController,
                  notificationPredicate: (scrollNotification) {
                    return scrollNotification.metrics.axis ==
                        Axis.horizontal;
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _chartHorizontalController,
                    child: SizedBox(
                      width: totalBarsWidth,
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceBetween,
                              maxY: getMaxYValue(),
                              barGroups: filteredTeamsList
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = entry.key;
                                Team team = entry.value;
                                Color teamColor = getTeamColor(team.name);
                                double animatedWins = team.yearWins.toDouble() *
                                    _animationController.value;
                                double animatedPodiums =
                                    team.yearPodiums.toDouble() *
                                        _animationController.value;

                                return BarChartGroupData(
                                  x: index,
                                  barsSpace: barSpace,
                                  barRods: [
                                    BarChartRodData(
                                      toY: animatedWins,
                                      width: barWidth,
                                      color: teamColor,
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
                                      toY: animatedPodiums,
                                      width: barWidth,
                                      color: teamColor.withOpacity(0.5),
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
                                    reservedSize: 30,
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
                                    reservedSize: 35,
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      int idx = value.toInt();
                                      if (idx >= 0 &&
                                          idx < filteredTeamsList.length) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: Transform.rotate(
                                            angle: isMobile ? -0.5 : -0.3,
                                            child: Text(
                                              filteredTeamsList[idx].name,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: fontSize,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
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
                                    String teamName =
                                        filteredTeamsList[group.x.toInt()].name;
                                    String title =
                                        rodIndex == 0 ? 'Wins' : 'Podiums';
                                    return BarTooltipItem(
                                      '$teamName\n$title: ${rod.toY.toInt()}',
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
    );
  }
}
