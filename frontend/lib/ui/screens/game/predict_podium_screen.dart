import 'package:flutter/material.dart';
import 'package:frontend/core/models/driver.dart';
import 'package:frontend/ui/screens/game/predict_winner_screen.dart';
import 'package:frontend/ui/theme.dart';

class PredictPodiumScreen extends StatefulWidget {
  const PredictPodiumScreen({
    Key? key,
  }) : super(key: key);

  _PredictPodiumScreenState createState() => _PredictPodiumScreenState();
}

class _PredictPodiumScreenState extends State<PredictPodiumScreen> {
  List<Driver?> selectedDrivers = [null, null, null];
  List<int> disabledDriverIds = [];

  List<Driver> drivers = [
    Driver(
      id: 1,
      name: "Max Verstappen",
      totalWins: 50,
      totalPodiums: 85,
      totalChampionships: 2,
      totalPolePositions: 30,
      seasonWins: 10,
      seasonPodiums: 15,
      seasonChampionships: 1,
      seasonPolePositions: 8,
      teamId: "Red Bull Racing",
    ),
    Driver(
      id: 2,
      name: "Lewis Hamilton",
      totalWins: 103,
      totalPodiums: 182,
      totalChampionships: 7,
      totalPolePositions: 103,
      seasonWins: 5,
      seasonPodiums: 10,
      seasonChampionships: 0,
      seasonPolePositions: 4,
      teamId: "Mercedes",
    ),
    Driver(
      id: 3,
      name: "Charles Leclerc",
      totalWins: 5,
      totalPodiums: 23,
      totalChampionships: 0,
      totalPolePositions: 10,
      seasonWins: 2,
      seasonPodiums: 5,
      seasonChampionships: 0,
      seasonPolePositions: 3,
      teamId: "Ferrari",
    ),
    Driver(
      id: 4,
      name: "Lando Norris",
      totalWins: 0,
      totalPodiums: 9,
      totalChampionships: 0,
      totalPolePositions: 0,
      seasonWins: 0,
      seasonPodiums: 4,
      seasonChampionships: 0,
      seasonPolePositions: 0,
      teamId: "McLaren",
    ),
    Driver(
      id: 5,
      name: "Sergio Perez",
      totalWins: 6,
      totalPodiums: 30,
      totalChampionships: 0,
      totalPolePositions: 2,
      seasonWins: 3,
      seasonPodiums: 6,
      seasonChampionships: 0,
      seasonPolePositions: 1,
      teamId: "Red Bull Racing",
    ),
    Driver(
      id: 6,
      name: "Fernando Alonso",
      totalWins: 32,
      totalPodiums: 100,
      totalChampionships: 2,
      totalPolePositions: 22,
      seasonWins: 0,
      seasonPodiums: 6,
      seasonChampionships: 0,
      seasonPolePositions: 0,
      teamId: "Aston Martin",
    ),
    Driver(
      id: 7,
      name: "Carlos Sainz",
      totalWins: 2,
      totalPodiums: 15,
      totalChampionships: 0,
      totalPolePositions: 2,
      seasonWins: 1,
      seasonPodiums: 3,
      seasonChampionships: 0,
      seasonPolePositions: 1,
      teamId: "Ferrari",
    ),
    Driver(
      id: 8,
      name: "George Russell",
      totalWins: 1,
      totalPodiums: 10,
      totalChampionships: 0,
      totalPolePositions: 1,
      seasonWins: 0,
      seasonPodiums: 2,
      seasonChampionships: 0,
      seasonPolePositions: 0,
      teamId: "Mercedes",
    ),
    Driver(
      id: 9,
      name: "Pierre Gasly",
      totalWins: 1,
      totalPodiums: 3,
      totalChampionships: 0,
      totalPolePositions: 0,
      seasonWins: 0,
      seasonPodiums: 1,
      seasonChampionships: 0,
      seasonPolePositions: 0,
      teamId: "Alpine",
    ),
    Driver(
      id: 10,
      name: "Esteban Ocon",
      totalWins: 1,
      totalPodiums: 2,
      totalChampionships: 0,
      totalPolePositions: 0,
      seasonWins: 0,
      seasonPodiums: 1,
      seasonChampionships: 0,
      seasonPolePositions: 0,
      teamId: "Alpine",
    ),
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
            child: const Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1 of 3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Predict your podium for the United States Grand Prix',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) => _buildPodiumContainer(index)),
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select drivers",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: drivers.length,
              itemBuilder: (context, index) {
                Driver driver = drivers[index];
                bool isDisabled = disabledDriverIds.contains(driver.id);
                return _buildDriverTile(driver, isDisabled);
              },
            ),
          ),
          Visibility(
            visible:
                selectedDrivers.indexWhere((element) => element == null) == -1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              width: 200,
              height: 100,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PredictWinnerScreen(),
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
    return DragTarget<Driver>(
      onAcceptWithDetails: (driver) {
        setState(() {
          selectedDrivers[index] = driver.data;
          disabledDriverIds.add(driver.data.id);
        });
      },
      builder: (context, candidateData, rejectedData) {
        Driver? driver = selectedDrivers[index];
        return Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: 70,
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
                          driver.name,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          driver.teamId,
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
                      disabledDriverIds.remove(driver.id);
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
  Widget _buildDriverTile(Driver driver, bool isDisabled) {
    return LongPressDraggable<Driver>(
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
  Widget _buildDriverCard(Driver driver, bool isDisabled) {
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
                  disabledDriverIds.add(driver.id);
                }
              });
            }
          },
          leading: const Icon(Icons.flag, color: secondary),
          title: Text(
            driver.name,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            driver.teamId,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
