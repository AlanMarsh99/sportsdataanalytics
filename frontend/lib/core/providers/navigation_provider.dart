import 'package:flutter/material.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/ui/responsive.dart';
import 'package:frontend/ui/screens/authentication/forgot_password_screen.dart';
import 'package:frontend/ui/screens/authentication/login_screen.dart';
import 'package:frontend/ui/screens/authentication/signup_screen.dart';
import 'package:frontend/ui/screens/drivers/drivers_screen.dart';
import 'package:frontend/ui/screens/game/game_first_screen.dart';
import 'package:frontend/ui/screens/game/game_login_screen.dart';
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

  Widget get selectedScreen => _selectedScreen;

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
      icon: Icon(Icons.home_rounded),
      label: Text('HOME'),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.sports_score_rounded),
      label: Text('RACES'),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.sports_motorsports_rounded),
      label: Text('DRIVERS'),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.group_rounded),
      label: Text('TEAMS'),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.sports_esports_rounded),
      label: Text('GAME'),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.download_rounded),
      label: Text('DOWNLOADS'),
    ),
  ];

  int get selectedIndex => _selectedIndex;
  String get currentRoute => _currentRoute;

  void setRoute(String route) {
    _currentRoute = route;
    notifyListeners();
  }

  void updateIndex(int index) {
    _selectedIndex = index;
    print("Updating index to $index");
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
            return GameLoginScreen();
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

  //Widget get selectedScreen => _screens.elementAt(_selectedIndex);
  List<Widget> get screens => _screens;
  List<NavigationRailDestination> get destinations => _destinations;
}
