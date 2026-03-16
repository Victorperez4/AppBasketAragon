import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'package:tfg_appfede/screens/Perfil.dart';
import 'package:tfg_appfede/screens/Tienda.dart';
import '../screens/InicioApp.dart';
import '../screens/Ligas.dart';
import '../screens/Favoritos.dart';
//import '../screens/Tienda.dart';

// import '../screens/Perfil.dart'; // TODO: Crear pantalla de perfil

/// Widget reutilizable para el menú de navegación inferior
/// Usado en las pantallas principales: Ligas, Tienda, Inicio, Favoritos y Perfil
class BarraInferior extends StatelessWidget {
  final int selectedIndex;

  const BarraInferior({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.negro,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.negro,
        selectedItemColor: AppColors.naranja,
        unselectedItemColor: AppColors.grisClaro,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (index) => _handleNavigation(context, index),
        items: [
          // Ligas
          const BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events, size: 24),
            label: 'Ligas',
          ),
          
          // Tienda
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag, size: 24),
            label: 'Tienda',
          ),
          
          // Inicio (Logo FAB en el centro)
          BottomNavigationBarItem(
            icon: _buildLogoIcon(selectedIndex == 2),
            label: 'Inicio',
          ),
          
          // Favoritos
          const BottomNavigationBarItem(
            icon: Icon(Icons.star, size: 24),
            label: 'Favoritos',
          ),
          
          // Perfil
          const BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  /// Widget del logo para el botón de Inicio (centro)
  Widget _buildLogoIcon(bool isSelected) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        gradient: isSelected 
            ? AppColors.gradienteNaranjaAmarillo 
            : null,
        color: isSelected ? null : AppColors.grisClaro.withOpacity(0.3),
        shape: BoxShape.circle,
        border: isSelected 
            ? Border.all(color: AppColors.naranja, width: 2)
            : null,
      ),
      padding: const EdgeInsets.all(6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/LogoFAB.png',
          fit: BoxFit.cover,
          // Si no tienes la imagen, usa un placeholder con el texto FAB
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: AppColors.gradienteRojoNaranja,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'FAB',
                  style: TextStyle(
                    color: AppColors.blanco,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Manejar la navegación entre pantallas
  void _handleNavigation(BuildContext context, int index) {
    // Si ya estamos en la pantalla seleccionada, no hacer nada
    if (index == selectedIndex) return;

    // Navegar según el índice
    switch (index) {
      case 0:
        // Ir a Ligas
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LigasPage()),
        );
        break;
        
      case 1:
        // Ir a Tienda
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TiendaPage()),
        );
        break;
        
      case 2:
        // Ir a Inicio
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InicioPage()),
        );
        break;
        
      case 3:
        // Ir a Favoritos
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FavoritosPage()),
        );
        break;
        
      case 4:
        // Ir a Perfil
        // TODO: Descomentar cuando se cree la pantalla de Perfil
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) => const PerfilPage()),
         );
        break;
    }
  }
}