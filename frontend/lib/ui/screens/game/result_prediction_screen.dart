import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend/ui/theme.dart';

class ResultPredictionScreen extends StatefulWidget {
  const ResultPredictionScreen(
      {Key? key, required this.userId, required this.raceId})
      : super(key: key);

  final String userId;
  final String raceId;

  _ResultPredictionScreenState createState() => _ResultPredictionScreenState();
}

class _ResultPredictionScreenState extends State<ResultPredictionScreen> {
  // List of flag images for the carousel slider
  final List<String> flagImages = [
    'assets/flags/france.png',
    'assets/flags/germany.png',
    'assets/flags/spain.png',
    'assets/flags/united-states.png',
    'assets/flags/italy.png',
    'assets/flags/united-kingdom.png',
    'assets/flags/france.png',
    'assets/flags/germany.png',
    'assets/flags/spain.png',
    'assets/flags/united-states.png',
    'assets/flags/italy.png',
    'assets/flags/united-kingdom.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [darkGradient, lightGradient],
        ),
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    '${widget.userId} predictions',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _predictionsContainer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _predictionsContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider(
            options: CarouselOptions(
                height: 50,
                autoPlay: false,
                enlargeCenterPage: true,
                reverse: true,
                viewportFraction: 0.2,
                enableInfiniteScroll: false),
            items: flagImages.map((imagePath) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  height: 30,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          // Race Title
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              //color: secondary,
              border: Border.all(
                color: secondary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'UNITED STATES GRAND PRIX',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 30),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.of(context).size.width + 50,
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                child: IntrinsicWidth(
                  child: Row(
                    children: [
                      // Race Results Table
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Race results',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const Divider(color: Colors.white),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 95),
                                  child: Container(
                                    width: 115,
                                    child: Text(
                                      'ACTUAL',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 115,
                                  child: Text(
                                    widget.userId.toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  'AI',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.grey, height: 20),
                          _buildResultRow(
                              'Podium',
                              ['Norris, L', 'Verstappen, M', 'Piastri, O'],
                              ['Norris, L', 'Verstappen, M', 'Piastri, O'],
                              ['Norris, L', 'Verstappen, M', 'Piastri, O'],
                              '+10'),
                          const Divider(color: Colors.grey, height: 20),
                          _buildResultRow('Winner', ['Norris, L'],
                              ['Verstappen, M'], ['Verstappen, M'], '+0'),
                          const Divider(color: Colors.grey, height: 20),
                          _buildResultRow('Fastest lap', ['Ricciardo, D'],
                              ['Verstappen, M'], ['Verstappen, M'], '+10'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, List<String> actualResults,
      List<String> userResults, List<String> AIResults, String points) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Column(
              children: [
                Container(
                  width: 80,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getLabelColor(label),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  points,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(width: 15),
            // Actual results
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: actualResults
                  .map(
                    (result) => Container(
                      width: 100,
                      child: Text(
                        result,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(width: 15),
            // User results
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: userResults
                  .map((result) => Container(
                      width: 100,
                      child: Text(
                        result,
                        style: const TextStyle(color: Colors.white),
                      )))
                  .toList(),
            ),
            const SizedBox(width: 15),
            // AI results
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AIResults.map((result) => Container(
                  width: 100,
                  child: Text(
                    result,
                    style: const TextStyle(color: Colors.white),
                  ))).toList(),
            ),
          ],
        ),
      ],
    );
  }

  // Helper method to get the label color
  Color _getLabelColor(String label) {
    switch (label) {
      case 'Podium':
        return Colors.orange;
      case 'Winner':
        return Colors.red;
      case 'Fastest lap':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
