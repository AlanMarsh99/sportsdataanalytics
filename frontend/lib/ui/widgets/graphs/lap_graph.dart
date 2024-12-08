import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/models/race_positions.dart';

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
        dotData: const FlDotData(show: false),
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
                gridData: const FlGridData(show: true),
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
                lineTouchData: const LineTouchData(
                  enabled: false,
                ), // Disable touch interactions
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: driverLegends.map((driverLegend) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 12, height: 12, color: driverLegend.color),
                  const SizedBox(width: 4),
                  Text(driverLegend.name,
                      style: const TextStyle(color: Colors.white)),
                ],
              );
            }).toList(),
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
