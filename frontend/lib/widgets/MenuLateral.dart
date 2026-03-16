import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'package:tfg_appfede/screens/InicioApp.dart';
import 'package:tfg_appfede/screens/arbitros/ConfirmarAlineaciones.dart';
import 'package:tfg_appfede/screens/arbitros/Designaciones.dart';
import 'package:tfg_appfede/screens/entrenador/Alineacion.dart';
import 'package:tfg_appfede/services/autenticacion_service.dart';
import 'package:tfg_appfede/screens/Perfil.dart';
import 'package:tfg_appfede/screens/Inicio/InicioSesion.dart';
import 'package:tfg_appfede/screens/Inicio/Registro.dart';
import '../screens/Ligas.dart';
import '../screens/Favoritos.dart';
import '../screens/Tienda.dart';
import '../screens/Partidos.dart';

/// Enum para los roles de usuario
enum UserRole {
  invitado,
  aficionado,
  jugador,
  entrenador,
  arbitro,
}

/// Widget del menú lateral desplegable (Drawer)
/// Muestra opciones dinámicas según el rol del usuario
class MenuLateral extends StatefulWidget {
  final UserRole? userRole;
  final String? nombreUsuario;
  final String? emailUsuario;

  const MenuLateral({
    super.key,
    this.userRole,
    this.nombreUsuario,
    this.emailUsuario,
  });

