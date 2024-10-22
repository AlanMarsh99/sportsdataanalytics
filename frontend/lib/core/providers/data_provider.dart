import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataProvider extends ChangeNotifier {
  // Function to get all drivers with optional filters
  Future<List<dynamic>> getAllDrivers(
      {String? search, String? nationality, int? limit, int? offset}) async {
    String baseUrl = 'http://127.0.0.1:8000/api/v1/driver/';
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
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load drivers');
      }
    } catch (e) {
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
