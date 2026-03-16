import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'package:tfg_appfede/data/gestorFavoritos.dart';

class JugadorPage extends StatefulWidget {
  final String nombreJugador;
  final String nombreEquipo;

  const JugadorPage({
    super.key,
    required this.nombreJugador,
    required this.nombreEquipo,
  });

  @override
  State<JugadorPage> createState() => _JugadorPageState();
}

class _JugadorPageState extends State<JugadorPage> {
  bool _esFavorito = false;

  late final Map<String, dynamic> _jugadorInfo;
  late final List<Map<String, dynamic>> _estadisticasPartidos;

  @override
  void initState() {
    super.initState();

    _esFavorito = FavoritosManager().esJugadorFavorito(widget.nombreJugador);

    _jugadorInfo = {
      'nombre': widget.nombreJugador,
      'equipo': widget.nombreEquipo,
      'dorsal': 7,
      'posicion': 'Escolta',
      'altura': '1.92 m',
      'peso': '85 kg',
      'promedios': {
        'puntos': 18.6,
        'rebotes': 6.2,
        'asistencias': 3.8,
        'robos': 1.5,
        'tapones': 0.8,
      },
    };

    _estadisticasPartidos = [
      {
        'rival': 'vs CD Huesca',
        'fecha': '08/02/2026',
        'puntos': 22,
        'rebotes': 7,
        'asistencias': 5,
        'minutos': 32,
      },
      {
        'rival': 'vs Oliver Basket',
        'fecha': '01/02/2026',
        'puntos': 18,
        'rebotes': 6,
        'asistencias': 4,
        'minutos': 28,
      },
      {
        'rival': 'vs Caspe Basket',
        'fecha': '25/01/2026',
        'puntos': 15,
        'rebotes': 5,
        'asistencias': 2,
        'minutos': 30,
      },
      {
        'rival': 'vs Barbastro BC',
        'fecha': '18/01/2026',
        'puntos': 24,
        'rebotes': 8,
        'asistencias': 6,
        'minutos': 35,
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
                      _buildInfoJugador(),
                      const SizedBox(height: 16),
                      _buildPromedios(),
                      const SizedBox(height: 16),
                      _buildEstadisticasPartidos(),
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

  /// Header con favorito
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.nombreJugador,
                  style: const TextStyle(
                    color: AppColors.blanco,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.nombreEquipo,
                  style: TextStyle(
                    color: AppColors.blancoOpacidad70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _esFavorito ? Icons.star : Icons.star_border,
              color: _esFavorito ? AppColors.amarilloAragon : AppColors.blanco,
              size: 28,
            ),
            onPressed: () {
              FavoritosManager().toggleJugadorFavorito(widget.nombreJugador);

              setState(() {
                _esFavorito =
                    FavoritosManager().esJugadorFavorito(widget.nombreJugador);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_esFavorito
                      ? 'Jugador añadido a favoritos'
                      : 'Jugador eliminado de favoritos'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Información del jugador
  Widget _buildInfoJugador() {
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
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: AppColors.gradienteNaranjaAmarillo,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${_jugadorInfo['dorsal']}',
                style: const TextStyle(
                  color: AppColors.blanco,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoRow('Posición', _jugadorInfo['posicion']),
          _buildInfoRow('Altura', _jugadorInfo['altura']),
          _buildInfoRow('Peso', _jugadorInfo['peso']),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Promedios del jugador
  Widget _buildPromedios() {
    final promedios = _jugadorInfo['promedios'] as Map<String, dynamic>;

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
          const Text(
            'Promedios por Partido',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPromedioCard(
                  'Puntos',
                  promedios['puntos'].toString(),
                  AppColors.naranja,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPromedioCard(
                  'Rebotes',
                  promedios['rebotes'].toString(),
                  AppColors.amarilloAragon,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPromedioCard(
                  'Asistencias',
                  promedios['asistencias'].toString(),
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPromedioCard(
                  'Robos',
                  promedios['robos'].toString(),
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromedioCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// Estadísticas por partido
  Widget _buildEstadisticasPartidos() {
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
          const Text(
            'Últimos Partidos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ..._estadisticasPartidos.map((partido) => _buildPartidoCard(partido)),
        ],
      ),
    );
  }

  Widget _buildPartidoCard(Map<String, dynamic> partido) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grisClaro.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                partido['rival'],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                partido['fecha'],
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatChip('${partido['puntos']} Pts'),
              _buildStatChip('${partido['rebotes']} Reb'),
              _buildStatChip('${partido['asistencias']} Ast'),
              _buildStatChip('${partido['minutos']} Min'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.blanco,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
