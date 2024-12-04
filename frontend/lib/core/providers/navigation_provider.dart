import 'package:flutter/material.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/ui/screens/drivers/drivers_screen.dart';
import 'package:frontend/ui/screens/game/game_first_screen.dart';
import 'package:frontend/ui/screens/game/tutorial_screen.dart';
import 'package:frontend/ui/screens/home_screen.dart';
import 'package:frontend/ui/screens/download_screen.dart';
import 'package:frontend/ui/screens/races/races_screen.dart';
import 'package:frontend/ui/screens/teams/teams_screen.dart';
import 'package:frontend/ui/widgets/carousel_game_options.dart';
import 'package:provider/provider.dart';

class NavigationProvider extends ChangeNotifier {
  NavigationProvider() {}
  int _selectedIndex = 0;
  bool _extended = false;
  String _screenTitle = "DRIVERS";
  String _currentRoute = 'home';
  Widget _selectedScreen = const HomeScreen();

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
  ];

  int get selectedIndex => _selectedIndex;
  String get currentRoute => _currentRoute;

  void updateIndex(int index) {
    _selectedIndex = index;
    switch (index) {
      case 0:
        _selectedScreen = HomeScreen();
        _currentRoute = 'home';
        break;
      case 1:
        _selectedScreen = RacesScreen();
        _currentRoute = 'races';
        break;
      case 2:
        _selectedScreen = DriversScreen();
        _currentRoute = 'drivers';
        break;
      case 3:
        _selectedScreen = TeamsScreen();
        _currentRoute = 'teams';
        break;
      case 4:
        _selectedScreen =
            Consumer<AuthService>(builder: (context, auth, child) {
          if (auth.status == Status.Authenticated && auth.userApp != null) {
            if (auth.userApp!.firstTimeTutorial) {
              return TutorialScreen();
            } else {
              return F1Carousel();
            }
          } else {
            return TutorialScreen();
          }
        });
        _currentRoute = 'game';
        break;
      case 5:
        _selectedScreen = DownloadScreen();
        _currentRoute = 'download';
        break;
    }
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
