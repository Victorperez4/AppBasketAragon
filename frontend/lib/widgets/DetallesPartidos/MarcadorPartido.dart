import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';

/// Widget que muestra el marcador principal del partido
/// con equipos, resultado y ganador
class MarcadorPartido extends StatelessWidget {
  final Map<String, dynamic> partido;

  const MarcadorPartido({
    super.key,
    required this.partido,
  });

  @override
  Widget build(BuildContext context) {
    final bool localGano = partido['resultadoLocal'] > partido['resultadoVisitante'];

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
          Row(
            children: [
              _EquipoWidget(
                nombre: partido['equipoLocal'],
                color: AppColors.naranja,
                esGanador: localGano,
              ),
              _ResultadoWidget(
                local: partido['resultadoLocal'],
                visitante: partido['resultadoVisitante'],
              ),
              _EquipoWidget(
                nombre: partido['equipoVisitante'],
                color: AppColors.amarilloAragon,
                esGanador: !localGano,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoPartidoWidget(
            pabellon: partido['pabellon'],
            hora: partido['hora'],
          ),
        ],
      ),
    );
  }
}

/// Widget de equipo (escudo, nombre, badge ganador)
class _EquipoWidget extends StatelessWidget {
  final String nombre;
  final Color color;
  final bool esGanador;

  const _EquipoWidget({
    required this.nombre,
    required this.color,
    required this.esGanador,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(Icons.shield, size: 50, color: color),
          const SizedBox(height: 8),
          Text(
            nombre,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (esGanador) ...[
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
    );
  }
}

/// Widget del resultado central
class _ResultadoWidget extends StatelessWidget {
  final int local;
  final int visitante;

  const _ResultadoWidget({
    required this.local,
    required this.visitante,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: AppColors.gradienteNaranjaAmarillo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            '$local - $visitante',
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
    );
  }
}

/// Widget de información del partido (pabellón y hora)
class _InfoPartidoWidget extends StatelessWidget {
  final String pabellon;
  final String hora;

  const _InfoPartidoWidget({
    required this.pabellon,
    required this.hora,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                pabellon,
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
                hora,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}