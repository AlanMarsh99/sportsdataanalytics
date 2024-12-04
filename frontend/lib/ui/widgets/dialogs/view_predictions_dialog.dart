import 'package:flutter/material.dart';
import 'package:frontend/core/models/prediction.dart';
import 'package:frontend/ui/theme.dart';

class ViewPredictionsDialog extends StatelessWidget {
  final Prediction prediction;
  final String raceName;

  ViewPredictionsDialog({required this.prediction, required this.raceName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              "Your predictions for ${raceName}",
              style: const TextStyle(color: primary, fontWeight: FontWeight.bold),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close_rounded,
                size: 24,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Winner",
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: primary),
            ),
          ),
          const Divider(color: primary),
          Text(
            prediction.winnerName!,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(
            height: 20,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Podium",
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: primary),
            ),
          ),
          const Divider(color: primary),
          Text(
            prediction.podiumNames!.join(", "),
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(
            height: 20,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Fastest lap",
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: primary),
            ),
          ),
          const Divider(color: primary),
          Text(
            prediction.fastestLapName!,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
      actions: [
        Container(
          width: 100,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(secondary),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.0),
                ),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