  @override
  State<MenuLateral> createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {
  late Future<Map<String, dynamic>> _usuarioFuture;

  @override
  void initState() {
    super.initState();
    _usuarioFuture = _cargarUsuario();
  }

  Future<Map<String, dynamic>> _cargarUsuario() async {
    Usuario? usuario = await AutenticacionService.obtenerUsuarioActual();
    
    if (usuario != null) {
      return {
        'nombre': usuario.nombre,
        'apellidos': usuario.apellidos,
        'email': usuario.email,
        'rol': usuario.rol,
        'logueado': true,
      };
    } else {
      return {
        'nombre': 'Invitado',
        'apellidos': '',
        'email': 'no-registrado@example.com',
        'rol': 'Invitado',
        'logueado': false,
      };
    }
  }

  UserRole _mapRolToEnum(String rol) {
    switch (rol.toLowerCase()) {
      case 'jugador':
        return UserRole.jugador;
      case 'entrenador':
        return UserRole.entrenador;
      case 'árbitro':
      case 'arbitro':
        return UserRole.arbitro;
      case 'aficionado':
        return UserRole.aficionado;
      case 'invitado':
        return UserRole.invitado;
      default:
        return UserRole.invitado;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _usuarioFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Drawer(
            backgroundColor: AppColors.blanco,
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.gradienteAragon,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.amarilloAragon),
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Drawer(
            backgroundColor: AppColors.blanco,
            child: const Center(
              child: Text('Error al cargar datos del usuario'),
            ),
          );
        }

        final usuarioData = snapshot.data!;
        final rol = _mapRolToEnum(usuarioData['rol']);
        final nombre = usuarioData['nombre'];
        final apellidos = usuarioData['apellidos'];
        final email = usuarioData['email'];
        final logueado = usuarioData['logueado'];

        return Drawer(
          backgroundColor: AppColors.blanco,
          child: Column(
            children: [
              // Header del drawer con información del usuario
              _buildDrawerHeader(nombre, apellidos, email, rol),

              // Lista de opciones según el rol
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: _buildMenuOptions(context, rol),
                ),
              ),

              // Footer con versión y logout
              _buildDrawerFooter(context, rol, logueado),
            ],
          ),
        );
      },
    );
  }

  /// Header del drawer con foto y datos del usuario
  Widget _buildDrawerHeader(String nombre, String apellidos, String email, UserRole rol) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      decoration: const BoxDecoration(
        gradient: AppColors.gradienteAragon,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar del usuario
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.blanco,
            child: CircleAvatar(
              radius: 37,
              backgroundColor: AppColors.naranja,
              child: Text(
                _getInitials(nombre, apellidos, rol),
                style: const TextStyle(
                  color: AppColors.blanco,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Nombre del usuario
          Text(
            nombre.isNotEmpty ? '$nombre $apellidos' : 'Usuario',
            style: const TextStyle(
              color: AppColors.blanco,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          // Email o rol
          Text(
            email,
            style: TextStyle(
              color: AppColors.blancoOpacidad70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 8),

          // Badge del rol
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.naranja,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getRoleName(rol),
              style: const TextStyle(
                color: AppColors.blanco,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }


  /// Construir opciones del menú según el rol
  List<Widget> _buildMenuOptions(BuildContext context, UserRole userRole) {
    List<Widget> options = [];

    // Opciones comunes para todos
    options.addAll([
      _buildMenuItem(
        context,
        icon: Icons.home,
        title: 'Inicio',
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const InicioPage()),
          );
        },
      ),
      _buildMenuItem(
        context,
        icon: Icons.person,
        title: 'Mi Perfil',
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PerfilPage()),
          );
        },
      ),
      _buildMenuItem(
        context,
        icon: Icons.emoji_events,
        title: 'Ligas',
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LigasPage()),
          );
        },
      ),
      _buildMenuItem(
        context,
        icon: Icons.sports_basketball,
        title: 'Partidos',
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PartidosPage()),
          );
        },
      ),
      _buildMenuItem(
        context,
        icon: Icons.shopping_bag,
        title: 'Tienda',
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TiendaPage()),
          );
        },
      ),
    ]);

    // Opciones solo para usuarios registrados (no invitados)
    if (userRole != UserRole.invitado) {
      options.add(_buildMenuItem(
        context,
        icon: Icons.star,
        title: 'Favoritos',
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const FavoritosPage()),
          );
        },
      ));
    }

    // Divider
    options.add(const Divider());

    // Opciones específicas por rol
    switch (userRole) {
      case UserRole.jugador:
        options.addAll([
          _buildSectionTitle('Jugador'),
          _buildMenuItem(
            context,
            icon: Icons.analytics,
            title: 'Mis Estadísticas',
            onTap: () {
              Navigator.pop(context);
              _mostrarEnDesarrollo(context, 'Mis Estadísticas');
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.event,
            title: 'Mi Calendario',
            onTap: () {
              Navigator.pop(context);
              _mostrarEnDesarrollo(context, 'Mi Calendario');
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.group,
            title: 'Mi Equipo',
            onTap: () {
              Navigator.pop(context);
              _mostrarEnDesarrollo(context, 'Mi Equipo');
            },
          ),
        ]);
        break;

      case UserRole.entrenador:
        options.addAll([
          _buildSectionTitle('Entrenador'),
          _buildMenuItem(
            context,
            icon: Icons.group,
            title: 'Mis Equipos',
            onTap: () {
              Navigator.pop(context);
              _mostrarEnDesarrollo(context, 'Mis Equipos');
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.assignment,
            title: 'Presentar Alineación',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PresentarAlineacionPage(),
                ),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.event_note,
            title: 'Convocatorias',
            onTap: () {
              Navigator.pop(context);
              _mostrarEnDesarrollo(context, 'Convocatorias');
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.analytics,
            title: 'Estadísticas del Equipo',
            onTap: () {
              Navigator.pop(context);
              _mostrarEnDesarrollo(context, 'Estadísticas del Equipo');
            },
          ),
        ]);
        break;

      case UserRole.arbitro:
        options.addAll([
          _buildSectionTitle('Árbitro'),
          _buildMenuItem(
            context,
            icon: Icons.event,
            title: 'Mis Designaciones',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DesignacionesPage()),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.checklist,
            title: 'Confirmar Alineaciones',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConfirmarAlineacionesPage(),
                ),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.description,
            title: 'Actas de Partidos',
            onTap: () {
              Navigator.pop(context);
              _mostrarEnDesarrollo(context, 'Actas de Partidos');
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.report,
            title: 'Reportes',
            onTap: () {
              Navigator.pop(context);
              _mostrarEnDesarrollo(context, 'Reportes');
            },
          ),
        ]);
        break;

      case UserRole.aficionado:
        options.addAll([
          _buildSectionTitle('Aficionado'),
          _buildMenuItem(
            context,
            icon: Icons.notifications,
            title: 'Notificaciones',
            onTap: () {
              Navigator.pop(context);
              _mostrarEnDesarrollo(context, 'Notificaciones');
            },
          ),
        ]);
        break;

      case UserRole.invitado:
        options.addAll([
          _buildSectionTitle('Invitado'),
          _buildMenuItem(
            context,
            icon: Icons.login,
            title: 'Iniciar Sesión',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InicioSesionPage()),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.person_add,
            title: 'Registrarse',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegistroPage()),
              );
            },
          ),
        ]);
        break;
    }

    // Divider
    options.add(const Divider());

    // Opciones comunes finales
    options.addAll([
      _buildMenuItem(
        context,
        icon: Icons.settings,
        title: 'Configuración',
        onTap: () {
          Navigator.pop(context);
          _mostrarEnDesarrollo(context, 'Configuración');
        },
      ),
      _buildMenuItem(
        context,
        icon: Icons.help_outline,
        title: 'Ayuda',
        onTap: () {
          Navigator.pop(context);
          _mostrarEnDesarrollo(context, 'Ayuda');
        },
      ),
    ]);

    return options;
  }

  /// Item del menú
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.naranja),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      hoverColor: AppColors.grisClaro.withValues(alpha: 0.3),
    );
  }

  /// Título de sección
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  /// Footer del drawer
  Widget _buildDrawerFooter(BuildContext context, UserRole rol, bool logueado) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: [
          // Cerrar sesión (solo si está logueado)
          if (logueado)
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                _showLogoutDialog(context);
              },
            ),

          // Versión de la app
          const SizedBox(height: 8),
          Text(
            'Versión 1.0.0',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// Obtener iniciales del nombre
  String _getInitials(String nombre, String apellidos, UserRole rol) {
    if (nombre.isNotEmpty) {
      if (apellidos.isNotEmpty) {
        return '${nombre[0]}${apellidos[0]}'.toUpperCase();
      }
      return nombre[0].toUpperCase();
    }
    return _getRoleInitial(rol);
  }

  /// Obtener inicial del rol
  String _getRoleInitial(UserRole rol) {
    switch (rol) {
      case UserRole.jugador:
        return 'J';
      case UserRole.entrenador:
        return 'E';
      case UserRole.arbitro:
        return 'A';
      case UserRole.aficionado:
        return 'F';
      case UserRole.invitado:
        return 'I';
    }
  }

  /// Obtener nombre del rol
  String _getRoleName(UserRole rol) {
    switch (rol) {
      case UserRole.jugador:
        return 'Jugador';
      case UserRole.entrenador:
        return 'Entrenador';
      case UserRole.arbitro:
        return 'Árbitro';
      case UserRole.aficionado:
        return 'Aficionado';
      case UserRole.invitado:
        return 'Invitado';
    }
  }

  /// Mostrar diálogo de confirmación de cierre de sesión
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await AutenticacionService.cerrarSesion();
              if (mounted) {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context); // Cerrar drawer
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const InicioSesionPage()),
                );
              }
            },
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// Mostrar mensaje de funcionalidad en desarrollo
  void _mostrarEnDesarrollo(BuildContext context, String funcionalidad) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$funcionalidad en desarrollo'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}