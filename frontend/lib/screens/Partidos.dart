import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'package:tfg_appfede/widgets/MenuLateral.dart';
import 'package:tfg_appfede/widgets/Header.dart';
import 'package:tfg_appfede/widgets/BarraInferior.dart';
import 'package:tfg_appfede/widgets/NavegadorJornadas.dart';
import 'package:tfg_appfede/widgets/partidos/TarjetasPartidos.dart';

class PartidosPage extends StatefulWidget {
  const PartidosPage({super.key});

  @override
  State<PartidosPage> createState() => _PartidosPageState();
}

class _PartidosPageState extends State<PartidosPage> {
  int _jornadaActual = 15; // Jornada actual seleccionada
  final int _totalJornadas = 22; // Total de jornadas en la temporada

  // Datos de ejemplo de partidos por jornada y liga (luego vendrán de la BD)
  late Map<int, List<Map<String, dynamic>>> _partidosPorJornada;

  @override
  void initState() {
    super.initState();
    _inicializarDatos();
  }

  /// Inicializar datos de ejemplo
  void _inicializarDatos() {
    _partidosPorJornada = {
      15: [
        // Liga Senior Categoría A
        {
          'liga': 'Senior - Categoría A',
          'partidos': [
            {
              'id': 1,
              'equipoLocal': 'Basket Zaragoza',
              'equipoVisitante': 'CD Huesca',
              'resultadoLocal': 85,
              'resultadoVisitante': 72,
              'fecha': '08/03/2026',
              'hora': '18:00',
              'pabellon': 'Pabellón Príncipe Felipe',
            },
            {
              'id': 2,
              'equipoLocal': 'Oliver Basket',
              'equipoVisitante': 'Caspe Basket',
              'resultadoLocal': 78,
              'resultadoVisitante': 80,
              'fecha': '08/03/2026',
              'hora': '20:00',
              'pabellon': 'Pabellón Municipal',
            },
          ],
        },
        // Liga Senior Categoría B
        {
          'liga': 'Senior - Categoría B',
          'partidos': [
            {
              'id': 3,
              'equipoLocal': 'Barbastro BC',
              'equipoVisitante': 'Ejea Basket',
              'resultadoLocal': 92,
              'resultadoVisitante': 88,
              'fecha': '08/03/2026',
              'hora': '19:00',
              'pabellon': 'Polideportivo Barbastro',
            },
            {
              'id': 4,
              'equipoLocal': 'Monzón CB',
              'equipoVisitante': 'Fraga Basket',
              'resultadoLocal': 71,
              'resultadoVisitante': 74,
              'fecha': '08/03/2026',
              'hora': '17:30',
              'pabellon': 'Pabellón Monzón',
            },
          ],
        },
        // Liga Juvenil Categoría A
        {
          'liga': 'Juvenil - Categoría A',
          'partidos': [
            {
              'id': 5,
              'equipoLocal': 'CAI Zaragoza Juvenil',
              'equipoVisitante': 'Huesca La Magia Juvenil',
              'resultadoLocal': 68,
              'resultadoVisitante': 65,
              'fecha': '09/03/2026',
              'hora': '11:00',
              'pabellon': 'Pabellón CAI',
            },
          ],
        },
        // Liga Infantil Categoría A
        {
          'liga': 'Infantil - Categoría A',
          'partidos': [
            {
              'id': 6,
              'equipoLocal': 'Peñas Huesca Infantil',
              'equipoVisitante': 'Oliver Infantil',
              'resultadoLocal': 52,
              'resultadoVisitante': 48,
              'fecha': '09/03/2026',
              'hora': '10:00',
              'pabellon': 'Polideportivo Huesca',
            },
            {
              'id': 7,
              'equipoLocal': 'Caspe Infantil',
              'equipoVisitante': 'Barbastro Infantil',
              'resultadoLocal': 45,
              'resultadoVisitante': 50,
              'fecha': '09/03/2026',
              'hora': '12:00',
              'pabellon': 'Pabellón Caspe',
            },
          ],
        },
      ],
      14: [
        // Jornada anterior
        {
          'liga': 'Senior - Categoría A',
          'partidos': [
            {
              'id': 8,
              'equipoLocal': 'CD Huesca',
              'equipoVisitante': 'Oliver Basket',
              'resultadoLocal': 75,
              'resultadoVisitante': 73,
              'fecha': '01/03/2026',
              'hora': '18:00',
              'pabellon': 'Polideportivo Huesca',
            },
          ],
        },
      ],
      16: [
        // Próxima jornada
        {
          'liga': 'Senior - Categoría A',
          'partidos': [
            {
              'id': 9,
              'equipoLocal': 'Basket Zaragoza',
              'equipoVisitante': 'Oliver Basket',
              'resultadoLocal': 0,
              'resultadoVisitante': 0,
              'fecha': '15/03/2026',
              'hora': '18:00',
              'pabellon': 'Pabellón Príncipe Felipe',
              'pendiente': true,
            },
          ],
        },
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderApp(titulo: 'Partidos'),
      drawer: const MenuLateral(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradienteAragon,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Navegación de jornadas
              NavegadorJornadas(
                jornadaActual: _jornadaActual,
                totalJornadas: _totalJornadas,
                onJornadaChanged: (nuevaJornada) {
                  setState(() {
                    _jornadaActual = nuevaJornada;
                  });
                },
              ),

              // Contenido - Lista de ligas con sus partidos
              Expanded(
                child: _buildContenido(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BarraInferior(selectedIndex: 3),
    );
  }

  /// Contenido principal - Ligas y partidos
  Widget _buildContenido() {
    final ligasJornada = _partidosPorJornada[_jornadaActual];

    if (ligasJornada == null || ligasJornada.isEmpty) {
      return _buildEstadoVacio();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ligasJornada.length,
      itemBuilder: (context, index) {
        final ligaData = ligasJornada[index];
        return _buildLigaCard(ligaData);
      },
    );
  }

  /// Card de una liga con sus partidos
  Widget _buildLigaCard(Map<String, dynamic> ligaData) {
    final String nombreLiga = ligaData['liga'];
    final List<dynamic> partidos = ligaData['partidos'];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
          // Header de la liga
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.negro,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: AppColors.blanco, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    nombreLiga,
                    style: const TextStyle(
                      color: AppColors.blanco,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.blanco.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${partidos.length} ${partidos.length == 1 ? 'partido' : 'partidos'}',
                    style: const TextStyle(
                      color: AppColors.blanco,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista de partidos
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: partidos.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final partido = partidos[index] as Map<String, dynamic>;
              return TarjetaPartido(partido: partido);
            },
          ),
        ],
      ),
    );
  }

  /// Estado vacío cuando no hay partidos
  Widget _buildEstadoVacio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sports_basketball_outlined,
            size: 100,
            color: AppColors.blancoOpacidad70,
          ),
          const SizedBox(height: 16),
          const Text(
            'No hay partidos en esta jornada',
            style: TextStyle(
              color: AppColors.blanco,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Navega a otras jornadas usando las flechas',
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