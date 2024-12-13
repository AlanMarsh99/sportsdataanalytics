import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/ui/screens/authentication/forgot_password_screen.dart';
import 'package:frontend/ui/screens/authentication/login_screen.dart';
import 'package:frontend/ui/screens/authentication/signup_screen.dart';
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
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Listen to NavigationProvider changes and update Navigator
    final nav = Provider.of<NavigationProvider>(context, listen: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(
            builder: (_) => nav.selectedScreen,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.nav.currentRoute == 'login') {
      return LoginScreen(isMobile: true);
    }
    if (widget.nav.currentRoute == 'signup') {
      return SignUpScreen(isMobile: true);
    }
    if (widget.nav.currentRoute == 'forgotpassword') {
      return ForgotPasswordScreen(isMobile: true);
    }
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: MyAppBar(nav: widget.nav, isMobile: true),
        drawer: MyDrawer(nav: widget.nav, isMobile: true),
        endDrawer: const EndDrawer(),
        body: Consumer<NavigationProvider>(
          builder: (context, nav, child) {
            return Navigator(
              key: navigatorKey,
              onGenerateRoute: (RouteSettings settings) {
                Widget screen = nav.selectedScreen;
                return MaterialPageRoute(
                  builder: (_) => screen,
                  settings: settings,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
