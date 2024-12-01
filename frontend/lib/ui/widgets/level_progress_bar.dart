import 'package:flutter/material.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/theme.dart';

class LevelProgressBar extends StatelessWidget {
  final int currentLevel;
  final int currentPoints;
  final int pointsToNextLevel;

  const LevelProgressBar({
    Key? key,
    required this.currentLevel,
    required this.currentPoints,
    required this.pointsToNextLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = currentPoints / pointsToNextLevel;
    bool isMobile = Responsive.isMobile(context);

    return Tooltip(
      message: 'Level $currentLevel',
      child: Container(
        width: isMobile
            ? MediaQuery.of(context).size.width * 0.5
            : MediaQuery.of(context).size.width * 0.2,
        child: Row(
          children: [
            // Level Badge
            Container(
              padding: EdgeInsets.all(isMobile ? 8.0 : 10.0),
              decoration: const BoxDecoration(
                color: secondary,
                shape: BoxShape.circle,
              ),
              child: Text(
                currentLevel.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 16 : 18,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Progress Bar and Points Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Bar
                  Stack(
                    children: [
                      // Background Bar
                      Container(
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      // Filled Progress
                      FractionallySizedBox(
                        widthFactor: progress, // Fraction of the bar filled
                        child: Container(
                          height: 15,
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Points Text
                  Text(
                    '$currentPoints / $pointsToNextLevel',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
