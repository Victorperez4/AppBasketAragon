import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'package:tfg_appfede/services/autenticacion_service.dart';
import 'package:tfg_appfede/widgets/Header.dart';
import 'package:tfg_appfede/widgets/MenuLateral.dart';

class DesignacionesPage extends StatefulWidget {
  const DesignacionesPage({super.key});

  @override
  State<DesignacionesPage> createState() => _DesignacionesPageState();
}

class _DesignacionesPageState extends State<DesignacionesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuLateral(),
      appBar: const HeaderApp(titulo: "Mis Designaciones"),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradienteAragon,
        ),
        child: SafeArea(
          child: FutureBuilder<Usuario?>(
            future: AutenticacionService.obtenerUsuarioActual(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.amarilloAragon),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return _buildSinSesion();
              }

              Usuario usuario = snapshot.data!;

              // Verificar si el usuario es árbitro
              final rolNormalizado = usuario.rol.toLowerCase();
              if (rolNormalizado != 'arbitro' && rolNormalizado != 'árbitro') {
                return _buildNoValido();
              }

              return _buildDesignaciones(usuario);
            },
          ),
        ),
      ),
    );
  }

  /// Pantalla cuando no hay sesión iniciada
  Widget _buildSinSesion() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.gavel,
            size: 80,
            color: AppColors.blancoOpacidad70,
          ),
          const SizedBox(height: 20),
          const Text(
            'No hay sesión iniciada',
            style: TextStyle(
              color: AppColors.blanco,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Por favor inicia sesión para ver tus designaciones',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blancoOpacidad70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Pantalla cuando el usuario no es árbitro
  Widget _buildNoValido() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.block,
            size: 80,
            color: AppColors.blancoOpacidad70,
          ),
          const SizedBox(height: 20),
          const Text(
            'Acceso Denegado',
            style: TextStyle(
              color: AppColors.blanco,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Solo los árbitros pueden ver sus designaciones',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blancoOpacidad70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Pantalla principal de designaciones
  Widget _buildDesignaciones(Usuario usuario) {
    // Datos de ejemplo - TODO: Cargar desde base de datos
    final designaciones = {
      'Jornada 1': [
        {
          'equipoLocal': 'Basket Zaragoza',
          'equipoVisitante': 'Real Zaragoza BM',
          'fecha': '15/03/2026',
          'hora': '19:00',
          'pabellon': 'Pabellón Príncipe Felipe',
        },
        {
          'equipoLocal': 'Helios Playas',
          'equipoVisitante': 'Tecnyconta Zaragoza',
          'fecha': '15/03/2026',
          'hora': '21:00',
          'pabellon': 'Pabellón Príncipe Felipe',
        },
      ],
      'Jornada 2': [
        {
          'equipoLocal': 'Casademont Zaragoza',
          'equipoVisitante': 'Bilbao Basket',
          'fecha': '22/03/2026',
          'hora': '19:30',
          'pabellon': 'Pabellón Príncipe Felipe',
        },
      ],
      'Jornada 3': [
        {
          'equipoLocal': 'Basket Zaragoza',
          'equipoVisitante': 'Monbus Obradoiro',
          'fecha': '29/03/2026',
          'hora': '20:00',
          'pabellon': 'Pabellón Jorge Garbajosa',
        },
        {
          'equipoLocal': 'Real Zaragoza BM',
          'equipoVisitante': 'Básquet Girona',
          'fecha': '29/03/2026',
          'hora': '21:30',
          'pabellon': 'Pabellón Príncipe Felipe',
        },
        {
          'equipoLocal': 'Helios Playas',
          'equipoVisitante': 'Coruña Basket',
          'fecha': '30/03/2026',
          'hora': '18:00',
          'pabellon': 'Pabellón Príncipe Felipe',
        },
      ],
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta informativa del árbitro (CENTRADA)
          _buildTarjetaArbitro(usuario),
          const SizedBox(height: 24),

          // Resumen
          _buildResumen(designaciones),
          const SizedBox(height: 24),

          // Designaciones por jornada
          if (designaciones.isEmpty)
            _buildSinDesignaciones()
          else
            ...designaciones.entries.map((entry) {
              return Column(
                children: [
                  _buildHeaderJornada(entry.key),
                  const SizedBox(height: 12),
                  ...entry.value.asMap().entries.map((item) {
                    return Column(
                      children: [
                        _buildPartidoCard(item.value),
                        if (item.key < entry.value.length - 1)
                          const SizedBox(height: 12),
                      ],
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              );
            }),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Tarjeta informativa del árbitro (CENTRADA)
  Widget _buildTarjetaArbitro(Usuario usuario) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.gradienteNaranjaAmarillo,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // CENTRADO
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.blanco.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.gavel,
                size: 48,
                color: AppColors.blanco,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${usuario.nombre} ${usuario.apellidos}',
            textAlign: TextAlign.center, // CENTRADO
            style: const TextStyle(
              color: AppColors.blanco,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Árbitro',
            textAlign: TextAlign.center, // CENTRADO
            style: TextStyle(
              color: AppColors.blanco.withOpacity(0.9),
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /// Resumen de designaciones
  Widget _buildResumen(Map<String, List<Map<String, dynamic>>> designaciones) {
    int totalPartidos = 0;
    for (var jornada in designaciones.values) {
      totalPartidos += jornada.length;
    }

    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEstadisticaMini(
            'Jornadas',
            designaciones.length.toString(),
            Icons.event,
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey[300],
          ),
          _buildEstadisticaMini(
            'Partidos',
            totalPartidos.toString(),
            Icons.sports_basketball,
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey[300],
          ),
          _buildEstadisticaMini(
            'Próximos',
            totalPartidos.toString(),
            Icons.schedule,
          ),
        ],
      ),
    );
  }

  /// Estadística mini
  Widget _buildEstadisticaMini(String label, String valor, IconData icono) {
    return Expanded(
      child: Column(
        children: [
          Icon(icono, color: AppColors.naranja, size: 24),
          const SizedBox(height: 8),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.negro,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// Header de jornada
  Widget _buildHeaderJornada(String jornada) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: AppColors.gradienteNaranjaAmarillo,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.event_note,
            color: AppColors.blanco,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          jornada,
          style: const TextStyle(
            color: AppColors.blanco,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Tarjeta de partido
  Widget _buildPartidoCard(Map<String, dynamic> partido) {
    return Container(
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
          // Equipos
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Local',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      partido['equipoLocal'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.negro,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppColors.gradienteNaranjaAmarillo,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.gavel,
                  color: AppColors.blanco,
                  size: 18,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Visitante',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      partido['equipoVisitante'],
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.negro,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Separador
          Divider(color: Colors.grey[300]),

          const SizedBox(height: 12),

          // Información adicional
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  Icons.calendar_today,
                  'Fecha',
                  partido['fecha'],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoItem(
                  Icons.access_time,
                  'Hora',
                  partido['hora'],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Pabellón
          _buildInfoItem(
            Icons.location_on,
            'Pabellón',
            partido['pabellon'],
          ),
        ],
      ),
    );
  }

  /// Widget auxiliar para items de información
  Widget _buildInfoItem(IconData icono, String label, String valor) {
    return Row(
      children: [
        Icon(icono, size: 16, color: AppColors.naranja),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.negro,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Sin designaciones
  Widget _buildSinDesignaciones() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule,
            size: 64,
            color: AppColors.blancoOpacidad70,
          ),
          const SizedBox(height: 16),
          const Text(
            'Sin designaciones',
            style: TextStyle(
              color: AppColors.blanco,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No tienes partidos designados en este momento',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.blancoOpacidad70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}