import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/ui/screens/download_screen.dart';
import 'package:frontend/ui/screens/drivers/driver_allRaces_screen.dart';
import 'package:frontend/ui/screens/drivers/drivers_screen.dart';
import 'package:frontend/ui/screens/game/game_first_screen.dart';
import 'package:frontend/ui/screens/home_screen.dart';
import 'package:frontend/ui/screens/races/races_detail_screen.dart';
import 'package:frontend/ui/screens/races/races_screen.dart';
import 'package:frontend/ui/screens/teams/teams_detail_screen.dart';
import 'package:frontend/ui/screens/teams/teams_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/app_bar.dart';
import 'package:frontend/ui/widgets/end_drawer.dart';
import 'package:provider/provider.dart';

class NavigationScreenWeb extends StatefulWidget {
  const NavigationScreenWeb({Key? key, required this.nav}) : super(key: key);
  final NavigationProvider nav;

  @override
  _NavigationScreenWebState createState() => _NavigationScreenWebState();
}

class _NavigationScreenWebState extends State<NavigationScreenWeb>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _myAnimation;
  bool _flag = true;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _myAnimation = CurvedAnimation(curve: Curves.linear, parent: _controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<NavigationRailDestination> destinations = widget.nav.destinations;

    return Scaffold(
      appBar: MyAppBar(nav: widget.nav, isMobile: false),
      body: Row(
        children: [
          NavigationRail(
            selectedIconTheme: IconThemeData(color: secondary),
            unselectedIconTheme: IconThemeData(color: Colors.white, opacity: 1),
            extended: widget.nav.extended,
            selectedIndex: widget.nav.selectedIndex,
            destinations: destinations,
            onDestinationSelected: (value) {
              widget.nav.updateIndex(value);
            },
            leading: IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                widget.nav.setExtended(!widget.nav.extended);
              },
            ),
          ),
          Expanded(
            child: Navigator(
              key: GlobalKey<NavigatorState>(),
              initialRoute: widget.nav.currentRoute,
              onGenerateRoute: (RouteSettings settings) {
                Widget screen = widget.nav.selectedScreen;
                return MaterialPageRoute(
                  builder: (_) => screen,
                  settings: settings,
                );
              },
            ),
          ),
        ],
      ),
      endDrawer: const EndDrawer(),
    );
  }
}
