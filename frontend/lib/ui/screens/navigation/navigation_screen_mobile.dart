import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/core/providers/user_provider.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/ui/screens/authentication/login_screen.dart';
import 'package:frontend/ui/screens/download_screen.dart';
import 'package:frontend/ui/screens/drivers/drivers_screen.dart';
import 'package:frontend/ui/screens/game/game_first_screen.dart';
import 'package:frontend/ui/screens/home_screen.dart';
import 'package:frontend/ui/screens/races/races_screen.dart';
import 'package:frontend/ui/screens/teams/teams_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:frontend/ui/widgets/app_bar.dart';
import 'package:frontend/ui/widgets/drawer.dart';
import 'package:frontend/ui/widgets/end_drawer.dart';
import 'package:provider/provider.dart';

class NavigationScreenMobile extends StatefulWidget {
  const NavigationScreenMobile({Key? key, required this.nav}) : super(key: key);

  final NavigationProvider nav;

  @override
  _NavigationScreenMobileState createState() => _NavigationScreenMobileState();
}

class _NavigationScreenMobileState extends State<NavigationScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(nav: widget.nav, isMobile: true),
      drawer: MyDrawer(nav: widget.nav, isMobile: true),
      endDrawer: const EndDrawer(),
      body: Navigator(
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
    );
  }
}
