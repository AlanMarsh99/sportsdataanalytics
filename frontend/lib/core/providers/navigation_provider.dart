import 'package:flutter/material.dart';
import 'package:frontend/ui/screens/drivers/drivers_screen.dart';
import 'package:frontend/ui/screens/game/game_first_screen.dart';
import 'package:frontend/ui/screens/home_screen.dart';
import 'package:frontend/ui/screens/download_screen.dart';
import 'package:frontend/ui/screens/races/races_screen.dart';
import 'package:frontend/ui/screens/teams/teams_screen.dart';
import 'package:frontend/ui/theme.dart';

class NavigationProvider extends ChangeNotifier {
  NavigationProvider() {}
  int _selectedIndex = 0;
  bool _extended = false;
  String _screenTitle = "DRIVERS";
  bool _userAuthenticated = false;

  final List<Widget> _screens = [
    const HomeScreen(),
    const RacesScreen(),
    const DriversScreen(),
    const TeamsScreen(),
    const GameFirstScreen(),
    const DownloadScreen(),
  ];

  final List<NavigationRailDestination> _destinations = [
    const NavigationRailDestination(
      icon: Icon(Icons.home),
      label: Text('HOME'),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.flag),
      label: Text('RACES'),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.drive_eta_outlined),
      label: Text('DRIVERS'),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.group),
      label: Text('TEAMS'),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.play_arrow),
      label: Text('GAME'),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.download),
      label: Text('DOWNLOADS'),
    ),
    /*NavigationRailDestination(
      icon: Icon(Icons.insert_drive_file_outlined),
      selectedIcon: Icon(Icons.insert_drive_file),
      label: Text('HEX Files'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.qr_code_scanner_outlined),
      selectedIcon: Icon(Icons.qr_code_scanner),
      label: Text('QR Reader'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.group_outlined),
      selectedIcon: Icon(Icons.group),
      label: Text('Users'),
    ),*/
  ];

  bool get userAuthenticated => _userAuthenticated;
  void authenticateUser() {
    _userAuthenticated = true;
    notifyListeners();
  }

  int get selectedIndex => _selectedIndex;
  void updateIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  bool get extended => _extended;
  void setExtended(bool value) {
    _extended = value;
    notifyListeners();
  }

  String get screenTitle => _screenTitle;
  void updateAppBar(String value) {
    _screenTitle = value;
    notifyListeners();
  }

  Widget get selectedScreen => _screens.elementAt(_selectedIndex);
  List<Widget> get screens => _screens;
  List<NavigationRailDestination> get destinations => _destinations;
}
