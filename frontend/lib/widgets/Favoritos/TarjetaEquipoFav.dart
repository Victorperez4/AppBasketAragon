import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';

class TarjetaEquipo extends StatelessWidget {
  final String nombre;
  final String posicion;
  final String proximoPartido;
  final String rival;
  final bool esLocal;
  final VoidCallback onTap;

  const TarjetaEquipo({
    super.key,
    required this.nombre,
    required this.posicion,
    required this.proximoPartido,
    required this.rival,
    required this.esLocal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            nombre,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                            posicion,
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
                    if (proximoPartido != 'Descanso')
                      Text(
                        'Próximo partido: $proximoPartido',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    if (rival.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            esLocal ? Icons.home : Icons.flight_takeoff,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rival,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    if (proximoPartido == 'Descanso')
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
}
