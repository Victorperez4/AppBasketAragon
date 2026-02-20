import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'package:tfg_appfede/screens/Jugadores.dart';

class EquipoPage extends StatefulWidget {
  final String nombreEquipo;

  const EquipoPage({
    super.key,
    required this.nombreEquipo,
  });

  @override
  State<EquipoPage> createState() => _EquipoPageState();
}

class _EquipoPageState extends State<EquipoPage> {
  bool _esFavorito = false;

  // Datos de ejemplo del equipo (luego vendrán de la BD)
  late final Map<String, dynamic> _equipoInfo;
  late final List<Map<String, dynamic>> _jugadores;
  late final List<Map<String, dynamic>> _ultimosPartidos;

  @override
  void initState() {
    super.initState();

    _equipoInfo = {
      'nombre': widget.nombreEquipo,
      'puntosAFavorPromedio': 82.5,
      'puntosEnContraPromedio': 75.3,
      'victorias': 18,
      'derrotas': 4,
    };

    _jugadores = [
      {
        'nombre': 'Pablo Pérez',
        'dorsal': 7,
        'puntos': 18.6,
        'rebotes': 6.2,
        'asistencias': 3.8,
      },
      {
        'nombre': 'Adrián Fernández',
        'dorsal': 10,
        'puntos': 15.4,
        'rebotes': 8.1,
        'asistencias': 2.5,
      },
      {
        'nombre': 'Miguel Torres',
        'dorsal': 23,
        'puntos': 12.7,
        'rebotes': 4.3,
        'asistencias': 5.9,
      },
    ];

    _ultimosPartidos = [
      {'rival': 'CD Huesca', 'resultado': 'V 85-72'},
      {'rival': 'Oliver Basket', 'resultado': 'V 78-75'},
      {'rival': 'Caspe Basket', 'resultado': 'D 70-73'},
      {'rival': 'Barbastro BC', 'resultado': 'V 90-82'},
      {'rival': 'Ejea Basket', 'resultado': 'V 88-79'},
    ];
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

              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Info del equipo
                      _buildInfoEquipo(),

                      const SizedBox(height: 16),

                      // Últimos resultados
                      _buildUltimosResultados(),

                      const SizedBox(height: 16),

                      // Plantilla de jugadores
                      _buildPlantilla(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Header con favorito
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
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.blanco),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              widget.nombreEquipo,
              style: const TextStyle(
                color: AppColors.blanco,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _esFavorito ? Icons.star : Icons.star_border,
              color: _esFavorito ? AppColors.amarilloAragon : AppColors.blanco,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                _esFavorito = !_esFavorito;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_esFavorito
                      ? 'Equipo añadido a favoritos'
                      : 'Equipo eliminado de favoritos'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Información del equipo
  Widget _buildInfoEquipo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          // Logo del equipo (placeholder)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: AppColors.gradienteNaranjaAmarillo,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield,
              size: 60,
              color: AppColors.blanco,
            ),
          ),

          const SizedBox(height: 20),

          // Estadísticas del equipo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn(
                'Victorias',
                '${_equipoInfo['victorias']}',
                Colors.green,
              ),
              _buildStatColumn(
                'Derrotas',
                '${_equipoInfo['derrotas']}',
                Colors.red,
              ),
            ],
          ),

          const Divider(height: 30),

          // Promedios
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn(
                'Pts a favor',
                _equipoInfo['puntosAFavorPromedio'].toStringAsFixed(1),
                AppColors.naranja,
              ),
              _buildStatColumn(
                'Pts en contra',
                _equipoInfo['puntosEnContraPromedio'].toStringAsFixed(1),
                Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Columna de estadística
  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  /// Últimos resultados
  Widget _buildUltimosResultados() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Últimos Resultados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Lista de resultados
          ...(_ultimosPartidos.map((partido) {
            bool esVictoria = partido['resultado'].startsWith('V');
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.grisClaro.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'vs ${partido['rival']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: esVictoria ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      partido['resultado'],
                      style: const TextStyle(
                        color: AppColors.blanco,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          })),
        ],
      ),
    );
  }

  /// Plantilla de jugadores
  Widget _buildPlantilla() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plantilla',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Lista de jugadores
          ...(_jugadores.map((jugador) => _buildJugadorCard(jugador))),
        ],
      ),
    );
  }

  /// Card de jugador
  Widget _buildJugadorCard(Map<String, dynamic> jugador) {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla del jugador
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JugadorPage(
              nombreJugador: jugador['nombre'],
              nombreEquipo: widget.nombreEquipo,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.grisClaro.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Dorsal
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppColors.gradienteNaranjaAmarillo,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${jugador['dorsal']}',
                  style: const TextStyle(
                    color: AppColors.blanco,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Nombre y estadísticas
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
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildMiniStat('${jugador['puntos']}', 'Pts'),
                      const SizedBox(width: 12),
                      _buildMiniStat('${jugador['rebotes']}', 'Reb'),
                      const SizedBox(width: 12),
                      _buildMiniStat('${jugador['asistencias']}', 'Ast'),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  /// Mini estadística
  Widget _buildMiniStat(String value, String label) {
    return Text(
      '$value $label',
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }
}