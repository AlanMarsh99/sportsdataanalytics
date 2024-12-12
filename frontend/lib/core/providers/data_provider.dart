import 'package:flutter/material.dart';
import 'package:frontend/core/models/race.dart';
import 'package:frontend/core/services/API_service.dart';

class DataProvider extends ChangeNotifier {
  Map<String, dynamic>? _upcomingRaceInfo;
  Map<String, dynamic>? _lastRaceResults;
  List<dynamic>? _driversList;
  Map<String, dynamic>? _driverStats;
  List<dynamic>? _driverAllRacesSeason;
  List<dynamic>? _teamsSeason;
  List<dynamic>? _racesSeason;
  APIService apiService = APIService();
  bool firstTime = true;
  Race? _lastRaceInfo;
  List<dynamic>? _driversStandings;
  List<dynamic>? _constructorsStandings;

  Map<String, dynamic>? get upcomingRaceInfo => _upcomingRaceInfo;
  Map<String, dynamic>? get lastRaceResults => _lastRaceResults;
  List<dynamic>? get driversList => _driversList;
  Map<String, dynamic>? get driverStats => _driverStats;
  List<dynamic>? get driverAllRacesSeason => _driverAllRacesSeason;
  List<dynamic>? get teamsSeason => _teamsSeason;
  List<dynamic>? get racesSeason => _racesSeason;
  Race? get lastRaceInfo => _lastRaceInfo;
  List<dynamic>? get driversStandings => _driversStandings;
  List<dynamic>? get constructorsStandings => _constructorsStandings;

  DataProvider() {
    if (firstTime) {
      loadInitialData();
      firstTime = false;
    }
  }

  Future<void> loadInitialData() async {
    getHomeScreenInfo();
    /*await Future.wait([
      getRacesYear(DateTime.now().year),
      getDriversList(),
      getTeamsYear(DateTime.now().year),
    ]);*/
  }

