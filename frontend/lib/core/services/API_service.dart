import 'package:frontend/core/shared/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/race_positions.dart';
import '../models/lap_data.dart';

class APIService {
  static String baseUrl = 'https://sportsdataanalytics.onrender.com';

  // HOME SCREENS

  // Fetch upcoming race information
  Future<Map<String, dynamic>> getUpcomingRace() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/home/upcoming_race/'));

      if (response.statusCode == 200) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return jsonDecode(response.body);
      } else {
        // Log the error details if the status is not 200
        print('Failed to load upcoming race');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        //throw Exception('Failed to load upcoming race');
        return {};
      }
    } catch (e) {
      print('Exception caught: $e');
      //rethrow;
      return {};
    }
  }

  Future<LapDataResponse?> fetchDriverLapData(
      int year, int round, String driverId) async {
    final url =
        Uri.parse('$baseUrl/race/$year/$round/driver/$driverId/lap_data');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return LapDataResponse.fromJson(jsonData);
      } else {
        // Handle non-200 responses
        print('Failed to load lap data');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception caught: $e');
      return null;
    }
  }

  // Fetch last race results
  Future<Map<String, dynamic>> getLastRaceResults() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/home/last_race_results/'));
      if (response.statusCode == 200) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return jsonDecode(response.body);
      } else {
        print('Failed to load last race results');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        //throw Exception('Failed to load last race results');
        return {};
      }
    } catch (e) {
      print('Exception caught: $e');
      //rethrow;
      return {};
    }
  }

  // Fetch the drivers' standings for the current season
  Future<Map<String, dynamic>> getDriverStandings(int year) async {
    final url = Uri.parse('$baseUrl/drivers/$year/standings/');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        //print('Response status: ${response.statusCode}');
        //print('Response body: ${response.body}');
        return json.decode(response.body);
      } else {
        print('Failed to load drivers standings');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        //throw Exception('Failed to load driver standings');
        return {};
      }
    } catch (e) {
      print('Exception caught: $e');
      //rethrow;
      return {};
    }
  }

  // Fetch the constructors' standings for the current season
  Future<Map<String, dynamic>> getConstructorStandings(int year) async {
    final url = Uri.parse('$baseUrl/constructors/$year/standings/');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        //print('Response status: ${response.statusCode}');
        //print('Response body: ${response.body}');
        return json.decode(response.body);
      } else {
        print('Failed to load constructors standings');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {};
        //throw Exception('Failed to load constructor standings');
      }
    } catch (e) {
      print('Exception caught: $e');
      return {};
      //rethrow;
    }
  }

  // Fetch lap by lap race positions
  Future<RacePositions?> fetchRacePositions(int year, int round) async {
    final url = Uri.parse('$baseUrl/race/$year/$round/positions/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return RacePositions.fromJson(json.decode(response.body));
    } else {
      // Handle errors as needed
      print('Failed to load race positions: ${response.body}');
      return null;
    }
  }

  // RACES SCREENS

  // Fetch all races in a given year
  Future<List<dynamic>> getAllRacesInYear(int year) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/races/$year/'));
      if (response.statusCode == 200) {
        //print('Response status: ${response.statusCode}');
        //print('Response body: ${response.body}');
        return jsonDecode(response.body);
      } else {
        print('Failed to load races for year $year');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        //throw Exception('Failed to load races for year $year');
        return [];
      }
    } catch (e) {
      print('Exception caught: $e');
      //rethrow;
      return [];

    }
  }

  // Fetch race information
  Future<Map<String, dynamic>> getRaceInfo(int year, int round) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/race/$year/$round/'));

      if (response.statusCode == 200) {
        //print('Response status: ${response.statusCode}');
        //print('Response body: ${response.body}');
        return jsonDecode(response.body);
      } else {
        // Log the error details if the status is not 200
        print('Failed to load race info');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        //throw Exception('Failed to load race ingo');
        return {};
      }
    } catch (e) {
      print('Exception caught: $e');
      //rethrow;
      return {};
    }
  }

  // Fetch detailed results for a specific race
  Future<List<dynamic>> getRaceResults(int year, int round) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/race/$year/$round/results/'));
      if (response.statusCode == 200) {
        //print('Response status: ${response.statusCode}');
        //print('Response body: ${response.body}');
        return jsonDecode(response.body);
      } else {
        print('Failed to load results for race $year round $round');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        //throw Exception('Failed to load results for race $year round $round');
        return [];
      }
    } catch (e) {
      print('Exception caught: $e');
      //rethrow;
      return [];
    }
  }

  // Fetch pit stop data for a race
  Future<List<dynamic>> getPitStops(int year, int round) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/race/$year/$round/pitstops/'));
      if (response.statusCode == 200) {
        //print('Response status: ${response.statusCode}');
        //print('Response body: ${response.body}');
        return jsonDecode(response.body);
      } else {
        print('Failed to load pit stop data');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        //throw Exception('Failed to load pit stop data');
        return [];
      }
    } catch (e) {
      print('Exception caught: $e');
      //rethrow;
      return [];
    }
  }

  // DRIVER SCREENS

  // Fetch all drivers in a given year
  Future<List<dynamic>> getDriversInYear(int year) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/drivers/$year/'));
      if (response.statusCode == 200) {
        //print('Response status: ${response.statusCode}');
        //print('Response body: ${response.body}');
        return jsonDecode(response.body);
      } else {
        print('Failed to load drivers for year $year');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        //throw Exception('Failed to load drivers for year $year');
        return [];
      }
    } catch (e) {
      print('Exception caught: $e');
      return [];
      //rethrow;
    }
  }

  // Fetch driver career and season stats
  Future<Map<String, dynamic>> getDriverStats(String driverId, int year) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/driver/$driverId/$year/stats/'));
      if (response.statusCode == 200) {
        //print('Response status: ${response.statusCode}');
        //print('Response body: ${response.body}');
        return jsonDecode(response.body);
      } else {
        print('Failed to load stats for driver $driverId');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        //throw Exception('Failed to load stats for driver $driverId');
        return {};
      }
    } catch (e) {
      print('Exception caught: $e');
      //rethrow;
      return {};
    }
  }

