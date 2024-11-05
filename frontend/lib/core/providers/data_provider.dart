import 'package:flutter/material.dart';
import 'package:frontend/core/services/API_service.dart';

class DataProvider extends ChangeNotifier {
  Map<String, dynamic>? _upcomingRaceInfo;
  Map<String, dynamic>? _lastRaceResults;
  APIService apiService = APIService();

  DataProvider() {
    getHomeScreenInfo();
  }

    Map<String, dynamic>? get upcomingRaceInfo => _upcomingRaceInfo;
    Map<String, dynamic>? get lastRaceResults => _lastRaceResults;

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
}
