/*import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataProvider extends ChangeNotifier {
  final String baseUrl = 'http://127.0.0.1:8000/api/v1';

  // Function to get all drivers with optional filters
  // This one works
  Future<List<dynamic>> getAllDrivers(
      {String? search, String? nationality, int? limit, int? offset}) async {
    String baseUrl = '$baseUrl/driver/';
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

  Future<Map<String, dynamic>> getDriverDetails(String driverId) async {
    String baseUrl = 'http://127.0.0.1:8000/api/v1/driver/$driverId/';

    try {
      final response = await http.get(Uri.parse(baseUrl), headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load driver details');
      }
    } catch (e) {
      throw Exception('Error fetching driver details: $e');
    }
  }

  Future<List<dynamic>> getDriverResults(String driverId) async {
    String baseUrl = 'http://127.0.0.1:8000/api/v1/driver/$driverId/results/';

    try {
      final response = await http.get(Uri.parse(baseUrl), headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load driver results');
      }
    } catch (e) {
      throw Exception('Error fetching driver results: $e');
    }
  }

  Future<List<dynamic>> getAllConstructors() async {
    String baseUrl = 'http://127.0.0.1:8000/api/v1/constructor/';

    try {
      final response = await http.get(Uri.parse(baseUrl), headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load constructors');
      }
    } catch (e) {
      throw Exception('Error fetching constructors: $e');
    }
  }

  Future<Map<String, dynamic>> getConstructorDetails(
      String constructorId) async {
    String baseUrl = 'http://127.0.0.1:8000/api/v1/constructor/$constructorId/';

    try {
      final response = await http.get(Uri.parse(baseUrl), headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load constructor details');
      }
    } catch (e) {
      throw Exception('Error fetching constructor details: $e');
    }
  }
}

Future<List<dynamic>> getRaces({
    required int year,
    String? search,
    int limit = 10,
    int offset = 0,
  }) async {
    final uri = Uri.parse('$baseUrl/race/').replace(queryParameters: {
      'year': year.toString(),
      if (search != null) 'search': search,
      'limit': limit.toString(),
      'offset': offset.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List races = json.decode(response.body);
      return races;
    } else {
      throw Exception('Failed to load races');
    }
  }
*/