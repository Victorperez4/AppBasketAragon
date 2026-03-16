import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';

class PresentarAlineacionPage extends StatefulWidget {
  const PresentarAlineacionPage({super.key});

  @override
  State<PresentarAlineacionPage> createState() => _PresentarAlineacionPageState();
}

class _PresentarAlineacionPageState extends State<PresentarAlineacionPage> {
  // Jornada actual y navegación
  int _jornadaActual = 15;
  final int _totalJornadas = 22;

  // Equipos del entrenador (vendrá de BD)
  final List<Map<String, dynamic>> _misEquipos = [
    {
      'id': 1,
      'nombre': 'Basket Zaragoza',
      'categoria': 'Senior A',
    },
    {
      'id': 2,
      'nombre': 'Basket Zaragoza Juvenil',
      'categoria': 'Juvenil A',
    },
  ];

  // Equipo seleccionado
  Map<String, dynamic>? _equipoSeleccionado;

  // Jugadores del equipo (vendrá de BD según el equipo seleccionado)
  final List<Map<String, dynamic>> _jugadoresDisponibles = [
    {'id': 1, 'nombre': 'Pablo Pérez', 'dorsal': 7, 'posicion': 'Escolta'},
    {'id': 2, 'nombre': 'Adrián Fernández', 'dorsal': 10, 'posicion': 'Pívot'},
    {'id': 3, 'nombre': 'Miguel Torres', 'dorsal': 23, 'posicion': 'Base'},
    {'id': 4, 'nombre': 'Carlos López', 'dorsal': 15, 'posicion': 'Alero'},
    {'id': 5, 'nombre': 'David Martín', 'dorsal': 5, 'posicion': 'Ala-Pívot'},
    {'id': 6, 'nombre': 'Javier García', 'dorsal': 8, 'posicion': 'Escolta'},
    {'id': 7, 'nombre': 'Sergio Ruiz', 'dorsal': 11, 'posicion': 'Base'},
    {'id': 8, 'nombre': 'Antonio Sanz', 'dorsal': 20, 'posicion': 'Alero'},
    {'id': 9, 'nombre': 'Luis Navarro', 'dorsal': 12, 'posicion': 'Pívot'},
    {'id': 10, 'nombre': 'Fernando Gil', 'dorsal': 14, 'posicion': 'Ala-Pívot'},
    {'id': 11, 'nombre': 'Raúl Jiménez', 'dorsal': 6, 'posicion': 'Base'},
    {'id': 12, 'nombre': 'Jorge Vega', 'dorsal': 9, 'posicion': 'Escolta'},
    {'id': 13, 'nombre': 'Alberto Mora', 'dorsal': 13, 'posicion': 'Alero'},
    {'id': 14, 'nombre': 'Daniel Castro', 'dorsal': 17, 'posicion': 'Pívot'},
  ];

  // Jugadores seleccionados para la alineación (máximo 12)
  final List<Map<String, dynamic>> _jugadoresSeleccionados = [];

  // Máximo de jugadores permitidos
  final int _maxJugadores = 12;

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

              // Selector de equipo
              if (_misEquipos.isNotEmpty) _buildSelectorEquipo(),

              // Contenido principal
              Expanded(
                child: _equipoSeleccionado == null
                    ? _buildSeleccionarEquipo()
                    : _buildContenidoAlineacion(),
              ),

