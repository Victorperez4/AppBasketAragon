import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'package:tfg_appfede/data/gestorFavoritos.dart';
import 'package:tfg_appfede/screens/Equipos.dart';
import 'package:tfg_appfede/screens/Jugadores.dart';
import 'package:tfg_appfede/widgets/BarraInferior.dart';
import 'package:tfg_appfede/widgets/Favoritos/TarjetaCategoriaFav.dart';
import 'package:tfg_appfede/widgets/Favoritos/TarjetaEquipoFav.dart';
import 'package:tfg_appfede/widgets/Favoritos/TarjetaJugadorFav.dart';
import 'package:tfg_appfede/widgets/Header.dart';
import 'package:tfg_appfede/widgets/MenuLateral.dart';
import 'Clasificacion.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuLateral(),
      appBar: const HeaderApp(titulo: "Favoritos"),
      bottomNavigationBar: const BarraInferior(selectedIndex: 3),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradienteAragon,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTabs(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLigasTab(),
                    _buildEquiposTab(),
                    _buildJugadoresTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tabs
  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.negroOpacidad50,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: AppColors.gradienteNaranjaAmarillo,
        ),
        labelColor: AppColors.blanco,
        unselectedLabelColor: AppColors.blancoOpacidad70,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        tabs: const [
          Tab(text: 'Ligas'),
          Tab(text: 'Equipos'),
          Tab(text: 'Jugadores'),
        ],
      ),
    );
  }

  /// Ligas favoritas (categorías)
  Widget _buildLigasTab() {
    final ligas = FavoritosManager().categoriasFavoritas.toList();

    if (ligas.isEmpty) {
      return _buildEmptyState('No tienes ligas favoritas');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: ligas.length,
      itemBuilder: (context, index) {
        final nombre = ligas[index];

        // Aquí decides cómo codificas la categoría. De momento, asumimos "Edad Nivel"
        final partes = nombre.split(' ');
        final categoriaEdad = partes.isNotEmpty ? partes.first : '';
        final categoriaNivel =
            partes.length > 1 ? partes.sublist(1).join(' ') : '';

        return TarjetaCategoria(
          nombre: nombre,
          categoriaEdad: categoriaEdad,
          categoriaNivel: categoriaNivel,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClasificacionPage(
                  categoriaEdad: categoriaEdad,
                  categoriaNivel: categoriaNivel,
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Equipos favoritos
  Widget _buildEquiposTab() {
    final equipos = FavoritosManager().equiposFavoritos.toList();

    if (equipos.isEmpty) {
      return _buildEmptyState('No tienes equipos favoritos');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: equipos.length,
      itemBuilder: (context, index) {
        final nombre = equipos[index];

        return TarjetaEquipo(
          nombre: nombre,
          posicion: '-',          // De momento sin datos reales
          proximoPartido: '-',
          rival: '-',
          esLocal: false,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EquipoPage(nombreEquipo: nombre),
              ),
            );
          },
        );
      },
    );
  }

  /// Jugadores favoritos
  Widget _buildJugadoresTab() {
    final jugadores = FavoritosManager().jugadoresFavoritos.toList();

    if (jugadores.isEmpty) {
      return _buildEmptyState('No tienes jugadores favoritos');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: jugadores.length,
      itemBuilder: (context, index) {
        final nombre = jugadores[index];

        return TarjetaJugador(
          nombre: nombre,
          equipo: '-',      // De momento sin datos reales
          puntos: 0,
          rebotes: 0,
          asistencias: 0,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JugadorPage(
                  nombreJugador: nombre,
                  nombreEquipo: '-',
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Estado vacío
  Widget _buildEmptyState(String mensaje) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_border,
            size: 80,
            color: AppColors.blancoOpacidad70,
          ),
          const SizedBox(height: 16),
          Text(
            mensaje,
            style: const TextStyle(
              color: AppColors.blanco,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Añade tus favoritos desde las otras pantallas',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blancoOpacidad70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
