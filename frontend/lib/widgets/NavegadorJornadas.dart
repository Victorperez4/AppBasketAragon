import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';

/// Widget reutilizable para la navegación de jornadas
/// Muestra controles para cambiar entre jornadas con indicador visual
class NavegadorJornadas extends StatelessWidget {
  final int jornadaActual;
  final int totalJornadas;
  final Function(int) onJornadaChanged;

  const NavegadorJornadas({
    super.key,
    required this.jornadaActual,
    required this.totalJornadas,
    required this.onJornadaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Navegación de jornadas
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botón anterior
              IconButton(
                icon: const Icon(Icons.chevron_left, color: AppColors.blanco, size: 32),
                onPressed: jornadaActual > 1
                    ? () {
                        onJornadaChanged(jornadaActual - 1);
                      }
                    : null,
              ),

              const SizedBox(width: 16),

              // Indicador de jornada
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: AppColors.gradienteNaranjaAmarillo,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.naranja.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'JORNADA',
                      style: TextStyle(
                        color: AppColors.blanco,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$jornadaActual',
                      style: const TextStyle(
                        color: AppColors.blanco,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Botón siguiente
              IconButton(
                icon: const Icon(Icons.chevron_right, color: AppColors.blanco, size: 32),
                onPressed: jornadaActual < totalJornadas
                    ? () {
                        onJornadaChanged(jornadaActual + 1);
                      }
                    : null,
              ),
            ],
          ),

          // Indicador de jornadas totales
          const SizedBox(height: 8),
          Text(
            'de $totalJornadas jornadas',
            style: TextStyle(
              color: AppColors.blancoOpacidad70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
