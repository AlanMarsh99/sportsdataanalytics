import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/ui/screens/authentication/login_screen.dart';
import 'package:frontend/ui/theme.dart';
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
      body: widget.nav.selectedScreen,
      appBar: AppBar(
        backgroundColor: primary,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon:
                  const Icon(Icons.menu, color: Colors.white), // Icono del menú
              onPressed: () {
                Scaffold.of(context)
                    .openDrawer(); // Abre el Drawer al hacer clic
              },
            );
          },
        ),
        actions: [
          widget.nav.userAuthenticated
              ? GestureDetector(
                  onTap: () {},
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        AssetImage('assets/images/placeholder.png'),
                  ),
                )
              : TextButton(
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
                ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF1B222C),
          child: Column(
            children: [
              // Icono de cerrar (cruz) en la parte superior izquierda
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Cierra el Drawer al hacer clic
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    _buildDrawerItem(context, 'HOME', 0),
                    const SizedBox(height: 10),
                    _buildDrawerItem(context, 'RACES', 1),
                    const SizedBox(height: 10),
                    _buildDrawerItem(context, 'DRIVERS', 2),
                    const SizedBox(height: 10),
                    _buildDrawerItem(context, 'TEAMS', 3),
                    const SizedBox(height: 10),
                    _buildDrawerItem(context, 'GAME', 4),
                    const SizedBox(height: 10),
                    _buildDrawerItem(context, 'USER MANUAL', 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, int value) {
    bool isSelected =
        value == widget.nav.selectedIndex; // Verifica si es la pantalla actual
    return TextButton(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: isSelected
              ? redAccent
              : Colors.white, // Rojo si está seleccionada, blanco si no
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      onPressed: () {
        // Acción al seleccionar el item (cambiar de pantalla)
        Navigator.pop(context); // Cierra el drawer
        // Aquí puedes agregar lógica para navegar entre pantallas
        widget.nav.updateIndex(value);
      },
    );
  }
}
