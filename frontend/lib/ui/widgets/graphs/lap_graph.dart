import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/models/race_positions.dart';
import 'package:frontend/core/shared/globals.dart';

class LapGraphWidget extends StatelessWidget {
  final RacePositions racePositions;

  const LapGraphWidget({Key? key, required this.racePositions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<LineChartBarData> lineBarsData = [];
    List<DriverLegend> driverLegends = [];

    for (var driver in racePositions.drivers) {
      List<FlSpot> spots = [];
      for (int i = 0; i < driver.positions.length; i++) {
        int? position = driver.positions[i];
        if (position != null) {
          double lapNumber = 1 + i * 3;
          double positionValue = 21 - position.toDouble();
          spots.add(FlSpot(lapNumber, positionValue));
        }
      }

      Color color = Globals.driverColors[driver.driverName] ?? Colors.grey;

      lineBarsData.add(
        LineChartBarData(
          spots: spots,
          isCurved: false,
          color: color,
          barWidth: 2,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      );

      driverLegends.add(DriverLegend(name: driver.driverName, color: color));
    }

    Map<String, List<DriverLegend>> teamMap = {};
    for (var legend in driverLegends) {
      String? teamName = Globals.driverTeamMapping[legend.name];
      teamName ??= 'Unknown Team';
      teamMap.putIfAbsent(teamName, () => []);
      teamMap[teamName]!.add(legend);
    }

    List<String> sortedTeamNames = teamMap.keys.toList()..sort();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                lineBarsData: lineBarsData,
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text('Lap', style: TextStyle(color: Colors.white)),
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (value.toInt() == 1 || (value.toInt() - 1) % 3 == 0) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          );
                        } else {
                          return Container();
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
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                minY: 1,
                maxY: 20,
                minX: 1,
                maxX: 1 + (racePositions.laps.length - 1) * 3,
                borderData: FlBorderData(show: true),
                lineTouchData: LineTouchData(
                  enabled: true,
                  handleBuiltInTouches: true,
                  touchSpotThreshold: 10,
                  distanceCalculator: (touchPoint, spotPoint) {
                    final distance = (touchPoint - spotPoint).distance;
                    return distance < 20 ? distance : 999999;
                  },
                  touchTooltipData: LineTouchTooltipData(
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipItems: (touchedSpots) {
                      if (touchedSpots.isEmpty) return [];
                      final firstSpot = touchedSpots.first;
                      return [
                        LineTooltipItem(
                          driverLegends[firstSpot.barIndex].name,
                          const TextStyle(
                            color: Colors.white, // Tooltip text colour set to white
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ];
                    },
                  ),

                  getTouchedSpotIndicator: (barData, spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        FlLine(color: Colors.white, strokeWidth: 2),
                        FlDotData(show: true),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 200,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sortedTeamNames.map((teamName) {
                  final legends = teamMap[teamName]!;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          teamName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: legends.map((legend) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white.withOpacity(0.1),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      width: 12,
                                      height: 12,
                                      color: legend.color),
                                  const SizedBox(width: 4),
                                  Text(
                                    legend.name,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
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
