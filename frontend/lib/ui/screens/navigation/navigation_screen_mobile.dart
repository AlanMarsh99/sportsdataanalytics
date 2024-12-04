import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/ui/widgets/app_bar.dart';
import 'package:frontend/ui/widgets/drawer.dart';
import 'package:frontend/ui/widgets/end_drawer.dart';

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
