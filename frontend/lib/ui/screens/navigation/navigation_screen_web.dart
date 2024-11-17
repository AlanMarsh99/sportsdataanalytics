import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/ui/screens/authentication/login_screen.dart';
import 'package:frontend/ui/theme.dart';
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
      duration: Duration(milliseconds: 200),
    );

    _myAnimation = CurvedAnimation(curve: Curves.linear, parent: _controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<NavigationRailDestination> _destinations;
    //var user = Provider.of<AuthProvider>(context).userCNC4;

    _destinations = widget.nav.destinations;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: InkWell(
          onTap: () {
            widget.nav.updateIndex(0);
          },
          child: Image.asset('assets/logo/logo.png',
              height: 30, fit: BoxFit.cover),
        ),
        actions: [
          Consumer<AuthService>(
            builder: (context, auth, child) {
              if (auth.status == Status.Authenticated) {
                return GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        AssetImage('assets/images/placeholder.png'),
                  ),
                );
              } else {
                return TextButton(
                  child: const Text(
                    'Log in',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                );
              }
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIconTheme: IconThemeData(color: secondary),
            unselectedIconTheme: IconThemeData(color: Colors.white, opacity: 1),
            extended: widget.nav.extended,
            selectedIndex: widget.nav.selectedIndex,
            destinations: _destinations,
            onDestinationSelected: (value) {
              widget.nav.updateIndex(value);
            },
            leading: IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                color: Colors.white,
                progress: _myAnimation,
              ),
              onPressed: () {
                if (_flag) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }

                _flag = !_flag;
                if (widget.nav.extended) {
                  widget.nav.setExtended(false);
                } else {
                  widget.nav.setExtended(true);
                }
              },
            ),
          ),
          Expanded(
            child: widget.nav.selectedScreen,
          ),
        ],
      ),
    );
  }
}
