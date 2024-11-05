import 'package:flutter/material.dart';
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

  DataProvider() {
    if (firstTime) {
      getHomeScreenInfo();
      getRacesYear(DateTime.now().year);
      getDriversList();
      firstTime = false;
    }
  }

  Map<String, dynamic>? get upcomingRaceInfo => _upcomingRaceInfo;
  Map<String, dynamic>? get lastRaceResults => _lastRaceResults;
  List<dynamic>? get driversList => _driversList;
  Map<String, dynamic>? get driverStats => _driverStats;
  List<dynamic>? get driverAllRacesSeason => _driverAllRacesSeason;
  List<dynamic>? get teamsSeason => _teamsSeason;
  List<dynamic>? get racesSeason => _racesSeason;

  Future<void> getHomeScreenInfo() async {
    try {
      // Wait for both API calls to complete before notifying listeners
      final results = await Future.wait([
        apiService.getUpcomingRace(),
        apiService.getLastRaceResults(),
      ]);

      _upcomingRaceInfo = results[0];
      _lastRaceResults = results[1];

      notifyListeners();
    } catch (error) {
      print("Error fetching home screen info: $error");
    }
  }

  Future<void> getDriversList() async {
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

      notifyListeners();
    } catch (error) {
      print("Error fetching _driversList: $error");
    }
  }

  Future<void> getDriverStats(String driverId, int year) async {
    try {
      _driverStats = await apiService.getDriverStats(driverId, year);

      notifyListeners();
    } catch (error) {
      print("Error fetching _driverStats: $error");
    }
  }

  /*Future<void> getDriverRaceStats(String driverId, int year) async {
    try {
      _driverAllRacesSeason =
          await apiService.getDriverRaceStats(driverId, year);

      notifyListeners();
    } catch (error) {
      print("Error fetching _driverAllRacesSeason: $error");
    }
  }*/

  Future<void> getTeamsYear(int year) async {
    try {
      _teamsSeason = await apiService.getTeamsByYear(year);

      notifyListeners();
    } catch (error) {
      print("Error fetching _teamsSeason: $error");
    }
  }

  Future<void> getRacesYear(int year) async {
    try {
      _racesSeason = await apiService.getAllRacesInYear(year);

      notifyListeners();
    } catch (error) {
      print("Error fetching _racesSeason: $error");
    }
  }
}
