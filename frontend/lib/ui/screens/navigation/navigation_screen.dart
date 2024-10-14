import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/ui/screens/navigation/navigation_screen_mobile.dart';
import 'package:frontend/ui/screens/navigation/navigation_screen_web.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    var nav = Provider.of<NavigationProvider>(context);
    return ScreenTypeLayout.builder(
      desktop: (BuildContext context) => NavigationScreenWeb(nav: nav),
      //tablet: (BuildContext context) =>NavigationScreenMobile(nav: nav),
      mobile: (BuildContext context) => NavigationScreenMobile(nav: nav),
    );
  }
}
