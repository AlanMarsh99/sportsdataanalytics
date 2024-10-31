import 'package:frontend/core/shared/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIService {
  static String baseUrl = 'http://127.0.0.1:8000/api/v1';

  Future<List<dynamic>> getAllDrivers(
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
  }
}
