import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'package:tfg_appfede/data/gestorFavoritos.dart';
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
  
  late final Map<String, dynamic> _equipoInfo;
  late final List<Map<String, dynamic>> _jugadores;

  @override
  void initState() {
    super.initState();
    _esFavorito = FavoritosManager().esEquipoFavorito(widget.nombreEquipo);
    
    // Datos de ejemplo del equipo (luego vendrás de la BD)
    _equipoInfo = {
      'nombre': widget.nombreEquipo,
      'victorias': 18,
      'derrotas': 12,
      'puntosAFavor': 82.5,
      'puntosEnContra': 76.3,
    };
    
    _jugadores = [
      {
        'nombreCompleto': 'Juan González',
        'nombre': 'Juan',
        'posicion': 'Escolta',
        'promedioPuntos': 18.6,
        'promedioRebotes': 6.2,
        'promedioAsistencias': 3.8,
      },
      {
        'nombreCompleto': 'Carlos Rodríguez',
        'nombre': 'Carlos',
        'posicion': 'Base',
        'promedioPuntos': 14.2,
        'promedioRebotes': 4.5,
        'promedioAsistencias': 7.1,
      },
      {
        'nombreCompleto': 'Miguel Fernández',
        'nombre': 'Miguel',
        'posicion': 'Ala-Pívot',
        'promedioPuntos': 12.8,
        'promedioRebotes': 8.3,
        'promedioAsistencias': 2.2,
      },
      {
        'nombreCompleto': 'David López',
        'nombre': 'David',
        'posicion': 'Pívot',
        'promedioPuntos': 10.5,
        'promedioRebotes': 11.2,
        'promedioAsistencias': 1.5,
      },
      {
        'nombreCompleto': 'Roberto Martínez',
        'nombre': 'Roberto',
        'posicion': 'Alero',
        'promedioPuntos': 9.3,
        'promedioRebotes': 5.8,
        'promedioAsistencias': 2.9,
      },
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
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildInfoEquipo(),
                      const SizedBox(height: 16),
                      _buildUltimosResultados(),
                      const SizedBox(height: 16),
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

  /// HEADER
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
              FavoritosManager().toggleEquipoFavorito(widget.nombreEquipo);

              setState(() {
                _esFavorito = FavoritosManager().esEquipoFavorito(widget.nombreEquipo);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _esFavorito
                        ? 'Equipo añadido a favoritos'
                        : 'Equipo eliminado de favoritos',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// INFO DEL EQUIPO
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
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: AppColors.gradienteNaranjaAmarillo,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield, size: 60, color: AppColors.blanco),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('Victorias', '${_equipoInfo['victorias']}', Colors.green),
              _buildStatColumn('Derrotas', '${_equipoInfo['derrotas']}', Colors.red),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('Pts a favor', (_equipoInfo['puntosAFavor'] as double).toStringAsFixed(1), AppColors.naranja),
              _buildStatColumn('Pts en contra', (_equipoInfo['puntosEnContra'] as double).toStringAsFixed(1), Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  /// ÚLTIMOS RESULTADOS (mock)
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
        children: const [
          Text('Últimos Resultados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text("⚠ Próximamente conectado al backend"),
        ],
      ),
    );
  }

  /// PLANTILLA
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
          const Text('Plantilla', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._jugadores.map((j) => _buildJugadorCard(j)),
        ],
      ),
    );
  }

  Widget _buildJugadorCard(Map<String, dynamic> jugador) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JugadorPage(
              nombreJugador: jugador['nombreCompleto'],
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
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppColors.gradienteNaranjaAmarillo,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  (jugador['nombre'] as String)[0],
                  style: const TextStyle(color: AppColors.blanco, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(jugador['nombreCompleto'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildMiniStat('${jugador['promedioPuntos']}', 'Pts'),
                      const SizedBox(width: 12),
                      _buildMiniStat('${jugador['promedioRebotes']}', 'Reb'),
                      const SizedBox(width: 12),
                      _buildMiniStat('${jugador['promedioAsistencias']}', 'Ast'),
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

  Widget _buildMiniStat(String value, String label) {
    return Text(
      '$value $label',
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    );
  }
}
