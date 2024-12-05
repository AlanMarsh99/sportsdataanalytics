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
  bool sortAscending = true; // Track the sorting order

  // State variables for sorting
  int? sortColumnIndex;
  bool isAscending = true;

  // Animation controller for the chart
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    teamsList = widget.data.map((json) => Team.fromJson(json)).toList();
    filteredTeamsList = List.from(teamsList);

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration of the animation
    );

    // Start the animation when the widget is built
    _animationController.forward();
  }

  @override
  void dispose() {
    // Dispose the animation controller to free resources
    _animationController.dispose();
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
    return Globals.teamColors[mappedName] ?? Colors.grey; // Use Globals.teamColors
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
      // Reapply sorting after filtering
      if (sortColumnIndex != null) {
        onSort(sortColumnIndex!, isAscending);
      }

      // Restart the animation when data changes
      _animationController.reset();
      _animationController.forward();
    });
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      if (columnIndex == 1) {
        // Sort by Wins
        filteredTeamsList.sort((a, b) {
          return compareNumeric(a.yearWins, b.yearWins, ascending);
        });
      } else if (columnIndex == 2) {
        // Sort by Podiums
        filteredTeamsList.sort((a, b) {
          return compareNumeric(a.yearPodiums, b.yearPodiums, ascending);
        });
      }
      sortColumnIndex = columnIndex;
      isAscending = ascending;

      // Restart the animation when sorting changes
      _animationController.reset();
      _animationController.forward();
    });
  }

  int compareNumeric(int a, int b, bool ascending) {
    if (ascending) {
      return a.compareTo(b);
    } else {
      return b.compareTo(a);
    }
  }

  List<BarChartGroupData> generateChartData(double animationValue) {
    return filteredTeamsList.asMap().entries.map((entry) {
      int index = entry.key;
      Team team = entry.value;
      Color teamColor = getTeamColor(team.name); // Get the team's color from Globals

      // Calculate the animated heights based on the animation value
      double animatedWins = team.yearWins.toDouble() * animationValue;
      double animatedPodiums = team.yearPodiums.toDouble() * animationValue;

      return BarChartGroupData(
        x: index,
        barsSpace: 11,
        barRods: [
          BarChartRodData(
            toY: animatedWins,
            width: 20,
            color: teamColor, // Use team color for wins
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), // Rounded top-left corner
              topRight: Radius.circular(10), // Rounded top-right corner
            ), // Rounded top edges only
            borderSide: const BorderSide(
              color: Colors.black, // Black outline
              width: 1.0,
            ),
          ),
          BarChartRodData(
            toY: animatedPodiums,
            width: 20,
            color: teamColor.withOpacity(0.5), // Lighter shade for podiums
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), // Rounded top-left corner
              topRight: Radius.circular(10), // Rounded top-right corner
            ), // Rounded top edges only
            borderSide: const BorderSide(
              color: Colors.black, // Black outline
              width: 0.7,
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
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
          ),
        ),
        // Expanded widget for table
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
                    child: DataTable(
                      sortColumnIndex: sortColumnIndex,
                      sortAscending: isAscending,
                      columns: [
                        const DataColumn(
                          label: Text(
                            'Team',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        DataColumn(
                          label: const Text(
                            'Wins',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
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
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          numeric: true,
                          onSort: (columnIndex, ascending) {
                            onSort(columnIndex, ascending);
                          },
                        ),
                        const DataColumn(
                          label: Text(
                            'Drivers',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ],
                      rows: filteredTeamsList.map((team) {
                        return DataRow(cells: [
                          DataCell(
                            TextButton(
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
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    team.name,
                                    style: const TextStyle(
                                        color: primary,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline),
                                  ),
                                ],
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
                          DataCell(
                            Text(
                              team.driversList.join(', '),
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
        // Add space between table and graph if needed
        const SizedBox(height: 16),
        // Expanded widget for graph
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chart Title
                    const Text(
                      'Season Performance',
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
                                  generateChartData(_animationController.value), // Pass animation value
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
                                  //tooltipBgColor: Colors.white,
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    String teamName =
                                        filteredTeamsList[group.x.toInt()].name;
                                    String title =
                                        rodIndex == 0 ? 'Wins' : 'Podiums';
                                    return BarTooltipItem(
                                      '$teamName\n$title: ${rod.toY.toInt()}',
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
        ),
      ],
    );
  }

  double getMaxYValue() {
    double maxWins = filteredTeamsList
        .map((team) => team.yearWins.toDouble())
        .fold(0, (prev, curr) => curr > prev ? curr : prev);
    double maxPodiums = filteredTeamsList
        .map((team) => team.yearPodiums.toDouble())
        .fold(0, (prev, curr) => curr > prev ? curr : prev);
    // Set maxY to the highest value among wins and podiums
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
    if (index >= 0 && index < filteredTeamsList.length) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 8.0,
        child: Text(
          filteredTeamsList[index].name,
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
}
