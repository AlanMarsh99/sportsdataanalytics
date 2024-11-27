import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/models/driver.dart';
import 'package:frontend/core/models/lap_data.dart';
import 'package:frontend/core/models/prediction.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/carousel_game_options.dart';

class PredictFastestLapScreen extends StatefulWidget {
  const PredictFastestLapScreen({
    Key? key,
    required this.prediction,
    required this.drivers,
  }) : super(key: key);

  final Prediction prediction;
  final List<DriverInfo> drivers;

  _PredictFastestLapScreenState createState() =>
      _PredictFastestLapScreenState();
}

class _PredictFastestLapScreenState extends State<PredictFastestLapScreen> {
  DriverInfo? selectedDriver;
  String? disabledDriverId;

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
                  const Text(
                    'Fastest Lap Prediction',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _predictPodiumContainer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _predictPodiumContainer() {
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
          Container(
            width: double.infinity,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3 of 3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Predict which driver will set the fastest lap in the United States Grand Prix',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                )),
          ),
          const SizedBox(height: 25),
          _buildPodiumContainer(),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select the driver with the fastest lap",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: widget.drivers.length,
              itemBuilder: (context, index) {
                DriverInfo driver = widget.drivers[index];
                bool isDisabled = disabledDriverId == driver.driverId;
                return _buildDriverTile(driver, isDisabled);
              },
            ),
          ),
          Visibility(
            visible: selectedDriver != null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              width: 200,
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
                  Prediction newPrediction = widget.prediction;
                  newPrediction.id = FirebaseFirestore.instance
                      .collection('predictions')
                      .doc()
                      .id;
                  newPrediction.fastestLapId = selectedDriver!.driverId;
                  newPrediction.fastestLapName = selectedDriver!.driverName;
                  //newPrediction.timestamp = FieldValue.serverTimestamp();

                  Map<String, dynamic> predictionData = newPrediction.toMap();

                  // Add the server timestamp to the map
                  predictionData['timestamp'] = FieldValue.serverTimestamp();

                  try {
                    // Save predictions in the database
                    await FirebaseFirestore.instance
                        .collection('predictions')
                        .doc(newPrediction.id)
                        .set(predictionData);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => F1Carousel(),
                      ),
                    );
                  } catch (e) {
                    print('Error saving prediction');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error: Failed to save prediction'),
                        backgroundColor: secondary,
                      ),
                    );
                  }
                },
                child: const Text(
                  'SAVE PREDICTIONS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Winner Container
  Widget _buildPodiumContainer() {
    return DragTarget<DriverInfo>(
      onAcceptWithDetails: (driver) {
        setState(() {
          selectedDriver = driver.data;
          disabledDriverId = driver.data.driverId;
        });
      },
      builder: (context, candidateData, rejectedData) {
        DriverInfo? driver = selectedDriver;
        return Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: 75,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: driver == null ? Colors.transparent : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white),
              ),
              child: driver == null
                  ? Center(
                      child: Text(
                        "Make your prediction",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          driver.driverName,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          driver.teamName!,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
            ),
            if (driver != null)
              Positioned(
                right: -4,
                top: -4,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDriver = null;
                      disabledDriverId = null;
                    });
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // Driver List Tile
  Widget _buildDriverTile(DriverInfo driver, bool isDisabled) {
    return LongPressDraggable<DriverInfo>(
      data: driver,
      feedback: Material(
        color: Colors.transparent,
        child: _buildDriverCard(driver, true),
      ),
      onDragCompleted: () {},
      maxSimultaneousDrags: isDisabled ? 0 : 1,
      child: _buildDriverCard(driver, isDisabled),
    );
  }

  // Driver Card (UI component for each driver)
  Widget _buildDriverCard(DriverInfo driver, bool isDisabled) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: ListTile(
          onTap: () {
            if (!isDisabled) {
              setState(() {
                if (selectedDriver == null) {
                  selectedDriver = driver;
                  disabledDriverId = driver.driverId;
                }
              });
            }
          },
          leading: const Icon(Icons.flag, color: secondary),
          title: Text(
            driver.driverName,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            driver.teamName!,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
