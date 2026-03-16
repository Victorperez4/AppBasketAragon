import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'package:tfg_appfede/screens/DetallesPartido.dart';
import 'package:tfg_appfede/screens/Equipos.dart';
import 'package:tfg_appfede/services/autenticacion_service.dart';

/// Widget reutilizable para mostrar la tarjeta de un partido
/// Muestra información del partido con equipos, resultado y detalles
class TarjetaPartido extends StatefulWidget {
  final Map<String, dynamic> partido;

  const TarjetaPartido({
    super.key,
    required this.partido,
  });

  @override
  State<TarjetaPartido> createState() => _TarjetaPartidoState();
}

class _TarjetaPartidoState extends State<TarjetaPartido> {
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _cargarRolUsuario();
  }

  void _cargarRolUsuario() async {
    final usuario = await AutenticacionService.obtenerUsuarioActual();
    setState(() {
      _userRole = usuario?.rol;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool esPendiente = widget.partido['pendiente'] ?? false;

    return GestureDetector(
      onTap: esPendiente
          ? null
          : () {
              // Navegar a detalles del partido
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetallePartidoPage(
                    partido: widget.partido,
                    userRole: _userRole,
                  ),
                ),
              );
            },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: esPendiente ? AppColors.grisClaro.withOpacity(0.3) : AppColors.grisClaro.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: esPendiente ? Colors.grey.shade300 : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            // Fecha y hora
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${widget.partido['fecha']} - ${widget.partido['hora']}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Equipos y resultado
            Row(
              children: [
                // Equipo local
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EquipoPage(
                            nombreEquipo: widget.partido['equipoLocal'],
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        const Icon(Icons.shield, size: 32, color: AppColors.naranja),
                        const SizedBox(height: 6),
                        Text(
                          widget.partido['equipoLocal'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Resultado o VS
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: esPendiente ? null : AppColors.gradienteNaranjaAmarillo,
                    color: esPendiente ? Colors.grey.shade400 : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: esPendiente
                      ? const Text(
                          'VS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blanco,
                          ),
                        )
                      : Row(
                          children: [
                            Text(
                              '${widget.partido['resultadoLocal']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blanco,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '-',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.blanco,
                                ),
                              ),
                            ),
                            Text(
                              '${widget.partido['resultadoVisitante']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blanco,
                              ),
                            ),
                          ],
                        ),
                ),

                const SizedBox(width: 12),

                // Equipo visitante
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EquipoPage(
                            nombreEquipo: widget.partido['equipoVisitante'],
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        const Icon(Icons.shield, size: 32, color: AppColors.amarilloAragon),
                        const SizedBox(height: 6),
                        Text(
                          widget.partido['equipoVisitante'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Pabellón
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    widget.partido['pabellon'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Indicador de pendiente
            if (esPendiente) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'POR JUGAR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
