import 'package:flutter/material.dart';
import 'package:frontend/core/services/api_service.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:frontend/utils/download_utils.dart';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
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

  // Controllers for Year and Round input fields
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _roundController = TextEditingController();
  final TextEditingController _constructorsYearController = TextEditingController();
  final TextEditingController _driversYearController = TextEditingController();

  // State variables for loading indicators
  bool _isLoadingUpcomingRace = false;
  bool _isLoadingLastRaceResults = false;
  bool _isLoadingRaceInfo = false;
  bool _isLoadingConstructorsStandings = false;
  bool _isLoadingDriversStandings = false;

  @override
  void dispose() {
    _yearController.dispose();
    _roundController.dispose();
    _constructorsYearController.dispose(); // Add this line
    _driversYearController.dispose(); 
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


  // Function to download PDF
  Future<void> _downloadPdf(String filename, Map<String, dynamic> data) async {
    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            // Customize PDF content based on dataType
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
              dataList = standingsList.map((standing) => {
                'Position': standing['position'].toString(),
                'Points': standing['points'].toString(),
                'Wins': standing['wins'].toString(),
                'Constructor Name': standing['constructor_name'].toString(),
              }).toList();
            } else if (filename == 'drivers_standings') {
              title = 'Drivers Standings';
              List<dynamic> standingsList = data['driver_standings'];
              dataList = standingsList.map((standing) => {
                'Position': standing['position'].toString(),
                'Points': standing['points'].toString(),
                'Wins': standing['wins'].toString(),
                'Driver Name': standing['driver_name'].toString(),
                'Constructor Name': standing['constructor_name'].toString(),
              }).toList();
            }

            // Build the PDF content
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  title,
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                if (filename == 'constructors_standings' || filename == 'drivers_standings')
                  pw.TableHelper.fromTextArray(
                    headers: dataList.isNotEmpty ? dataList[0].keys.toList() : [],
                    data: dataList.map((item) => item.values.toList()).toList(),
                  )
                else
                ...dataList.map((item) {
                  final key = item.keys.first;
                  final value = item.values.first;
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 5),
                    child: pw.Text('$key: $value', style: pw.TextStyle(fontSize: 14)),
                  );
                }).toList(),
              ],
            );
          },
        ),
      );

      Uint8List pdfBytes = await pdf.save();
      await downloadFile('$filename.pdf', pdfBytes, 'application/pdf');
      _showSuccessSnackBar('Successfully downloaded $filename.pdf');
    } catch (e) {
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
            ],
          ),
        ),
      ),
      ),
    );
  }
}
