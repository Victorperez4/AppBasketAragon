import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'package:tfg_appfede/data/gestorFavoritos.dart';
import 'package:tfg_appfede/widgets/BarraInferior.dart';
import 'package:tfg_appfede/widgets/Header.dart';
import 'package:tfg_appfede/widgets/MenuLateral.dart';
import 'Clasificacion.dart';

class LigasPage extends StatefulWidget {
  const LigasPage({super.key});

  @override
  State<LigasPage> createState() => _LigasPageState();
}

class _LigasPageState extends State<LigasPage> {
  final List<String> _categoriasEdad = [
    'Seleccionar categoría...',
    'Prebenjamín',
    'Benjamín',
    'Alevín',
    'Pre-Infantil',
    'Infantil',
    'Cadete',
    'Junior',
    'Senior',
  ];

  final List<String> _categoriasNivel = [
    'Seleccionar nivel...',
    'Categoría A',
    'Categoría B',
    'Categoría C',
  ];

  String _categoriaEdadSeleccionada = 'Seleccionar categoría...';
  String _categoriaNivelSeleccionada = 'Seleccionar nivel...';

  @override
  Widget build(BuildContext context) {
    // De momento, simulamos que cada categoría favorita tiene nombre "Edad Nivel"
    final ligasFavoritas = FavoritosManager()
        .categoriasFavoritas
        .map((nombre) => {
              'nombre': nombre,
              'categoriaEdad': nombre.split(' ').first,
              'categoriaNivel': nombre.split(' ').length > 1
                  ? nombre.split(' ').sublist(1).join(' ')
                  : '',
            })
        .toList();

    return Scaffold(
      drawer: const MenuLateral(),
      appBar: const HeaderApp(titulo: "Ligas"),
      bottomNavigationBar: const BarraInferior(selectedIndex: 0),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradienteAragon,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selecciona una liga',
                        style: TextStyle(
                          color: AppColors.blanco,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildDropdown(
                        label: 'Categoría por edad',
                        value: _categoriaEdadSeleccionada,
                        items: _categoriasEdad,
                        onChanged: (value) {
                          setState(() {
                            _categoriaEdadSeleccionada = value!;
                            _categoriaNivelSeleccionada =
                                'Seleccionar nivel...';
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_categoriaEdadSeleccionada !=
                          'Seleccionar categoría...')
                        _buildDropdown(
                          label: 'Categoría por nivel',
                          value: _categoriaNivelSeleccionada,
                          items: _categoriasNivel,
                          onChanged: (value) {
                            setState(() {
                              _categoriaNivelSeleccionada = value!;
                            });

                            if (value != 'Seleccionar nivel...') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClasificacionPage(
                                    categoriaEdad: _categoriaEdadSeleccionada,
                                    categoriaNivel: _categoriaNivelSeleccionada,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      const SizedBox(height: 30),
                      if (ligasFavoritas.isNotEmpty) ...[
                        Row(
                          children: const [
                            Icon(Icons.star,
                                color: AppColors.amarilloAragon),
                            SizedBox(width: 8),
                            Text(
                              'Mis ligas favoritas',
                              style: TextStyle(
                                color: AppColors.blanco,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...ligasFavoritas
                            .map((liga) => _buildLigaFavoritaCard(liga)),
                      ],
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

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.naranja),
              style: const TextStyle(
                color: AppColors.negro,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLigaFavoritaCard(Map<String, dynamic> liga) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClasificacionPage(
              categoriaEdad: liga['categoriaEdad'],
              categoriaNivel: liga['categoriaNivel'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.gradienteNaranjaAmarillo,
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
          children: [
            const Icon(Icons.emoji_events,
                color: AppColors.blanco, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    liga['nombre'],
                    style: const TextStyle(
                      color: AppColors.blanco,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${liga['categoriaEdad']} - ${liga['categoriaNivel']}',
                    style: const TextStyle(
                      color: AppColors.blanco,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: AppColors.blanco, size: 16),
          ],
        ),
      ),
    );
  }
}
