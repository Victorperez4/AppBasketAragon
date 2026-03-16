import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'package:tfg_appfede/data/gestorFavoritos.dart';
import 'package:tfg_appfede/services/autenticacion_service.dart';
import 'package:tfg_appfede/widgets/BarraInferior.dart';
import 'package:tfg_appfede/widgets/Header.dart';
import 'package:tfg_appfede/widgets/MenuLateral.dart';
import 'Inicio/InicioSesion.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  void _cargarUsuario() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuLateral(),
      appBar: const HeaderApp(titulo: "Mi Perfil"),
      bottomNavigationBar: const BarraInferior(selectedIndex: 4),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradienteAragon,
        ),
        child: SafeArea(
          child: FutureBuilder<Usuario?>(
            future: AutenticacionService.obtenerUsuarioActual(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.amarilloAragon),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return _buildSinSesion();
              }

              Usuario usuario = snapshot.data!;
              return _buildPerfil(usuario);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSinSesion() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle,
            size: 80,
            color: AppColors.blancoOpacidad70,
          ),
          const SizedBox(height: 20),
          const Text(
            'No hay sesión iniciada',
            style: TextStyle(
              color: AppColors.blanco,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Por favor inicia sesión para ver tu perfil',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blancoOpacidad70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.naranja,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const InicioSesionPage()),
              );
            },
            child: const Text(
              'Ir a Inicio de Sesión',
              style: TextStyle(
                color: AppColors.blanco,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerfil(Usuario usuario) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar y nombre (CENTRADO)
          _buildHeaderPerfil(usuario),
          const SizedBox(height: 30),

          // Información personal
          _buildSeccion(
            titulo: 'Información Personal',
            children: [
              _buildFilaInfo(
                label: 'Nombre',
                valor: usuario.nombre,
                icono: Icons.person,
              ),
              const SizedBox(height: 16),
              _buildFilaInfo(
                label: 'Apellidos',
                valor: usuario.apellidos,
                icono: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildFilaInfo(
                label: 'Correo Electrónico',
                valor: usuario.email,
                icono: Icons.email,
              ),
              const SizedBox(height: 16),
              _buildFilaInfo(
                label: 'Nombre de Usuario',
                valor: usuario.username,
                icono: Icons.alternate_email,
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Rol e información adicional
          _buildSeccion(
            titulo: 'Información de Cuenta',
            children: [
              _buildFilaInfo(
                label: 'Rol',
                valor: usuario.rol,
                icono: _getIconoRol(usuario.rol),
              ),
              if (usuario.licencia != null) ...[
                const SizedBox(height: 16),
                _buildFilaInfo(
                  label: 'Número de Licencia',
                  valor: usuario.licencia!,
                  icono: Icons.card_membership,
                ),
              ],
            ],
          ),
          const SizedBox(height: 30),

          // Estadísticas
          _buildSeccion(
            titulo: 'Mis Favoritos',
            children: [
              FutureBuilder<int>(
                future: Future.value(
                  FavoritosManager().equiposFavoritos.length +
                  FavoritosManager().jugadoresFavoritos.length +
                  FavoritosManager().categoriasFavoritas.length,
                ),
                builder: (context, snapshot) {
                  int totalFavoritos = snapshot.data ?? 0;
                  return Column(
                    children: [
                      _buildFilaInfo(
                        label: 'Total de Favoritos',
                        valor: totalFavoritos.toString(),
                        icono: Icons.star,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMiniEstadistica(
                            'Equipos',
                            FavoritosManager().equiposFavoritos.length.toString(),
                            Icons.sports_basketball,
                          ),
                          _buildMiniEstadistica(
                            'Jugadores',
                            FavoritosManager().jugadoresFavoritos.length.toString(),
                            Icons.person,
                          ),
                          _buildMiniEstadistica(
                            'Ligas',
                            FavoritosManager().categoriasFavoritas.length.toString(),
                            Icons.emoji_events,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Botón de cerrar sesión
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () => _mostrarConfirmacionCerrarSesion(),
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: AppColors.blanco,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeaderPerfil(Usuario usuario) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.gradienteNaranjaAmarillo,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // CENTRADO
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.blanco.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                usuario.nombre.isNotEmpty ? usuario.nombre[0] : '?',
                style: const TextStyle(
                  color: AppColors.blanco,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${usuario.nombre} ${usuario.apellidos}',
            textAlign: TextAlign.center, // CENTRADO
            style: const TextStyle(
              color: AppColors.blanco,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            usuario.rol,
            textAlign: TextAlign.center, // CENTRADO
            style: const TextStyle(
              color: AppColors.blanco,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccion({
    required String titulo,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            color: AppColors.blanco,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.blanco,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildFilaInfo({
    required String label,
    required String valor,
    required IconData icono,
  }) {
    return Row(
      children: [
        Icon(icono, color: AppColors.naranja, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valor,
                style: const TextStyle(
                  color: AppColors.negro,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniEstadistica(String label, String valor, IconData icono) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icono, color: AppColors.naranja, size: 28),
            const SizedBox(height: 8),
            Text(
              valor,
              style: const TextStyle(
                color: AppColors.negro,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconoRol(String rol) {
    switch (rol) {
      case 'Jugador':
        return Icons.sports_basketball;
      case 'Entrenador':
        return Icons.school;
      case 'Árbitro':
        return Icons.gavel;
      default:
        return Icons.person;
    }
  }

  void _mostrarConfirmacionCerrarSesion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await AutenticacionService.cerrarSesion();
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const InicioSesionPage()),
                );
              },
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}