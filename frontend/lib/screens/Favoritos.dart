import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'package:tfg_appfede/screens/Equipos.dart';
import 'package:tfg_appfede/screens/Jugadores.dart';
import 'package:tfg_appfede/widgets/BarraInferior.dart';
import 'Clasificacion.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Datos de ejemplo de ligas favoritas
  final List<Map<String, dynamic>> _ligasFavoritas = [
    {
      'nombre': 'Senior A',
      'categoriaEdad': 'Senior',
      'categoriaNivel': 'Categoría A',
    },
    {
      'nombre': 'Infantil B',
      'categoriaEdad': 'Infantil',
      'categoriaNivel': 'Categoría B',
    },
  ];

  // Datos de ejemplo de equipos favoritos (luego vendrán de la BD)
  final List<Map<String, dynamic>> _equiposFavoritos = [
    {
      'nombre': 'Baloncesto Tarazona',
      'posicion': '15º',
      'proximoPartido': '24/11',
      'rival': 'FC Barcelona',
      'esLocal': false,
    },
    {
      'nombre': 'Kai Zaragoza',
      'posicion': '3º',
      'proximoPartido': '24/11',
      'rival': 'Valencia Basket',
      'esLocal': true,
    },
    {
      'nombre': 'Oliver Basket',
      'posicion': '1º',
      'proximoPartido': 'Descanso',
      'rival': '',
      'esLocal': false,
    },
  ];

  // Datos de ejemplo de jugadores favoritos
  final List<Map<String, dynamic>> _jugadoresFavoritos = [
    {
      'nombre': 'Pablo Pérez',
      'equipo': 'CD Huesca',
      'puntos': 18.6,
      'asistencias': 11.1,
      'rebotes': 6.0,
    },
    {
      'nombre': 'Adrián Fernández',
      'equipo': 'CD Zaragoza',
      'puntos': 17.2,
      'asistencias': 6.8,
      'rebotes': 7.5,
    },
  ];

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradienteAragon,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Tabs para alternar entre equipos y jugadores
              _buildTabs(),

              // Contenido según la tab seleccionada
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
      bottomNavigationBar: const BarraInferior(selectedIndex: 2),
    );
  }

  /// Header con título
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.negro,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star, color: AppColors.amarilloAragon, size: 28),
          SizedBox(width: 12),
          Text(
            'MIS FAVORITOS',
            style: TextStyle(
              color: AppColors.blanco,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Tabs para alternar entre ligas, equipos y jugadores
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

  /// Tab de ligas favoritas
  Widget _buildLigasTab() {
    if (_ligasFavoritas.isEmpty) {
      return _buildEmptyState('No tienes ligas favoritas');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _ligasFavoritas.length,
      itemBuilder: (context, index) {
        final liga = _ligasFavoritas[index];
        return _buildLigaCard(liga);
      },
    );
  }

  /// Card de liga favorita
  Widget _buildLigaCard(Map<String, dynamic> liga) {
    return GestureDetector(
      onTap: () {
        // Navegar a la clasificación de esta liga
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClasificacionPage(
              categoriaEdad: liga['categoriaEdad'],
              categoriaNivel: liga['categoriaNivel'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.blanco,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icono de liga
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppColors.gradienteNaranjaAmarillo,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: AppColors.blanco,
                  size: 32,
                ),
              ),

              const SizedBox(width: 16),

              // Información de la liga
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      liga['nombre'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${liga['categoriaEdad']} - ${liga['categoriaNivel']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  /// Tab de equipos favoritos
  Widget _buildEquiposTab() {
    if (_equiposFavoritos.isEmpty) {
      return _buildEmptyState('No tienes equipos favoritos');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _equiposFavoritos.length,
      itemBuilder: (context, index) {
        final equipo = _equiposFavoritos[index];
        return _buildEquipoCard(equipo);
      },
    );
  }

  /// Card de un equipo favorito
  Widget _buildEquipoCard(Map<String, dynamic> equipo) {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla del equipo
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EquipoPage(nombreEquipo: equipo['nombre']),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.blanco,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icono del equipo (placeholder)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppColors.gradienteRojoNaranja,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shield,
                  color: AppColors.blanco,
                  size: 32,
                ),
              ),

              const SizedBox(width: 16),

              // Información del equipo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            equipo['nombre'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Posición en la clasificación
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.naranja,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            equipo['posicion'],
                            style: const TextStyle(
                              color: AppColors.blanco,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Próximo partido
                    if (equipo['proximoPartido'] != 'Descanso')
                      Row(
                        children: [
                          Text(
                            'Próximo partido: ${equipo['proximoPartido']}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),

                    if (equipo['rival'].isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            equipo['esLocal']
                                ? Icons.home
                                : Icons.flight_takeoff,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            equipo['rival'],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),

                    if (equipo['proximoPartido'] == 'Descanso')
                      const Text(
                        'Descanso',
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tab de jugadores favoritos
  Widget _buildJugadoresTab() {
    if (_jugadoresFavoritos.isEmpty) {
      return _buildEmptyState('No tienes jugadores favoritos');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _jugadoresFavoritos.length,
      itemBuilder: (context, index) {
        final jugador = _jugadoresFavoritos[index];
        return _buildJugadorCard(jugador);
      },
    );
  }

  /// Card de un jugador favorito
  Widget _buildJugadorCard(Map<String, dynamic> jugador) {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla del jugador
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JugadorPage(
              nombreJugador: jugador['nombre'],
              nombreEquipo: jugador['equipo'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.blanco,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar del jugador
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppColors.gradienteNaranjaAmarillo,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.blanco,
                  size: 32,
                ),
              ),

              const SizedBox(width: 16),

              // Información del jugador
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jugador['nombre'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      jugador['equipo'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Estadísticas
                    Row(
                      children: [
                        _buildStat('${jugador['puntos']} Pts'),
                        const SizedBox(width: 12),
                        _buildStat('${jugador['rebotes']} Reb'),
                        const SizedBox(width: 12),
                        _buildStat('${jugador['asistencias']} Ast'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget de una estadística pequeña
  Widget _buildStat(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.grisClaro,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Estado vacío cuando no hay favoritos
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