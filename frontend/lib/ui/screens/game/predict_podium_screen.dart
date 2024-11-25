import 'package:flutter/material.dart';
import 'package:frontend/core/models/driver.dart';
import 'package:frontend/core/models/lap_data.dart';
import 'package:frontend/core/models/prediction.dart';
import 'package:frontend/ui/screens/game/predict_winner_screen.dart';
import 'package:frontend/ui/theme.dart';

class PredictPodiumScreen extends StatefulWidget {
  const PredictPodiumScreen({
    Key? key,
    required this.prediction,
    required this.drivers,
    required this.raceName,
  }) : super(key: key);

  final Prediction prediction;
  final List<DriverInfo> drivers;
  final String raceName;

  _PredictPodiumScreenState createState() => _PredictPodiumScreenState();
}

class _PredictPodiumScreenState extends State<PredictPodiumScreen> {
  List<DriverInfo?> selectedDrivers = [null, null, null];
  List<String> disabledDriverIds = [];


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
                    'Podium Prediction',
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
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '1 of 3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Predict your podium for the ${widget.raceName}',
                      style: const TextStyle(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) => _buildPodiumContainer(index)),
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select 3 drivers",
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
                bool isDisabled = disabledDriverIds.contains(driver.driverId);
                return _buildDriverTile(driver, isDisabled);
              },
            ),
          ),
          Visibility(
            visible:
                selectedDrivers.indexWhere((element) => element == null) == -1,
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
                onPressed: () {
                  Prediction newPrediction = widget.prediction;
                  newPrediction.podiumIds = selectedDrivers
                      .map((driver) => driver!.driverId)
                      .toList();
                      newPrediction.podiumNames = selectedDrivers
                        .map((driver) => driver!.driverName)
                      .toList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PredictWinnerScreen(prediction: newPrediction,
                                drivers: widget.drivers,
                                raceName: widget.raceName,),
                    ),
                  );
                },
                child: const Text(
                  'NEXT PREDICTION',
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

  // Podium Container (1st, 2nd, 3rd positions)
  Widget _buildPodiumContainer(int index) {
    return DragTarget<DriverInfo>(
      onAcceptWithDetails: (driver) {
        setState(() {
          selectedDrivers[index] = driver.data;
          disabledDriverIds.add(driver.data.driverId);
        });
      },
      builder: (context, candidateData, rejectedData) {
        DriverInfo? driver = selectedDrivers[index];
        return Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: 75,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: driver == null ? Colors.transparent : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white),
              ),
              child: driver == null
                  ? const Center(
                      child: Text(
                        "Make your prediction",
                        style:
                            TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 4),
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
                      selectedDrivers[index] = null;
                      disabledDriverIds.remove(driver.driverId);
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
                if (selectedDrivers.indexWhere((element) => element == null) !=
                    -1) {
                  selectedDrivers[selectedDrivers
                      .indexWhere((element) => element == null)] = driver;
                  disabledDriverIds.add(driver.driverId);
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
