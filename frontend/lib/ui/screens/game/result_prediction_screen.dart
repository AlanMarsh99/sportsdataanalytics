import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_phoenix/generated/i18n.dart';
import 'package:frontend/core/models/prediction.dart';
import 'package:frontend/core/models/race_league.dart';
import 'package:frontend/core/models/user_app.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/ui/theme.dart';

class ResultPredictionScreen extends StatefulWidget {
  const ResultPredictionScreen(
      {Key? key,
      required this.user,
      required this.predictions,
      required this.races,
      required this.race})
      : super(key: key);

  final UserApp user;
  final List<Prediction> predictions;
  final List<RaceLeague> races;
  final RaceLeague race;

  _ResultPredictionScreenState createState() => _ResultPredictionScreenState();
}

class _ResultPredictionScreenState extends State<ResultPredictionScreen> {
  late RaceLeague selectedRace;
  late Prediction selectedPrediction;

  @override
  void initState() {
    super.initState();
    selectedRace = widget.race;
    selectedPrediction = widget.predictions.firstWhere((element) =>
        element.round == selectedRace.round &&
        element.year == selectedRace.year &&
        element.userId == widget.user.id);
  }

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
                    '${widget.user.username} predictions',
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
            items: widget.races.map((race) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedRace = race;
                        selectedPrediction = widget.predictions.firstWhere(
                            (element) =>
                                element.round == selectedRace.round &&
                                element.year == selectedRace.year &&
                                element.userId == widget.user.id);
                      });
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              Globals.countryFlags[race.country]! ?? "",
                              width: 30.0,
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                          ],
                        ),
                        if (selectedRace == race)
                          Container(
                            width: 40,
                            height: 4.0,
                            color: secondary,
                          ),
                      ],
                    ),
                  ));
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
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                selectedPrediction.raceName!,
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width + 50,
                      child: const Divider(color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 95),
                            child: Container(
                              width: 115,
                              child: const Text(
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
                              widget.user.username.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Text(
                            'AI',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width + 50,
                      child: const Divider(color: Colors.grey, height: 20),
                    ),
                    _buildResultRow(
                        'Podium',
                        selectedPrediction.actualPodiumNames!,
                        selectedPrediction.podiumNames!,
                        ['Norris, L', 'Verstappen, M', 'Piastri, O']),
                    SizedBox(
                      width: MediaQuery.of(context).size.width + 50,
                      child: const Divider(color: Colors.grey, height: 20),
                    ),
                    _buildResultRow(
                        'Winner',
                        [selectedPrediction.actualWinnerName!],
                        [selectedPrediction.winnerName!],
                        ['Verstappen, M']),
                    SizedBox(
                      width: MediaQuery.of(context).size.width + 50,
                      child: const Divider(color: Colors.grey, height: 20),
                    ),
                    _buildResultRow(
                        'Fastest lap',
                        [selectedPrediction.actualFastestLapName!],
                        [selectedPrediction.fastestLapName!],
                        ['Verstappen, M']),
                    SizedBox(
                      width: MediaQuery.of(context).size.width + 50,
                      child: const Divider(color: Colors.grey, height: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, List<String> actualResults,
      List<String> userResults, List<String> AIResults) {
    String points = '';
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
        return Colors.green;
      case 'Winner':
        return Colors.red;
      case 'Fastest lap':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