  Future<void> getHomeScreenInfo() async {
    try {
      Map<String, dynamic>? data =
          await apiService.getDriverStandings(DateTime.now().year);
      if (data != null) {
        if (data.isNotEmpty) {
          _driversStandings = data['driver_standings'];
        } else {
          _driversStandings = [];
        }
      } else {
        _driversStandings = [];
      }

      Map<String, dynamic>? data2 =
          await apiService.getConstructorStandings(DateTime.now().year);
      if (data2 != null) {
        if (data2.isNotEmpty) {
          _constructorsStandings = data2['constructors_standings'];
        } else {
          _constructorsStandings = [];
        }
      } else {
        _constructorsStandings = [];
      }

      notifyListeners();

      Map<String, dynamic>? info = {
        "race_name": "Abu Dhabi Grand Prix",
        "race_id": "24",
        "date": "2024-12-08",
        "hour": "13:00",
        "year": "2024",
        "drivers": [
          {
            "driver_id": "max_verstappen",
            "driver_name": "Max Verstappen",
            "team_name": "Red Bull"
          },
          {
            "driver_id": "norris",
            "driver_name": "Lando Norris",
            "team_name": "McLaren"
          },
          {
            "driver_id": "sainz",
            "driver_name": "Carlos Sainz Jr.",
            "team_name": "Ferrari"
          },
          {
            "driver_id": "leclerc",
            "driver_name": "Charles Leclerc",
            "team_name": "Ferrari"
          },
          {
            "driver_id": "hamilton",
            "driver_name": "Lewis Hamilton",
            "team_name": "Mercedes"
          },
          {
            "driver_id": "russell",
            "driver_name": "George Russell",
            "team_name": "Mercedes"
          },
          {
            "driver_id": "gasly",
            "driver_name": "Pierre Gasly",
            "team_name": "Alpine"
          },
          {
            "driver_id": "hulkenberg",
            "driver_name": "Nico Hülkenberg",
            "team_name": "Haas"
          },
          {
            "driver_id": "alonso",
            "driver_name": "Fernando Alonso",
            "team_name": "Aston Martin"
          },
          {
            "driver_id": "piastri",
            "driver_name": "Oscar Piastri",
            "team_name": "McLaren"
          },
          {
            "driver_id": "albon",
            "driver_name": "Alexander Albon",
            "team_name": "Williams"
          },
          {
            "driver_id": "tsunoda",
            "driver_name": "Yuki Tsunoda",
            "team_name": "AlphaTauri"
          },
          {
            "driver_id": "zhou",
            "driver_name": "Guanyu Zhou",
            "team_name": "Alfa Romeo"
          },
          {
            "driver_id": "stroll",
            "driver_name": "Lance Stroll",
            "team_name": "Aston Martin"
          },
          {
            "driver_id": "doohan",
            "driver_name": "Jack Doohan",
            "team_name": "Alpine"
          },
          {
            "driver_id": "magnussen",
            "driver_name": "Kevin Magnussen",
            "team_name": "Haas"
          },
          {
            "driver_id": "lawson",
            "driver_name": "Liam Lawson",
            "team_name": "AlphaTauri"
          },
          {
            "driver_id": "bottas",
            "driver_name": "Valtteri Bottas",
            "team_name": "Alfa Romeo"
          },
          {
            "driver_id": "colapinto",
            "driver_name": "Franco Colapinto",
            "team_name": "Williams"
          },
          {
            "driver_id": "perez",
            "driver_name": "Sergio Pérez",
            "team_name": "Red Bull"
          }
        ]
      };
      //await apiService.getUpcomingRace();
      if (info != null) {
        _upcomingRaceInfo = info;
      } else {
        _upcomingRaceInfo = {};
      }
      notifyListeners();

      _lastRaceResults = await apiService.getLastRaceResults();
      if (_lastRaceResults != null) {
        if (_lastRaceResults!.isNotEmpty) {
          int lastRaceYear = int.parse(_lastRaceResults!['year']);
          int lastRaceRound = int.parse(_lastRaceResults!['race_id']);

          Map<String, dynamic> raceInfo =
              await apiService.getRaceInfo(lastRaceYear, lastRaceRound);
          if (raceInfo != null) {
            if (raceInfo.isEmpty) {
              _lastRaceInfo = null;
            } else {
              _lastRaceInfo = Race.fromJson(raceInfo);
            }
          } else {
            _lastRaceInfo = null;
          }
        } else {
          _lastRaceInfo = null;
        }
      } else {
        _lastRaceInfo = null;
      }
      notifyListeners();
    } catch (error) {
      print("Error fetching home screen info: $error. Trying again.");
      try {
        _upcomingRaceInfo = await apiService.getUpcomingRace();
        notifyListeners();

        _lastRaceResults = await apiService.getLastRaceResults();
        if (_lastRaceResults != null) {
          if (_lastRaceResults!.isNotEmpty) {
            int lastRaceYear = int.parse(_lastRaceResults!['year']);
            int lastRaceRound = int.parse(_lastRaceResults!['race_id']);

            Map<String, dynamic> raceInfo =
                await apiService.getRaceInfo(lastRaceYear, lastRaceRound);

            if (raceInfo.isEmpty) {
              _lastRaceInfo = null;
            } else {
              _lastRaceInfo = Race.fromJson(raceInfo);
            }
          }
        } else {
          _lastRaceInfo = null;
        }

        notifyListeners();

        Map<String, dynamic>? data =
            await apiService.getDriverStandings(DateTime.now().year);

        if (data.isNotEmpty) {
          _driversStandings = data['driver_standings'];
        } else {
          _driversStandings = [];
        }

        Map<String, dynamic>? data2 =
            await apiService.getConstructorStandings(DateTime.now().year);

        if (data2.isNotEmpty) {
          _constructorsStandings = data2['constructors_standings'];
        } else {
          _constructorsStandings = [];
        }

        notifyListeners();
      } catch (error) {
        print("Try 2. Error fetching home screen info: $error");
      }
    }
  }

  /*Future<void> getDriversList() async {
    try {
      int currentSeason = DateTime.now().year;
      _driversList = await apiService.getDriversInYear(currentSeason);
      if (_driversList != null) {
        if (_driversList!.isNotEmpty) {
          // Get the first driver's ID
          String firstDriverId = _driversList![0]['driver_id'];

          // Call the API for the first driver's stats
          await getDriverStats(firstDriverId, currentSeason);
        }
      }
    } catch (error) {
      _driversList = [];
      print("Error fetching _driversList: $error");
    }
  }*/

  /*Future<void> getDriverStats(String driverId, int year) async {
    try {
      _driverStats = await apiService.getDriverStats(driverId, year);

      notifyListeners();
    } catch (error) {
      print("Error fetching _driverStats: $error");
    }
  }*/

  /*Future<void> getDriverRaceStats(String driverId, int year) async {
    try {
      _driverAllRacesSeason =
          await apiService.getDriverRaceStats(driverId, year);

      notifyListeners();
    } catch (error) {
      print("Error fetching _driverAllRacesSeason: $error");
    }
  }*/

  /*Future<void> getTeamsYear(int year) async {
    try {
      _teamsSeason = await apiService.getTeamsByYear(year);

      notifyListeners();
    } catch (error) {
      print("Error fetching _teamsSeason: $error");
    }
  }*/

  /*Future<void> getRacesYear(int year) async {
    try {
      _racesSeason = await apiService.getAllRacesInYear(year);

      notifyListeners();
    } catch (error) {
      print("Error fetching _racesSeason: $error");
    }
  }*/
}