// Fetch driver race stats in a given year
  Future<List<dynamic>> getDriverRaceStats(String driverId, int year) async {
    final url = Uri.parse('$baseUrl/driver/$driverId/$year/races/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        //print('Response status: ${response.statusCode}');
        //print('Response body: ${response.body}');
        return jsonDecode(response.body);
      } else {
        print('Failed to load race stats for driver $driverId');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        //throw Exception('Failed to load race stats: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching driver race stats: $e');
      //rethrow;
      return [];
    }
  }

  // TEAM SCREENS

  // Fetch all teams in a given year
  Future<List<dynamic>> getTeamsByYear(int year) async {
    final url = Uri.parse('$baseUrl/teams/$year/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        //print('Response status: ${response.statusCode}');
        //print('Response body: ${response.body}');
        return jsonDecode(response.body);
      } else {
        print('Failed to load teams for the season $year');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        //throw Exception('Failed to load teams: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching teams: $e');
      //rethrow;
      return [];
    }
  }

  // Fetch team stats for a specific year
  Future<Map<String, dynamic>> getTeamStats(String teamId, int year) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/team/$teamId/$year/stats/'));
      if (response.statusCode == 200) {
        //print('Response status: ${response.statusCode}');
        //print('Response body: ${response.body}');
        return jsonDecode(response.body);
      } else {
        print('Failed to load team stats for team $teamId');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        //throw Exception('Failed to load team stats for team $teamId');
        return {};
      }
    } catch (e) {
      print('Exception caught: $e');
      //rethrow;
      return {};
    }
  }

  /*Future<List<dynamic>> getAllDrivers(
      {String? search, String? nationality, int? limit, int? offset}) async {
    String baseUrl = '${Globals.baseUrl}/driver/';
    Map<String, String> queryParams = {
      if (search != null) 'search': search,
      if (nationality != null) 'nationality': nationality,
      if (limit != null) 'limit': limit.toString(),
      if (offset != null) 'offset': offset.toString(),
    };

    Uri uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        // Parse the entire response
        Map<String, dynamic> data = jsonDecode(response.body);

        // Extract the list of drivers from 'results'
        List<dynamic> drivers = data['results'];

        return drivers;
      } else {
        throw Exception('Failed to load drivers');
      }
    } catch (e) {
      print('Error fetching drivers: $e');
      throw Exception('Error fetching drivers: $e');
    }
  }

  Future<List<dynamic>> getRaces({
    String? year,
    String? search,
    int? limit,
    int? offset,
  }) async {
    final uri = Uri.parse('$baseUrl/race/').replace(queryParameters: {
      if (year != null) 'year': year,
      if (search != null) 'search': search,
      if (limit != null) 'limit': limit.toString(),
      if (offset != null) 'offset': offset.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Parse the entire response
      Map<String, dynamic> data = jsonDecode(response.body);

      // Extract the list of drivers from 'results'
      List<dynamic> races = data['results'];
      return races;
    } else {
      throw Exception('Failed to load races');
    }
  }*/
}
