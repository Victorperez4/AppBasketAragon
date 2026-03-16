import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';

class ConfirmarAlineacionesPage extends StatefulWidget {
  const ConfirmarAlineacionesPage({super.key});

  @override
  State<ConfirmarAlineacionesPage> createState() => _ConfirmarAlineacionesPageState();
}

class _ConfirmarAlineacionesPageState extends State<ConfirmarAlineacionesPage> {
  // Jornada actual
  int _jornadaActual = 15;
  final int _totalJornadas = 22;

  // Partidos asignados al árbitro en esta jornada (vendrán de BD)
  final List<Map<String, dynamic>> _partidosAsignados = [
    {
      'id': 1,
      'equipoLocal': 'Basket Zaragoza',
      'equipoVisitante': 'CD Huesca',
      'fecha': '08/03/2026',
      'hora': '18:00',
      'pabellon': 'Pabellón Príncipe Felipe',
      'categoria': 'Senior A',
      'alineacionesConfirmadas': false,
    },
    {
      'id': 2,
      'equipoLocal': 'Oliver Basket',
      'equipoVisitante': 'Caspe Basket',
      'fecha': '08/03/2026',
      'hora': '20:00',
      'pabellon': 'Pabellón Municipal',
      'categoria': 'Senior A',
      'alineacionesConfirmadas': true,
    },
  ];

  // Alineaciones del partido seleccionado
  Map<String, dynamic>? _alineacionEquipoLocal;
  Map<String, dynamic>? _alineacionEquipoVisitante;

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
              // Header con navegación de jornadas
              _buildHeader(),

