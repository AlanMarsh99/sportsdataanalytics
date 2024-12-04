import 'package:flutter/material.dart';
import 'package:frontend/core/providers/navigation_provider.dart';
import 'package:frontend/ui/theme.dart';

class MyDrawer extends StatelessWidget implements PreferredSizeWidget {
  const MyDrawer({Key? key, required this.nav, required this.isMobile}) : super(key: key);

  final NavigationProvider nav;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return  isMobile ? 
    Drawer(
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
                    _buildDrawerItem(context, 'DOWNLOADS', 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ) : Container();

  }

   Widget _buildDrawerItem(BuildContext context, String title, int value) {
    bool isSelected =
        value == nav.selectedIndex; // Verifica si es la pantalla actual
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
        nav.updateIndex(value);
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
