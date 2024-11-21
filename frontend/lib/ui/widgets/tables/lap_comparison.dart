import 'package:flutter/material.dart';
import 'package:frontend/core/models/lap_data.dart';

class LapComparisonTable extends StatelessWidget {
  final LapData driver1LapData;
  final LapData driver2LapData;

  const LapComparisonTable({
    Key? key,
    required this.driver1LapData,
    required this.driver2LapData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lapCount = driver1LapData.laps.length;
    return Scrollbar(
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
                columnSpacing: 16.0,
                columns: [
                  DataColumn(
                    label: Text(
                      '${driver1LapData.driverName} Position',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      '${driver1LapData.driverName} Lap Time',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Difference',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      '${driver2LapData.driverName} Position',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      '${driver2LapData.driverName} Lap Time',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                  lapCount,
                  (index) {
                    final lap1 = driver1LapData.laps[index];
                    final lap2 = driver2LapData.laps[index];
                    final timeDiff = _calculateTimeDifference(lap1.lapTime, lap2.lapTime);

                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            lap1.position.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        DataCell(
                          Text(
                            lap1.lapTime,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        DataCell(
                          Text(
                            timeDiff,
                            style: TextStyle(
                              color: _getDifferenceColour(timeDiff),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            lap2.position.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        DataCell(
                          Text(
                            lap2.lapTime,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _calculateTimeDifference(String time1, String time2) {
    final duration1 = _parseLapTime(time1);
    final duration2 = _parseLapTime(time2);

    final diff = duration1 - duration2;
    final sign = diff.isNegative ? '-' : '+';
    final absoluteDiff = diff.abs();

    return '$sign${absoluteDiff.inMinutes.remainder(60).toString().padLeft(2, '0')}:${absoluteDiff.inSeconds.remainder(60).toString().padLeft(2, '0')}.${(absoluteDiff.inMilliseconds.remainder(1000) / 10).round().toString().padLeft(2, '0')}';
  }

  Duration _parseLapTime(String lapTime) {
    final parts = lapTime.split(':');
    final minutes = int.parse(parts[0]);
    final seconds = double.parse(parts[1]);
    final wholeSeconds = seconds.truncate();
    final milliseconds = ((seconds - wholeSeconds) * 1000).round();

    return Duration(minutes: minutes, seconds: wholeSeconds, milliseconds: milliseconds);
  }

  Color _getDifferenceColour(String timeDiff) {
    if (timeDiff.startsWith('-')) {
      return Colors.red;
    } else if (timeDiff.startsWith('+')) {
      return Colors.green;
    } else {
      return Colors.black;
    }
  }
}