              // Lista de partidos asignados
              Expanded(
                child: _buildListaPartidos(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Header con título y navegación de jornadas
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
      child: Column(
        children: [
          // Botón atrás y título
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.blanco),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  'CONFIRMAR ALINEACIONES',
                  style: TextStyle(
                    color: AppColors.blanco,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Navegación de jornadas
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botón anterior
              IconButton(
                icon: const Icon(Icons.chevron_left, color: AppColors.blanco, size: 32),
                onPressed: _jornadaActual > 1
                    ? () {
                        setState(() {
                          _jornadaActual--;
                        });
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
                ),
                child: Column(
                  children: [
                    const Text(
                      'JORNADA',
                      style: TextStyle(
                        color: AppColors.blanco,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$_jornadaActual',
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
                onPressed: _jornadaActual < _totalJornadas
                    ? () {
                        setState(() {
                          _jornadaActual++;
                        });
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Lista de partidos asignados
  Widget _buildListaPartidos() {
    if (_partidosAsignados.isEmpty) {
      return _buildEstadoVacio();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _partidosAsignados.length,
      itemBuilder: (context, index) {
        final partido = _partidosAsignados[index];
        return _buildPartidoCard(partido);
      },
    );
  }

  /// Card de partido asignado
  Widget _buildPartidoCard(Map<String, dynamic> partido) {
    final bool confirmadas = partido['alineacionesConfirmadas'];

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del partido
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: confirmadas
                  ? const LinearGradient(colors: [Colors.green, Colors.teal])
                  : AppColors.gradienteRojoNaranja,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(
                  confirmadas ? Icons.check_circle : Icons.pending,
                  color: AppColors.blanco,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${partido['equipoLocal']} vs ${partido['equipoVisitante']}',
                        style: const TextStyle(
                          color: AppColors.blanco,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${partido['categoria']} • ${partido['fecha']} ${partido['hora']}',
                        style: const TextStyle(
                          color: AppColors.blanco,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: confirmadas ? Colors.white : AppColors.blanco.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    confirmadas ? 'CONFIRMADAS' : 'PENDIENTE',
                    style: TextStyle(
                      color: confirmadas ? Colors.green : AppColors.blanco,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Botón de revisar alineaciones
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: confirmadas ? Colors.grey : AppColors.naranja,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: confirmadas
                    ? null
                    : () {
                        _verAlineaciones(partido);
                      },
                icon: Icon(
                  confirmadas ? Icons.visibility : Icons.edit_note,
                  color: AppColors.blanco,
                ),
                label: Text(
                  confirmadas ? 'Alineaciones Confirmadas' : 'Revisar Alineaciones',
                  style: const TextStyle(
                    color: AppColors.blanco,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Estado vacío
  Widget _buildEstadoVacio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 100,
            color: AppColors.blancoOpacidad70,
          ),
          const SizedBox(height: 16),
          const Text(
            'No tienes partidos asignados',
            style: TextStyle(
              color: AppColors.blanco,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'En esta jornada no tienes partidos para arbitrar',
            style: TextStyle(
              color: AppColors.blancoOpacidad70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Ver alineaciones del partido
  void _verAlineaciones(Map<String, dynamic> partido) {
    // TODO: Cargar alineaciones desde BD
    _cargarAlineaciones(partido['id']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildModalAlineaciones(partido),
    );
  }

  /// Cargar alineaciones desde BD
  void _cargarAlineaciones(int partidoId) {
    // TODO: Implementar carga desde BD
    // Por ahora datos de ejemplo
    setState(() {
      _alineacionEquipoLocal = {
        'equipo': 'Basket Zaragoza',
        'jugadores': [
          {'nombre': 'Pablo Pérez', 'dorsal': 7, 'posicion': 'Escolta'},
          {'nombre': 'Adrián Fernández', 'dorsal': 10, 'posicion': 'Pívot'},
          {'nombre': 'Miguel Torres', 'dorsal': 23, 'posicion': 'Base'},
          {'nombre': 'Carlos López', 'dorsal': 15, 'posicion': 'Alero'},
          {'nombre': 'David Martín', 'dorsal': 5, 'posicion': 'Ala-Pívot'},
        ],
      };

      _alineacionEquipoVisitante = {
        'equipo': 'CD Huesca',
        'jugadores': [
          {'nombre': 'Luis García', 'dorsal': 8, 'posicion': 'Base'},
          {'nombre': 'Javier Ruiz', 'dorsal': 12, 'posicion': 'Escolta'},
          {'nombre': 'Antonio Sanz', 'dorsal': 20, 'posicion': 'Alero'},
          {'nombre': 'Fernando Gil', 'dorsal': 14, 'posicion': 'Ala-Pívot'},
          {'nombre': 'Raúl Jiménez', 'dorsal': 6, 'posicion': 'Pívot'},
        ],
      };
    });
  }

  /// Modal de alineaciones
  Widget _buildModalAlineaciones(Map<String, dynamic> partido) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppColors.blanco,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header del modal
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: AppColors.gradienteAragon,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Alineaciones del Partido',
                      style: TextStyle(
                        color: AppColors.blanco,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.blanco),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${partido['equipoLocal']} vs ${partido['equipoVisitante']}',
                  style: TextStyle(
                    color: AppColors.blancoOpacidad70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Contenido scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Alineación equipo local
                  _buildAlineacionEquipo(_alineacionEquipoLocal, esLocal: true),

                  const SizedBox(height: 20),

                  // VS
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.grisClaro,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'VS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Alineación equipo visitante
                  _buildAlineacionEquipo(_alineacionEquipoVisitante, esLocal: false),
                ],
              ),
            ),
          ),

          // Botón de confirmar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.blanco,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  _confirmarAlineaciones(partido);
                },
                icon: const Icon(Icons.check_circle, color: AppColors.blanco),
                label: const Text(
                  'Confirmar Alineaciones',
                  style: TextStyle(
                    color: AppColors.blanco,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget de alineación de un equipo
  Widget _buildAlineacionEquipo(Map<String, dynamic>? alineacion, {required bool esLocal}) {
    if (alineacion == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: const Center(
          child: Text(
            'Alineación no presentada',
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: esLocal ? AppColors.naranja.withOpacity(0.1) : AppColors.amarilloAragon.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: esLocal ? AppColors.naranja : AppColors.amarilloAragon,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre del equipo
          Row(
            children: [
              Icon(
                Icons.shield,
                color: esLocal ? AppColors.naranja : AppColors.amarilloAragon,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                alineacion['equipo'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Lista de jugadores
          ...List.generate(
            (alineacion['jugadores'] as List).length,
            (index) {
              final jugador = alineacion['jugadores'][index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.blanco,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Número de orden
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: esLocal ? AppColors.naranja : AppColors.amarilloAragon,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: AppColors.blanco,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Dorsal
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.grisClaro,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${jugador['dorsal']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Nombre y posición
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jugador['nombre'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            jugador['posicion'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Total de jugadores
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: esLocal ? AppColors.naranja.withOpacity(0.2) : AppColors.amarilloAragon.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.groups, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${(alineacion['jugadores'] as List).length} jugadores',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Confirmar alineaciones
  void _confirmarAlineaciones(Map<String, dynamic> partido) {
    // Verificar que ambas alineaciones estén presentadas
    if (_alineacionEquipoLocal == null || _alineacionEquipoVisitante == null) {
      Navigator.pop(context); // Cerrar modal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ambos equipos deben presentar sus alineaciones'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Alineaciones'),
        content: const Text(
          '¿Estás seguro de confirmar las alineaciones?\n\nUna vez confirmadas, los entrenadores no podrán modificarlas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              // TODO: Actualizar en BD que las alineaciones están confirmadas
              setState(() {
                partido['alineacionesConfirmadas'] = true;
              });

              Navigator.pop(context); // Cerrar diálogo
              Navigator.pop(context); // Cerrar modal

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Alineaciones confirmadas correctamente!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Confirmar',
              style: TextStyle(color: AppColors.blanco),
            ),
          ),
        ],
      ),
    );
  }
}