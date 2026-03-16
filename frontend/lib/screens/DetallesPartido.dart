import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tfg_appfede/widgets/DetallesPartidos/EstadisticasPartido.dart';
import 'package:tfg_appfede/widgets/DetallesPartidos/MarcadorPartido.dart';
import 'package:url_launcher/url_launcher.dart';

class DetallePartidoPage extends StatefulWidget {
  final Map<String, dynamic> partido;
  final String? userRole;

  const DetallePartidoPage({
    super.key,
    required this.partido,
    this.userRole,
  });

  @override
  State<DetallePartidoPage> createState() => _DetallePartidoPageState();
}

class _DetallePartidoPageState extends State<DetallePartidoPage> {
  // Estadísticas del partido
  late Map<String, dynamic> _estadisticas;
  
  // Acta del partido
  Map<String, dynamic>? _actaPartido;
  bool _subiendoActa = false;

  @override
  void initState() {
    super.initState();
    _cargarEstadisticas();
    _cargarActa();
  }

  void _cargarEstadisticas() {
    // TODO: Cargar desde BD
    _estadisticas = {
      'equipoLocal': {
        'puntos': widget.partido['resultadoLocal'],
        'rebotes': 42,
        'asistencias': 18,
        'robos': 8,
        'tapones': 5,
        'faltas': 20,
      },
      'equipoVisitante': {
        'puntos': widget.partido['resultadoVisitante'],
        'rebotes': 38,
        'asistencias': 15,
        'robos': 6,
        'tapones': 3,
        'faltas': 22,
      },
    };
  }

  void _cargarActa() {
    // TODO: Cargar desde BD según widget.partido['id']
    setState(() {
      _actaPartido = {
        'url': 'https://ejemplo.com/acta.pdf',
        'nombreArchivo': 'Acta_Jornada_${widget.partido['jornada']}.pdf',
        'fechaSubida': '08/03/2026 20:30',
        'arbitro': 'Pedro Martínez',
      };
      // Descomentar para simular sin acta:
      // _actaPartido = null;
    });
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
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Widget separado - Marcador
                      MarcadorPartido(partido: widget.partido),
                      
                      const SizedBox(height: 24),
                      
                      // Widget separado - Estadísticas
                      EstadisticasPartido(estadisticas: _estadisticas),
                      
                      const SizedBox(height: 24),
                      
                      // Acta del partido
                      _buildActaPartido(),
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

  Widget _buildHeader(BuildContext context) {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detalles del Partido',
                style: TextStyle(
                  color: AppColors.blanco,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Jornada ${widget.partido['jornada']} - ${widget.partido['fecha']}',
                style: TextStyle(
                  color: AppColors.blancoOpacidad70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Acta del Partido - Simplificada
  /// Solo 2 acciones: SUBIR (árbitros) y VER (todos)
  Widget _buildActaPartido() {
    final rolNormalizado = (widget.userRole ?? '').toLowerCase();
    final bool esArbitro = rolNormalizado == 'arbitro' || rolNormalizado == 'árbitro';

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
          // Título
          const Row(
            children: [
              Icon(Icons.description, color: AppColors.naranja, size: 24),
              SizedBox(width: 12),
              Text(
                'Acta del Partido',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Caso 1: HAY ACTA → Todos pueden verla
          if (_actaPartido != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Acta disponible',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      // Icono de borrar (solo árbitros)
                      if (esArbitro)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Borrar acta',
                          onPressed: _confirmarBorrarActa,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.insert_drive_file, _actaPartido!['nombreArchivo']),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.person, 'Árbitro: ${_actaPartido!['arbitro']}'),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.access_time, 'Subida: ${_actaPartido!['fechaSubida']}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Botón VER PDF (para todos)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.naranja,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _verActa,
                icon: const Icon(Icons.picture_as_pdf, color: AppColors.blanco),
                label: const Text(
                  'Ver Acta (PDF)',
                  style: TextStyle(
                    color: AppColors.blanco,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]
          // Caso 2: NO HAY ACTA
          else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.pending, color: Colors.orange.shade700, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          esArbitro ? 'Acta pendiente de subir' : 'Acta no disponible',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          esArbitro
                              ? 'Sube el acta del partido en PDF'
                              : 'El árbitro aún no ha subido el acta',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Botón SUBIR (solo para árbitros)
            if (esArbitro) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.naranja,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _subiendoActa ? null : _subirActa,
                  icon: _subiendoActa
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.blanco),
                          ),
                        )
                      : const Icon(Icons.upload_file, color: AppColors.blanco),
                  label: Text(
                    _subiendoActa ? 'Subiendo...' : 'Subir Acta (PDF)',
                    style: const TextStyle(
                      color: AppColors.blanco,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  // ==================== LÓGICA DEL ACTA ====================

  /// Ver acta (todos los usuarios)
  void _verActa() async {
    final url = _actaPartido?['url'];
    if (url == null) {
      _mostrarError('No hay acta disponible');
      return;
    }

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        _mostrarError('No se puede abrir el PDF');
      }
    } catch (e) {
      _mostrarError('Error al abrir el PDF: ${e.toString()}');
    }
  }

  /// Subir acta (solo árbitros)
  void _subirActa() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      dialogTitle: 'Seleccionar Acta del Partido',
    );

    if (result == null) return;

    final fileName = result.files.single.name;
    if (!fileName.endsWith('.pdf')) {
      _mostrarError('Por favor, selecciona un archivo PDF válido');
      return;
    }

    setState(() => _subiendoActa = true);

    try {
      // TODO: Subir archivo a servidor/Firebase Storage
      // 1. Obtener bytes del archivo: result.files.single.bytes
      // 2. Subir a servidor
      // 3. Obtener URL del archivo subido
      // 4. Guardar en BD: partidoId, url, nombreArchivo, arbitroId, fecha
      
      // Simulación de subida
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _subiendoActa = false;
          _actaPartido = {
            'url': 'https://ejemplo.com/$fileName',
            'nombreArchivo': fileName,
            'fechaSubida': DateTime.now().toString().substring(0, 16),
            'arbitro': 'Árbitro Actual', // TODO: Obtener del usuario logueado
          };
        });
        _mostrarExito('¡Acta subida correctamente!');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _subiendoActa = false);
        _mostrarError('Error al subir el acta: ${e.toString()}');
      }
    }
  }

  void _mostrarError(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  void _mostrarExito(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.green),
    );
  }

  /// Confirmar antes de borrar el acta (solo árbitros)
  void _confirmarBorrarActa() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Borrar Acta'),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que quieres borrar el acta del partido?\n\nEsta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              _borrarActa();
            },
            child: const Text(
              'Borrar',
              style: TextStyle(color: AppColors.blanco),
            ),
          ),
        ],
      ),
    );
  }

  /// Borrar acta (solo árbitros)
  void _borrarActa() async {
    try {
      // TODO: Borrar del servidor y de la BD
      // 1. Borrar archivo del servidor/Firebase Storage
      // 2. Eliminar registro de la BD
      
      // Simulación
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          _actaPartido = null;
        });
        _mostrarExito('Acta borrada correctamente');
      }
    } catch (e) {
      _mostrarError('Error al borrar el acta: ${e.toString()}');
    }
  }
}