              // Botón de guardar alineación
              if (_equipoSeleccionado != null && _jugadoresSeleccionados.isNotEmpty)
                _buildBotonGuardar(),
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
                  'PRESENTAR ALINEACIÓN',
                  style: TextStyle(
                    color: AppColors.blanco,
                    fontSize: 20,
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
                          _jugadoresSeleccionados.clear();
                          // TODO: Cargar alineación guardada de esta jornada si existe
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
                          _jugadoresSeleccionados.clear();
                          // TODO: Cargar alineación guardada de esta jornada si existe
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

  /// Selector de equipo
  Widget _buildSelectorEquipo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.blanco,
        borderRadius: BorderRadius.circular(12),
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
            'Selecciona tu equipo',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonHideUnderline(
            child: DropdownButton<Map<String, dynamic>>(
              value: _equipoSeleccionado,
              isExpanded: true,
              hint: const Text('Elige un equipo...'),
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.naranja),
              style: const TextStyle(
                color: AppColors.negro,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              items: _misEquipos.map((equipo) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: equipo,
                  child: Row(
                    children: [
                      const Icon(Icons.shield, color: AppColors.naranja, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              equipo['nombre'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              equipo['categoria'],
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (equipo) {
                setState(() {
                  _equipoSeleccionado = equipo;
                  _jugadoresSeleccionados.clear();
                  // TODO: Cargar jugadores del equipo desde BD
                  // TODO: Cargar alineación guardada si existe para esta jornada
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Mensaje para seleccionar equipo
  Widget _buildSeleccionarEquipo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 100,
            color: AppColors.blancoOpacidad70,
          ),
          const SizedBox(height: 16),
          const Text(
            'Selecciona un equipo',
            style: TextStyle(
              color: AppColors.blanco,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Elige el equipo para presentar la alineación',
            style: TextStyle(
              color: AppColors.blancoOpacidad70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Contenido principal - Jugadores y alineación
  Widget _buildContenidoAlineacion() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Contador de jugadores seleccionados
          _buildContadorJugadores(),

          // Jugadores seleccionados
          if (_jugadoresSeleccionados.isNotEmpty) _buildJugadoresSeleccionados(),

          // Lista de jugadores disponibles
          _buildJugadoresDisponibles(),
        ],
      ),
    );
  }

  /// Contador de jugadores seleccionados
  Widget _buildContadorJugadores() {
    final int seleccionados = _jugadoresSeleccionados.length;
    final bool limiteAlcanzado = seleccionados >= _maxJugadores;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: limiteAlcanzado
            ? const LinearGradient(
                colors: [Colors.red, Colors.orange],
              )
            : AppColors.gradienteNaranjaAmarillo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Jugadores en alineación',
            style: TextStyle(
              color: AppColors.blanco,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.blanco,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$seleccionados / $_maxJugadores',
              style: TextStyle(
                color: limiteAlcanzado ? Colors.red : AppColors.naranja,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Lista de jugadores seleccionados
  Widget _buildJugadoresSeleccionados() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blanco,
        borderRadius: BorderRadius.circular(12),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Alineación Seleccionada',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_jugadoresSeleccionados.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _jugadoresSeleccionados.clear();
                    });
                  },
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Limpiar'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ..._jugadoresSeleccionados.asMap().entries.map((entry) {
            final index = entry.key;
            final jugador = entry.value;
            return _buildJugadorSeleccionadoCard(jugador, index);
          }),
        ],
      ),
    );
  }

  /// Card de jugador seleccionado
  Widget _buildJugadorSeleccionadoCard(Map<String, dynamic> jugador, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: AppColors.gradienteNaranjaAmarillo,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Número de orden
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.blanco,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.naranja,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Dorsal
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.blanco.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${jugador['dorsal']}',
                style: const TextStyle(
                  color: AppColors.blanco,
                  fontSize: 18,
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
                    color: AppColors.blanco,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  jugador['posicion'],
                  style: const TextStyle(
                    color: AppColors.blanco,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Botón quitar
          IconButton(
            icon: const Icon(Icons.remove_circle, color: AppColors.blanco),
            onPressed: () {
              setState(() {
                _jugadoresSeleccionados.remove(jugador);
              });
            },
          ),
        ],
      ),
    );
  }

  /// Lista de jugadores disponibles
  Widget _buildJugadoresDisponibles() {
    // Filtrar jugadores que no están seleccionados
    final jugadoresNoSeleccionados = _jugadoresDisponibles
        .where((j) => !_jugadoresSeleccionados.any((s) => s['id'] == j['id']))
        .toList();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blanco,
        borderRadius: BorderRadius.circular(12),
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
            'Jugadores Disponibles',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (jugadoresNoSeleccionados.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'Todos los jugadores están en la alineación',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...jugadoresNoSeleccionados.map((jugador) {
              return _buildJugadorDisponibleCard(jugador);
            }),
        ],
      ),
    );
  }

  /// Card de jugador disponible
  Widget _buildJugadorDisponibleCard(Map<String, dynamic> jugador) {
    final bool limiteAlcanzado = _jugadoresSeleccionados.length >= _maxJugadores;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grisClaro.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grisClaro),
      ),
      child: Row(
        children: [
          // Dorsal
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.naranja.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${jugador['dorsal']}',
                style: const TextStyle(
                  color: AppColors.naranja,
                  fontSize: 18,
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
                    fontSize: 15,
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

          // Botón añadir
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: limiteAlcanzado ? Colors.grey : AppColors.naranja,
            ),
            onPressed: limiteAlcanzado
                ? null
                : () {
                    setState(() {
                      _jugadoresSeleccionados.add(jugador);
                    });
                  },
          ),
        ],
      ),
    );
  }

  /// Botón de guardar alineación
  Widget _buildBotonGuardar() {
    return Container(
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
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.naranja,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                _guardarAlineacion();
              },
              icon: const Icon(Icons.save, color: AppColors.blanco),
              label: Text(
                'Guardar Alineación (${_jugadoresSeleccionados.length} jugadores)',
                style: const TextStyle(
                  color: AppColors.blanco,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Jornada $_jornadaActual - ${_equipoSeleccionado!['nombre']}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// Guardar alineación
  void _guardarAlineacion() {
    if (_jugadoresSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona al menos un jugador'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Guardar en la base de datos
    // Datos a guardar:
    // - equipoId: _equipoSeleccionado['id']
    // - jornada: _jornadaActual
    // - jugadores: _jugadoresSeleccionados (lista de IDs)

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alineación Guardada'),
        content: Text(
          'Se ha guardado la alineación de ${_equipoSeleccionado!['nombre']} para la jornada $_jornadaActual con ${_jugadoresSeleccionados.length} jugadores.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pop(context); // Volver atrás
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}