import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
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
