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
      _upcomingRaceInfo = await apiService.getUpcomingRace();

      Map<String, dynamic>? data =
          await apiService.getDriverStandings(DateTime.now().year);
      if (data.isNotEmpty) {
        _driversStandings = data['driver_standings'];
      } else {
        _driversStandings = [];
      }

      _lastRaceResults = await apiService.getLastRaceResults().timeout(
            const Duration(seconds: 10),
          );
      if (_lastRaceResults != null && _lastRaceResults!.isNotEmpty) {
        int lastRaceYear = int.parse(_lastRaceResults!['year']);
        int lastRaceRound = int.parse(_lastRaceResults!['race_id']);

        Map<String, dynamic> raceInfo =
            await apiService.getRaceInfo(lastRaceYear, lastRaceRound);
        _lastRaceInfo = Race.fromJson(raceInfo);
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
      print("Error fetching home screen info: $error");
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
