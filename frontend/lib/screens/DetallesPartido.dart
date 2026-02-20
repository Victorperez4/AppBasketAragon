import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';

class DetallePartidoPage extends StatelessWidget {
  final Map<String, dynamic> partido;

  const DetallePartidoPage({
    super.key,
    required this.partido,
  });

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo de estadísticas del partido
    final estadisticas = {
      'equipoLocal': {
        'puntos': partido['resultadoLocal'],
        'rebotes': 42,
        'asistencias': 18,
        'robos': 8,
        'tapones': 5,
        'faltas': 20,
      },
      'equipoVisitante': {
        'puntos': partido['resultadoVisitante'],
        'rebotes': 38,
        'asistencias': 15,
        'robos': 6,
        'tapones': 3,
        'faltas': 22,
      },
    };

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradienteAragon,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Marcador principal
                      _buildMarcador(),

                      const SizedBox(height: 24),

                      // Estadísticas del partido
                      _buildEstadisticas(estadisticas),
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

  /// Header
  Widget _buildHeader(BuildContext context) {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detalles del Partido',
                style: TextStyle(
                  color: AppColors.blanco,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Jornada ${partido['jornada']} - ${partido['fecha']}',
                style: TextStyle(
                  color: AppColors.blancoOpacidad70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Marcador principal
  Widget _buildMarcador() {
    bool localGano = partido['resultadoLocal'] > partido['resultadoVisitante'];

    return Container(
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
          // Equipos y marcador
          Row(
            children: [
              // Equipo local
              Expanded(
                child: Column(
                  children: [
                    const Icon(Icons.shield, size: 50, color: AppColors.naranja),
                    const SizedBox(height: 8),
                    Text(
                      partido['equipoLocal'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (localGano) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'GANADOR',
                          style: TextStyle(
                            color: AppColors.blanco,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Marcador
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  gradient: AppColors.gradienteNaranjaAmarillo,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      '${partido['resultadoLocal']} - ${partido['resultadoVisitante']}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blanco,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'FINAL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blanco,
                      ),
                    ),
                  ],
                ),
              ),

              // Equipo visitante
              Expanded(
                child: Column(
                  children: [
                    const Icon(Icons.shield, size: 50, color: AppColors.amarilloAragon),
                    const SizedBox(height: 8),
                    Text(
                      partido['equipoVisitante'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!localGano) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'GANADOR',
                          style: TextStyle(
                            color: AppColors.blanco,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Información del partido
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.grisClaro.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      partido['pabellon'],
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      partido['hora'],
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Estadísticas comparativas
  Widget _buildEstadisticas(Map<String, dynamic> estadisticas) {
    final stats = [
      {'nombre': 'Puntos', 'key': 'puntos'},
      {'nombre': 'Rebotes', 'key': 'rebotes'},
      {'nombre': 'Asistencias', 'key': 'asistencias'},
      {'nombre': 'Robos', 'key': 'robos'},
      {'nombre': 'Tapones', 'key': 'tapones'},
      {'nombre': 'Faltas', 'key': 'faltas'},
    ];

    return Container(
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
            'Estadísticas del Partido',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Lista de estadísticas
          ...stats.map((stat) {
            int valorLocal = estadisticas['equipoLocal'][stat['key']];
            int valorVisitante = estadisticas['equipoVisitante'][stat['key']];
            int total = valorLocal + valorVisitante;
            double porcentajeLocal = total > 0 ? valorLocal / total : 0.5;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  // Nombre de la estadística
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$valorLocal',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        stat['nombre']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '$valorVisitante',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Barra de progreso
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: porcentajeLocal,
                      minHeight: 8,
                      backgroundColor: AppColors.amarilloAragon,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.naranja),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}