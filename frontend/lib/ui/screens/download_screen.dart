import 'package:flutter/material.dart';
import 'package:frontend/core/services/api_service.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:frontend/utils/download_utils.dart';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart'; 
import 'package:frontend/ui/theme.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final APIService apiService = APIService();

  // State variables for selected formats
  String _selectedFormatUpcomingRace = 'JSON';
  String _selectedFormatLastRaceResults = 'CSV';
  String _selectedFormatRaceInfo = 'JSON';
  String _selectedFormatConstructorsStandings = 'JSON';
  String _selectedFormatDriversStandings = 'JSON';
  String _selectedFormatAllRaces = 'JSON';
  String _selectedFormatRaceResults = 'JSON';

  // Controllers for Year and Round input fields
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _roundController = TextEditingController();
  final TextEditingController _constructorsYearController = TextEditingController();
  final TextEditingController _driversYearController = TextEditingController();
  final TextEditingController _allRacesYearController = TextEditingController();
  final TextEditingController _raceResultsYearController = TextEditingController();
  final TextEditingController _raceResultsRoundController = TextEditingController();

  // State variables for loading indicators
  bool _isLoadingUpcomingRace = false;
  bool _isLoadingLastRaceResults = false;
  bool _isLoadingRaceInfo = false;
  bool _isLoadingConstructorsStandings = false;
  bool _isLoadingDriversStandings = false;
  bool _isLoadingAllRaces = false;
  bool _isLoadingRaceResults = false;

  @override
  void dispose() {
    _yearController.dispose();
    _roundController.dispose();
    _constructorsYearController.dispose();
    _driversYearController.dispose(); 
    _allRacesYearController.dispose();
     _raceResultsYearController.dispose();
    _raceResultsRoundController.dispose();
    super.dispose();
  }

  // Function to download files based on format and data type
  Future<void> _downloadFile(String dataType, String format) async {
    if (dataType == 'upcoming_race') {
      await _handleDownloadUpcomingRace(format);
    } else if (dataType == 'last_race_results') {
      await _handleDownloadLastRaceResults(format);
    } else if (dataType == 'race_info') {
      await _handleDownloadRaceInfo(format);
    } else if (dataType == 'constructors_standings') {
      await _handleDownloadConstructorsStandings(format);
    } else if (dataType == 'drivers_standings') {
      await _handleDownloadDriversStandings(format);
    } else if (dataType == 'all_races') {
      await _handleDownloadAllRaces(format);
    } else if (dataType == 'race_results') {
      await _handleDownloadRaceResults(format);
  }
  }

  // Handle download for Upcoming Race
  Future<void> _handleDownloadUpcomingRace(String format) async {
    setState(() {
      _isLoadingUpcomingRace = true;
    });
    try {
      Map<String, dynamic> upcomingRace = await apiService.getUpcomingRace();

      switch (format) {
        case 'JSON':
          await _downloadJson('upcoming_race', upcomingRace);
          break;
        case 'CSV':
          await _downloadUpcomingRaceCsv(upcomingRace);
          break;
        case 'PDF':
          await _downloadPdf('upcoming_race', upcomingRace);
          break;
        default:
          throw Exception('Unsupported format: $format');
      }
    } catch (e) {
      _showErrorSnackBar('Error downloading Upcoming Race: $e');
    } finally {
      setState(() {
        _isLoadingUpcomingRace = false;
      });
    }
  }

  // Handle download for Last Race Results
  Future<void> _handleDownloadLastRaceResults(String format) async {
    setState(() {
      _isLoadingLastRaceResults = true;
    });
    try {
      Map<String, dynamic> lastRace = await apiService.getLastRaceResults();

      switch (format) {
        case 'JSON':
          await _downloadJson('last_race_results', lastRace);
          break;
        case 'CSV':
          await _downloadLastRaceResultsCsv(lastRace);
          break;
        case 'PDF':
          await _downloadPdf('last_race_results', lastRace);
          break;
        default:
          throw Exception('Unsupported format: $format');
      }
    } catch (e) {
      _showErrorSnackBar('Error downloading Last Race Results: $e');
    } finally {
      setState(() {
        _isLoadingLastRaceResults = false;
      });
    }
  }

  // Handle download for Race Information
  Future<void> _handleDownloadRaceInfo(String format) async {
    setState(() {
      _isLoadingRaceInfo = true;
    });
    try {
      if (_yearController.text.isEmpty || _roundController.text.isEmpty) {
        throw Exception('Year and Round cannot be empty');
      }
      int year;
      int round;
      try {
        year = int.parse(_yearController.text);
        round = int.parse(_roundController.text);
      } catch (e) {
        throw Exception('Year and Round must be valid numbers');
      }

      Map<String, dynamic> raceInfo = await apiService.getRaceInfo(year, round);

      switch (format) {
        case 'JSON':
          await _downloadJson('race_info', raceInfo);
          break;
        case 'CSV':
          await _downloadRaceInfoCsv(raceInfo);
          break;
        case 'PDF':
          await _downloadPdf('race_info', raceInfo);
          break;
        default:
          throw Exception('Unsupported format: $format');
      }
    } catch (e) {
      _showErrorSnackBar('Error downloading Race Information: $e');
    } finally {
      setState(() {
        _isLoadingRaceInfo = false;
      });
    }
  }

  // Handle download for Constructors Standings
  Future<void> _handleDownloadConstructorsStandings(String format) async {
    setState(() {
      _isLoadingConstructorsStandings = true;
    });
    try {
      if (_constructorsYearController.text.isEmpty) {
        throw Exception('Year cannot be empty');
      }
      int year;
      try {
        year = int.parse(_constructorsYearController.text);
      } catch (e) {
        throw Exception('Year must be a valid number');
      }

      Map<String, dynamic> constructorsStandings = await apiService.getConstructorStandings(year);

      switch (format) {
        case 'JSON':
          await _downloadJson('constructors_standings', constructorsStandings);
          break;
        case 'CSV':
          await _downloadConstructorsStandingsCsv(constructorsStandings);
          break;
        case 'PDF':
          await _downloadPdf('constructors_standings', constructorsStandings);
          break;
        default:
          throw Exception('Unsupported format: $format');
      }
    } catch (e) {
      _showErrorSnackBar('Error downloading Constructors Standings: $e');
    } finally {
      setState(() {
        _isLoadingConstructorsStandings = false;
      });
    }
  }

  // Handle download for Drivers Standings
  Future<void> _handleDownloadDriversStandings(String format) async {
    setState(() {
      _isLoadingDriversStandings = true;
    });
    try {
      if (_driversYearController.text.isEmpty) {
        throw Exception('Year cannot be empty');
      }
      int year;
      try {
        year = int.parse(_driversYearController.text);
      } catch (e) {
        throw Exception('Year must be a valid number');
      }

      Map<String, dynamic> driversStandings = await apiService.getDriverStandings(year);

      switch (format) {
        case 'JSON':
          await _downloadJson('drivers_standings', driversStandings);
          break;
        case 'CSV':
          await _downloadDriversStandingsCsv(driversStandings);
          break;
        case 'PDF':
          await _downloadPdf('drivers_standings', driversStandings);
          break;
        default:
          throw Exception('Unsupported format: $format');
      }
    } catch (e) {
      _showErrorSnackBar('Error downloading Drivers Standings: $e');
    } finally {
      setState(() {
        _isLoadingDriversStandings = false;
      });
    }
  }

  // Handle download for All Races in a Year
  Future<void> _handleDownloadAllRaces(String format) async {
    setState(() {
      _isLoadingAllRaces = true;
    });
    try {
      if (_allRacesYearController.text.isEmpty) {
        throw Exception('Year cannot be empty');
      }
      int year;
      try {
        year = int.parse(_allRacesYearController.text);
      } catch (e) {
        throw Exception('Year must be a valid number');
      }

      List<dynamic> allRaces = await apiService.getAllRacesInYear(year);

      if (allRaces.isEmpty) {
        throw Exception('No races found for the year $year');
      }

      Map<String, dynamic> data = {'races': allRaces};

      switch (format) {
        case 'JSON':
          await _downloadJson('all_races_$year', data);
          break;
        case 'CSV':
          await _downloadAllRacesCsv(data, year);
          break;
        case 'PDF':
          await _downloadPdf('all_races_$year', data);
          break;
        default:
          throw Exception('Unsupported format: $format');
      }
    } catch (e) {
      _showErrorSnackBar('Error downloading All Races: $e');
    } finally {
      setState(() {
        _isLoadingAllRaces = false;
      });
    }
  }

  // Handle download for detailed race results
  Future<void> _handleDownloadRaceResults(String format) async {
    setState(() {
      _isLoadingRaceResults = true;
    });
    try {
      if (_raceResultsYearController.text.isEmpty || _raceResultsRoundController.text.isEmpty) {
        throw Exception('Year and Round cannot be empty');
      }
      int year;
      int round;
      try {
        year = int.parse(_raceResultsYearController.text);
        round = int.parse(_raceResultsRoundController.text);
      } catch (e) {
        throw Exception('Year and Round must be valid numbers');
      }

      List<dynamic> raceResults = await apiService.getRaceResults(year, round);

      if (raceResults.isEmpty) {
        throw Exception('No results found for the race in year $year, round $round');
      }

      Map<String, dynamic> data = {'results': raceResults};

      switch (format) {
        case 'JSON':
          await _downloadJson('race_results_${year}_$round', data);
          break;
        case 'CSV':
          await _downloadRaceResultsCsv(data, year, round);
          break;
        case 'PDF':
          await _downloadPdf('race_results_${year}_$round', data);
          break;
        default:
          throw Exception('Unsupported format: $format');
      }
    } catch (e) {
      _showErrorSnackBar('Error downloading Race Results: $e');
    } finally {
      setState(() {
        _isLoadingRaceResults = false;
      });
    }
  }

  // Function to download JSON
  Future<void> _downloadJson(String filename, Map<String, dynamic> data) async {
    try {
      String jsonString = jsonEncode(data);
      Uint8List bytes = Uint8List.fromList(utf8.encode(jsonString));
      await downloadFile('$filename.json', bytes, 'application/json');
      _showSuccessSnackBar('Successfully downloaded $filename.json');
    } catch (e) {
      throw Exception('Failed to download JSON: $e');
    }
  }

  // Function to download Upcoming Race as CSV
  Future<void> _downloadUpcomingRaceCsv(Map<String, dynamic> data) async {
    try {
      List<List<dynamic>> rows = [
        ['Race ID', 'Race Name', 'Date', 'Time', 'Year', 'Country'],
        [
          data['race_id'],
          data['race_name'],
          data['date'],
          data['hour'],
          data['year'],
          data['country']
        ],
      ];
      String csvData = const ListToCsvConverter().convert(rows);
      Uint8List bytes = Uint8List.fromList(utf8.encode(csvData));
      await downloadFile('upcoming_race.csv', bytes, 'text/csv');
      _showSuccessSnackBar('Successfully downloaded upcoming_race.csv');
    } catch (e) {
      throw Exception('Failed to download CSV: $e');
    }
  }

  // Function to download Last Race Results as CSV
  Future<void> _downloadLastRaceResultsCsv(Map<String, dynamic> data) async {
    try {
      List<List<dynamic>> rows = [
        [
          'Race ID',
          'Year',
          'First Position',
          'Second Position',
          'Third Position',
          'Fastest Lap'
        ],
        [
          data['race_id'],
          data['year'],
          data['first_position']['driver_name'],
          data['second_position']['driver_name'],
          data['third_position']['driver_name'],
          data['fastest_lap']['driver_name'] ?? 'N/A'
        ],
      ];
      String csvData = const ListToCsvConverter().convert(rows);
      Uint8List bytes = Uint8List.fromList(utf8.encode(csvData));
      await downloadFile('last_race_results.csv', bytes, 'text/csv');
      _showSuccessSnackBar('Successfully downloaded last_race_results.csv');
    } catch (e) {
      throw Exception('Failed to download CSV: $e');
    }
  }

  // Function to download Race Information as CSV
  Future<void> _downloadRaceInfoCsv(Map<String, dynamic> data) async {
    try {
      List<List<dynamic>> rows = [
        [
          'Race ID',
          'Race Name',
          'Date',
          'Circuit Name',
          'Round',
          'Location',
          'Winner',
          'Winner Driver ID',
          'Winning Time',
          'Fastest Lap',
          'Fastest Lap Driver ID',
          'Fastest Lap Time',
          'Pole Position',
          'Pole Position Driver ID',
          'Fastest Pit Stop',
          'Fastest Pit Stop Driver ID',
          'Fastest Pit Stop Time'
        ],
        [
          data['race_id'],
          data['race_name'],
          data['date'],
          data['circuit_name'],
          data['round'],
          data['location'],
          data['winner'],
          data['winner_driver_id'],
          data['winning_time'],
          data['fastest_lap'],
          data['fastest_lap_driver_id'],
          data['fastest_lap_time'],
          data['pole_position'],
          data['pole_position_driver_id'],
          data['fastest_pit_stop'],
          data['fastest_pit_stop_driver_id'],
          data['fastest_pit_stop_time']
        ],
      ];
      String csvData = const ListToCsvConverter().convert(rows);
      Uint8List bytes = Uint8List.fromList(utf8.encode(csvData));
      await downloadFile('race_info.csv', bytes, 'text/csv');
      _showSuccessSnackBar('Successfully downloaded race_info.csv');
    } catch (e) {
      throw Exception('Failed to download CSV: $e');
    }
  }

  // Function to download Constructors Standings as CSV
  Future<void> _downloadConstructorsStandingsCsv(Map<String, dynamic> data) async {
    try {
      List<List<dynamic>> rows = [
        ['Position', 'Points', 'Wins', 'Constructor ID', 'Constructor Name'],
      ];
      List<dynamic> standingsList = data['constructors_standings'];
      for (var standing in standingsList) {
        rows.add([
          standing['position'],
          standing['points'],
          standing['wins'],
          standing['constructor_id'],
          standing['constructor_name'],
        ]);
      }
      String csvData = const ListToCsvConverter().convert(rows);
      Uint8List bytes = Uint8List.fromList(utf8.encode(csvData));
      await downloadFile('constructors_standings.csv', bytes, 'text/csv');
      _showSuccessSnackBar('Successfully downloaded constructors_standings.csv');
    } catch (e) {
      throw Exception('Failed to download CSV: $e');
    }
  }

  // Function to download Drivers Standings as CSV
  Future<void> _downloadDriversStandingsCsv(Map<String, dynamic> data) async {
    try {
      List<List<dynamic>> rows = [
        ['Position', 'Points', 'Wins', 'Driver ID', 'Driver Name', 'Constructor Name'],
      ];
      List<dynamic> standingsList = data['driver_standings'];
      for (var standing in standingsList) {
        rows.add([
          standing['position'],
          standing['points'],
          standing['wins'],
          standing['driver_id'],
          standing['driver_name'],
          standing['constructor_name'],
        ]);
      }
      String csvData = const ListToCsvConverter().convert(rows);
      Uint8List bytes = Uint8List.fromList(utf8.encode(csvData));
      await downloadFile('drivers_standings.csv', bytes, 'text/csv');
      _showSuccessSnackBar('Successfully downloaded drivers_standings.csv');
    } catch (e) {
      throw Exception('Failed to download CSV: $e');
    }
  }

  // Function to download All Races as CSV
  Future<void> _downloadAllRacesCsv(Map<String, dynamic> data, int year) async {
    try {
      List<List<dynamic>> rows = [
        [
          'Date',
          'Race Name',
          'Race ID',
          'Circuit Name',
          'Round',
          'Location',
          'Winner',
          'Winner Driver ID',
          'Winning Time',
          'Fastest Lap',
          'Fastest Lap Driver ID',
          'Fastest Lap Time',
          'Pole Position',
          'Pole Position Driver ID',
          'Fastest Pit Stop',
          'Fastest Pit Stop Driver ID',
          'Fastest Pit Stop Time'
        ],
      ];
      List<dynamic> racesList = data['races'];
      for (var race in racesList) {
        rows.add([
          race['date'],
          race['race_name'],
          race['race_id'],
          race['circuit_name'],
          race['round'],
          race['location'],
          race['winner'],
          race['winner_driver_id'],
          race['winning_time'],
          race['fastest_lap'],
          race['fastest_lap_driver_id'],
          race['fastest_lap_time'],
          race['pole_position'],
          race['pole_position_driver_id'],
          race['fastest_pit_stop'],
          race['fastest_pit_stop_driver_id'],
          race['fastest_pit_stop_time'],
        ]);
      }
      String csvData = const ListToCsvConverter().convert(rows);
      Uint8List bytes = Uint8List.fromList(utf8.encode(csvData));
      await downloadFile('all_races_$year.csv', bytes, 'text/csv');
      _showSuccessSnackBar('Successfully downloaded all_races_$year.csv');
    } catch (e) {
      throw Exception('Failed to download CSV: $e');
    }
  }

  Future<void> _downloadRaceResultsCsv(Map<String, dynamic> data, int year, int round) async {
    try {
      List<List<dynamic>> rows = [
        ['Position', 'Driver', 'Driver ID', 'Team', 'Team ID', 'Time', 'Grid', 'Laps', 'Points'],
      ];
      List<dynamic> resultsList = data['results'];
      for (var result in resultsList) {
        rows.add([
          result['position'],
          result['driver'],
          result['driver_id'],
          result['team'],
          result['team_id'],
          result['time'],
          result['grid'],
          result['laps'],
          result['points'],
        ]);
      }
      String csvData = const ListToCsvConverter().convert(rows);
      Uint8List bytes = Uint8List.fromList(utf8.encode(csvData));
      await downloadFile('race_results_${year}_$round.csv', bytes, 'text/csv');
      _showSuccessSnackBar('Successfully downloaded race_results_${year}_$round.csv');
    } catch (e) {
      throw Exception('Failed to download CSV: $e');
    }
  }


  // Function to download PDF
  Future<void> _downloadPdf(String filename, Map<String, dynamic> data) async {
    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (pw.Context context) {
            // Initialize title and dataList based on filename
            String title = '';
            List<Map<String, String>> dataList = [];

            if (filename == 'upcoming_race') {
              title = 'Upcoming Race Data';
              dataList = [
                {'Race ID': data['race_id'].toString()},
                {'Race Name': data['race_name'].toString()},
                {'Date': data['date'].toString()},
                {'Time': data['hour'].toString()},
                {'Year': data['year'].toString()},
                {'Country': data['country'].toString()},
              ];
            } else if (filename == 'last_race_results') {
              title = 'Last Race Results';
              dataList = [
                {'Round': data['race_id'].toString()},
                {'Year': data['year'].toString()},
                {'First Position': data['first_position']['driver_name'].toString()},
                {'Second Position': data['second_position']['driver_name'].toString()},
                {'Third Position': data['third_position']['driver_name'].toString()},
                {
                  'Fastest Lap':
                      (data['fastest_lap']['driver_name'] ?? 'N/A').toString()
                },
              ];
            } else if (filename == 'race_info') {
              title = 'Race Information';
              dataList = [
                {'Race Name': data['race_name'].toString()},
                {'Date': data['date'].toString()},
                {'Circuit Name': data['circuit_name'].toString()},
                {'Round': data['race_id'].toString()},
                {'Location': data['location'].toString()},
                {'Winner': data['winner'].toString()},
                {'Winner Driver ID': data['winner_driver_id'].toString()},
                {'Winning Time': data['winning_time'].toString()},
                {'Fastest Lap': data['fastest_lap'].toString()},
                {'Fastest Lap Driver ID': data['fastest_lap_driver_id'].toString()},
                {'Fastest Lap Time': data['fastest_lap_time'].toString()},
                {'Pole Position': data['pole_position'].toString()},
                {'Pole Position Driver ID': data['pole_position_driver_id'].toString()},
                {'Fastest Pit Stop': data['fastest_pit_stop'].toString()},
                {
                  'Fastest Pit Stop Driver ID':
                      data['fastest_pit_stop_driver_id'].toString()
                },
                {'Fastest Pit Stop Time': data['fastest_pit_stop_time'].toString()},
              ];
            } else if (filename == 'constructors_standings') {
              title = 'Constructors Standings';
              List<dynamic> standingsList = data['constructors_standings'];
              dataList = standingsList.map<Map<String, String>>((standing) => {
                    'Position': standing['position'].toString(),
                    'Points': standing['points'].toString(),
                    'Wins': standing['wins'].toString(),
                    'Constructor Name': standing['constructor_name'].toString(),
                  }).toList();
            } else if (filename == 'drivers_standings') {
              title = 'Drivers Standings';
              List<dynamic> standingsList = data['driver_standings'];
              dataList = standingsList.map<Map<String, String>>((standing) => {
                    'Position': standing['position'].toString(),
                    'Points': standing['points'].toString(),
                    'Wins': standing['wins'].toString(),
                    'Driver Name': standing['driver_name'].toString(),
                    'Constructor Name': standing['constructor_name'].toString(),
                  }).toList();
            } else if (filename.startsWith('all_races_')) {
              String year = filename.split('_').last;
              title = 'All Races in Year $year';
              List<dynamic> racesList = data['races'];
              dataList = racesList.map<Map<String, String>>((race) => {
                    'Date': race['date']?.toString() ?? 'N/A',
                    'Race Name': race['race_name']?.toString() ?? 'N/A',
                    'Race ID': race['race_id']?.toString() ?? 'N/A',
                    'Circuit Name': race['circuit_name']?.toString() ?? 'N/A',
                    'Round': race['round']?.toString() ?? 'N/A',
                    'Location': race['location']?.toString() ?? 'N/A',
                    'Winner': race['winner']?.toString() ?? 'N/A',
                    'Winner Driver ID': race['winner_driver_id']?.toString() ?? 'N/A',
                    'Winning Time': race['winning_time']?.toString() ?? 'N/A',
                    'Fastest Lap': race['fastest_lap']?.toString() ?? 'N/A',
                    'Fastest Lap Driver ID': race['fastest_lap_driver_id']?.toString() ?? 'N/A',
                    'Fastest Lap Time': race['fastest_lap_time']?.toString() ?? 'N/A',
                    'Pole Position': race['pole_position']?.toString() ?? 'N/A',
                    'Pole Position Driver ID': race['pole_position_driver_id']?.toString() ?? 'N/A',
                    'Fastest Pit Stop': race['fastest_pit_stop']?.toString() ?? 'N/A',
                    'Fastest Pit Stop Driver ID': race['fastest_pit_stop_driver_id']?.toString() ?? 'N/A',
                    'Fastest Pit Stop Time': race['fastest_pit_stop_time']?.toString() ?? 'N/A',
                  }).toList();
            } else if (filename.startsWith('race_results_')) {
              List<String> filenameParts = filename.split('_');
              String year = filenameParts[2];
              String round = filenameParts[3];
              title = 'Race Results for Year $year, Round $round';
              List<dynamic> resultsList = data['results'];
              dataList = resultsList.map<Map<String, String>>((result) => {
                'Position': result['position'].toString(),
                'Driver': result['driver'],
                'Driver ID': result['driver_id'],
                'Team': result['team'],
                'Team ID': result['team_id'],
                'Time': result['time'],
                'Grid': result['grid'].toString(),
                'Laps': result['laps'].toString(),
                'Points': result['points'].toString(),
              }).toList();
            }

            // Initialize a list to hold all widgets
            List<pw.Widget> widgets = [];

            // Add Title
            widgets.add(
              pw.Text(
                title,
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            );

            widgets.add(pw.SizedBox(height: 10));

            if (filename.startsWith('all_races_') || filename.startsWith('race_results_')) {
              // Add Table for All Races
              widgets.add(
                pw.Table.fromTextArray(
                  headers: dataList.isNotEmpty ? dataList[0].keys.toList() : [],
                  data: dataList.map((item) => item.values.toList()).toList(),
                  headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                  cellStyle: pw.TextStyle(fontSize: 8),
                  border: pw.TableBorder.all(width: 0.5),
                  headerDecoration: pw.BoxDecoration(),
                  cellAlignment: pw.Alignment.centerLeft,
                  cellHeight: 20,
                ),
              );
            } else if (filename == 'constructors_standings' || filename == 'drivers_standings') {
              // Add Table for Standings
              widgets.add(
                pw.Table.fromTextArray(
                  headers: dataList.isNotEmpty ? dataList[0].keys.toList() : [],
                  data: dataList.map((item) => item.values.toList()).toList(),
                  headerStyle: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                  cellStyle: pw.TextStyle(fontSize: 8),
                  border: pw.TableBorder.all(width: 0.5),
                  headerDecoration: pw.BoxDecoration(),
                  cellAlignment: pw.Alignment.centerLeft,
                  cellHeight: 20,
                ),
              );
            } else {
              // Add Key-Value Texts for Other Data Types
              widgets.addAll(
                dataList.map((item) {
                  final key = item.keys.first;
                  final value = item.values.first;
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 5),
                    child: pw.Text('$key: $value', style: pw.TextStyle(fontSize: 14)),
                  );
                }).toList(),
              );
            }

            return widgets;
          },
        ),
      );

      Uint8List pdfBytes = await pdf.save();
      await downloadFile('$filename.pdf', pdfBytes, 'application/pdf');
      _showSuccessSnackBar('Successfully downloaded $filename.pdf');
    } catch (e, stackTrace) {
      print('PDF Generation Error: $e');
      print('Stack Trace: $stackTrace');
      _showErrorSnackBar('Failed to download PDF: $e');
      throw Exception('Failed to download PDF: $e');
    }
  }

  // Function to show error SnackBar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  // Function to show success SnackBar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Build widget
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
        backgroundColor:
            Colors.transparent, // Make Scaffold background transparent to show gradient
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Screen Title
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'DOWNLOAD DATA',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Download Upcoming Race
              Card(
                color: primary,
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      const Text(
                        'Upcoming Race',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // "Select Format" Label Container
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: const Text(
                          'Select Format',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Dropdown for Format Selection
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButtonFormField<String>(
                          isDense: false, // Ensures adequate vertical space
                          value: _selectedFormatUpcomingRace,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                          ),
                          dropdownColor: Colors.white,
                          // Icons for different file types
                          isExpanded: true,
                          items: ['CSV', 'JSON', 'PDF'].map((String value) {
                            IconData icon;
                            switch (value) {
                              case 'CSV':
                                icon = Icons.table_chart;
                                break;
                              case 'JSON':
                                icon = Icons.code;
                                break;
                              case 'PDF':
                                icon = Icons.picture_as_pdf;
                                break;
                              default:
                                icon = Icons.download;
                            }
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(icon, size: 20, color: Colors.black54),
                                  const SizedBox(width: 10),
                                  Text(value,
                                      style:
                                          const TextStyle(color: Colors.black87)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedFormatUpcomingRace = newValue;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // DOWNLOAD Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            foregroundColor: Colors.white, // Button color
                            backgroundColor: secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          icon: _isLoadingUpcomingRace
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.download, size: 20),
                          label: const Text(
                            'DOWNLOAD',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: _isLoadingUpcomingRace
                              ? null
                              : () {
                                  _downloadFile(
                                      'upcoming_race', _selectedFormatUpcomingRace);
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Download Last Race Results
              Card(
                color: primary,
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      const Text(
                        'Last Race Results',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // "Select Format" Label Container
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: const Text(
                          'Select Format',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Dropdown for Format Selection
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButtonFormField<String>(
                          isDense: false,
                          value: _selectedFormatLastRaceResults,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                          ),
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          items: ['CSV', 'JSON', 'PDF'].map((String value) {
                            IconData icon;
                            switch (value) {
                              case 'CSV':
                                icon = Icons.table_chart;
                                break;
                              case 'JSON':
                                icon = Icons.code;
                                break;
                              case 'PDF':
                                icon = Icons.picture_as_pdf;
                                break;
                              default:
                                icon = Icons.download;
                            }
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(icon, size: 20, color: Colors.black54),
                                  const SizedBox(width: 10),
                                  Text(value,
                                      style:
                                          const TextStyle(color: Colors.black87)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedFormatLastRaceResults = newValue;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Download Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            foregroundColor: Colors.white, // Button color
                            backgroundColor: secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          icon: _isLoadingLastRaceResults
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.download, size: 20),
                          label: const Text(
                            'DOWNLOAD',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: _isLoadingLastRaceResults
                              ? null
                              : () {
                                  _downloadFile('last_race_results',
                                      _selectedFormatLastRaceResults);
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Download Race Information
              Card(
                color: primary,
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      const Text(
                        'Race Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Input fields for Year and Round
                      TextField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        cursorColor: secondary,
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.white24,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _roundController,
                        keyboardType: TextInputType.number,
                        cursorColor: secondary,
                        decoration: const InputDecoration(
                          labelText: 'Round',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.white24,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),

                      // "Select Format" Label Container
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: const Text(
                          'Select Format',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Dropdown for Format Selection
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButtonFormField<String>(
                          isDense: false, // Ensures adequate vertical space
                          value: _selectedFormatRaceInfo,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                          ),
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          items: ['CSV', 'JSON', 'PDF'].map((String value) {
                            IconData icon;
                            switch (value) {
                              case 'CSV':
                                icon = Icons.table_chart;
                                break;
                              case 'JSON':
                                icon = Icons.code;
                                break;
                              case 'PDF':
                                icon = Icons.picture_as_pdf;
                                break;
                              default:
                                icon = Icons.download;
                            }
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(icon, size: 20, color: Colors.black54),
                                  const SizedBox(width: 10),
                                  Text(value,
                                      style:
                                          const TextStyle(color: Colors.black87)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedFormatRaceInfo = newValue;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Download Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            foregroundColor: Colors.white, // Button color
                            backgroundColor: secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          icon: _isLoadingRaceInfo
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.download, size: 20),
                          label: const Text(
                            'DOWNLOAD',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: _isLoadingRaceInfo
                              ? null
                              : () {
                                  _downloadFile('race_info', _selectedFormatRaceInfo);
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Download Constructors Standings
              Card(
                color: primary,
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      const Text(
                        'Constructors Standings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Input field for Year
                      TextField(
                        controller: _constructorsYearController,
                        keyboardType: TextInputType.number,
                        cursorColor: secondary,
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.white24,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      // "Select Format" Label Container
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: const Text(
                          'Select Format',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Dropdown for Format Selection
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButtonFormField<String>(
                          isDense: false,
                          value: _selectedFormatConstructorsStandings,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          ),
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          items: ['CSV', 'JSON', 'PDF'].map((String value) {
                            IconData icon;
                            switch (value) {
                              case 'CSV':
                                icon = Icons.table_chart;
                                break;
                              case 'JSON':
                                icon = Icons.code;
                                break;
                              case 'PDF':
                                icon = Icons.picture_as_pdf;
                                break;
                              default:
                                icon = Icons.download;
                            }
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(icon, size: 20, color: Colors.black54),
                                  const SizedBox(width: 10),
                                  Text(value, style: const TextStyle(color: Colors.black87)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedFormatConstructorsStandings = newValue;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // DOWNLOAD Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            foregroundColor: Colors.white,
                            backgroundColor: secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          icon: _isLoadingConstructorsStandings
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.download, size: 20),
                          label: const Text(
                            'DOWNLOAD',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: _isLoadingConstructorsStandings
                              ? null
                              : () {
                                  _downloadFile('constructors_standings', _selectedFormatConstructorsStandings);
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Download Drivers Standings
              Card(
                color: primary,
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      const Text(
                        'Drivers Standings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Input field for Year
                      TextField(
                        controller: _driversYearController,
                        keyboardType: TextInputType.number,
                        cursorColor: secondary,
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.white24,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      // "Select Format" Label Container
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: const Text(
                          'Select Format',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Dropdown for Format Selection
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButtonFormField<String>(
                          isDense: false,
                          value: _selectedFormatDriversStandings,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          ),
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          items: ['CSV', 'JSON', 'PDF'].map((String value) {
                            IconData icon;
                            switch (value) {
                              case 'CSV':
                                icon = Icons.table_chart;
                                break;
                              case 'JSON':
                                icon = Icons.code;
                                break;
                              case 'PDF':
                                icon = Icons.picture_as_pdf;
                                break;
                              default:
                                icon = Icons.download;
                            }
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(icon, size: 20, color: Colors.black54),
                                  const SizedBox(width: 10),
                                  Text(value, style: const TextStyle(color: Colors.black87)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedFormatDriversStandings = newValue;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // DOWNLOAD Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            foregroundColor: Colors.white,
                            backgroundColor: secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          icon: _isLoadingDriversStandings
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.download, size: 20),
                          label: const Text(
                            'DOWNLOAD',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: _isLoadingDriversStandings
                              ? null
                              : () {
                                  _downloadFile('drivers_standings', _selectedFormatDriversStandings);
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Download All Races in a Year
              Card(
                color: primary,
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      const Text(
                        'All Races in a Year',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Input field for Year
                      TextField(
                        controller: _allRacesYearController,
                        keyboardType: TextInputType.number,
                        cursorColor: secondary,
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.white24,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      // "Select Format" Label Container
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: const Text(
                          'Select Format',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Dropdown for Format Selection
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButtonFormField<String>(
                          isDense: false,
                          value: _selectedFormatAllRaces,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          ),
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          items: ['CSV', 'JSON', 'PDF'].map((String value) {
                            IconData icon;
                            switch (value) {
                              case 'CSV':
                                icon = Icons.table_chart;
                                break;
                              case 'JSON':
                                icon = Icons.code;
                                break;
                              case 'PDF':
                                icon = Icons.picture_as_pdf;
                                break;
                              default:
                                icon = Icons.download;
                            }
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(icon, size: 20, color: Colors.black54),
                                  const SizedBox(width: 10),
                                  Text(value, style: const TextStyle(color: Colors.black87)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedFormatAllRaces = newValue;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // DOWNLOAD Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            foregroundColor: Colors.white,
                            backgroundColor: secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          icon: _isLoadingAllRaces
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.download, size: 20),
                          label: const Text(
                            'DOWNLOAD',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: _isLoadingAllRaces
                              ? null
                              : () {
                                  _downloadFile('all_races', _selectedFormatAllRaces);
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Download Detailed Race Results
              Card(
                color: primary,
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      const Text(
                        'Detailed Race Results',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Input fields for Year and Round
                      TextField(
                        controller: _raceResultsYearController,
                        keyboardType: TextInputType.number,
                        cursorColor: secondary,
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.white24,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _raceResultsRoundController,
                        keyboardType: TextInputType.number,
                        cursorColor: secondary,
                        decoration: const InputDecoration(
                          labelText: 'Round',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.white24,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      // "Select Format" Label Container
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: const Text(
                          'Select Format',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Dropdown for Format Selection
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButtonFormField<String>(
                          isDense: false, // Ensures adequate vertical space
                          value: _selectedFormatRaceResults,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          ),
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          items: ['CSV', 'JSON', 'PDF'].map((String value) {
                            IconData icon;
                            switch (value) {
                              case 'CSV':
                                icon = Icons.table_chart;
                                break;
                              case 'JSON':
                                icon = Icons.code;
                                break;
                              case 'PDF':
                                icon = Icons.picture_as_pdf;
                                break;
                              default:
                                icon = Icons.download;
                            }
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(icon, size: 20, color: Colors.black54),
                                  const SizedBox(width: 10),
                                  Text(value, style: const TextStyle(color: Colors.black87)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedFormatRaceResults = newValue;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Download Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            foregroundColor: Colors.white, // Button color
                            backgroundColor: secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          icon: _isLoadingRaceResults
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.download, size: 20),
                          label: const Text(
                            'DOWNLOAD',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: _isLoadingRaceResults
                              ? null
                              : () {
                                  _downloadFile('race_results', _selectedFormatRaceResults);
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
