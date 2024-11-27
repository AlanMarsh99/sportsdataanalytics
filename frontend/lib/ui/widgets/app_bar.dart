import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/core/services/auth_services.dart';
import 'package:frontend/ui/screens/authentication/login_screen.dart';
import 'package:frontend/ui/theme.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key, required this.nav, required this.isMobile})
      : super(key: key);

  final NavigationProvider nav;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? AppBar(
            backgroundColor: primary,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu,
                      color: Colors.white), // Icono del menú
                  onPressed: () {
                    Scaffold.of(context)
                        .openDrawer(); // Abre el Drawer al hacer clic
                  },
                );
              },
            ),
            title: InkWell(
              onTap: () {
                nav.updateIndex(0);
              },
              child: Image.asset('assets/logo/logo.png',
                  height: 30, fit: BoxFit.cover),
            ),
            actions: [
              Consumer<AuthService>(
                builder: (context, auth, child) {
                  if (auth.status == Status.Authenticated &&
                      auth.userApp != null) {
                    return InkWell(
                      onTap: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(
                            'assets/avatars/${auth.userApp!.avatar}.png'),
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
          )
        : AppBar(
            backgroundColor: primary,
            title: InkWell(
              onTap: () {
                nav.updateIndex(0);
              },
              child: Image.asset('assets/logo/logo.png',
                  height: 30, fit: BoxFit.cover),
            ),
            actions: [
              Consumer<AuthService>(
                builder: (context, auth, child) {
                  if (auth.status == Status.Authenticated &&
                      auth.userApp != null) {
                    return InkWell(
                      onTap: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(
                            'assets/avatars/${auth.userApp!.avatar}.png'),
                      ),
                    );
                  } else {
                    return TextButton(
                      child: const Text(
                        'Log in',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
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
          );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
