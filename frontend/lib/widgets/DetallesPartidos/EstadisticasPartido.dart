import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';

/// Widget que muestra las estadísticas comparativas del partido
class EstadisticasPartido extends StatelessWidget {
  final Map<String, dynamic> estadisticas;

  const EstadisticasPartido({
    super.key,
    required this.estadisticas,
  });

  @override
  Widget build(BuildContext context) {
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
          ...stats.map((stat) => _EstadisticaItem(
                nombre: stat['nombre']!,
                valorLocal: estadisticas['equipoLocal'][stat['key']],
                valorVisitante: estadisticas['equipoVisitante'][stat['key']],
              )),
        ],
      ),
    );
  }
}

/// Item individual de estadística con barra de progreso
class _EstadisticaItem extends StatelessWidget {
  final String nombre;
  final int valorLocal;
  final int valorVisitante;

  const _EstadisticaItem({
    required this.nombre,
    required this.valorLocal,
    required this.valorVisitante,
  });

  @override
  Widget build(BuildContext context) {
    final int total = valorLocal + valorVisitante;
    final double porcentajeLocal = total > 0 ? valorLocal / total : 0.5;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
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
                nombre,
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
  }
}