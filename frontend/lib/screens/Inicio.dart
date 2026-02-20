import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'package:tfg_appfede/widgets/BarraInferior.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  // Datos de ejemplo para la clasificación (luego vendrán de la BD)
  final List<Map<String, dynamic>> _clasificacion = [
    {'posicion': 1, 'equipo': 'Baloncesto Tarazona', 'puntos': 38},
    {'posicion': 2, 'equipo': 'Kai Zaragoza', 'puntos': 36},
    {'posicion': 3, 'equipo': 'Oliver Basket', 'puntos': 34},
  ];
  
  // Datos de ejemplo para noticias
  final List<Map<String, String>> _noticias = [
    {
      'titulo': 'El Tarazona remonta un emocionante derbi',
      'imagen': 'assets/images/noticia_placeholder.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo con gradiente de Aragón
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradienteAragon,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header con saludo y perfil
              _buildHeader(),
              
              // Contenido principal con scroll
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Barra de búsqueda
                      _buildSearchBar(),
                      
                      const SizedBox(height: 20),
                      
                      // Sección de clasificación
                      _buildClasificacionSection(),
                      
                      const SizedBox(height: 24),
                      
                      // Sección de noticias
                      _buildNoticiasSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Menú de navegación inferior (widget reutilizable)
      bottomNavigationBar: const BarraInferior(selectedIndex: 1),
    );
  }

  /// Header con saludo personalizado y botón de perfil
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Bienvenido, Imanol',
            style: TextStyle(
              color: AppColors.blanco,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Botón de perfil
          IconButton(
            icon: const Icon(Icons.account_circle, color: AppColors.blanco),
            iconSize: 32,
            onPressed: () {
              // TODO: Navegar a pantalla de perfil
            },
          ),
        ],
      ),
    );
  }

  /// Barra de búsqueda
  Widget _buildSearchBar() {
    return TextField(
      style: const TextStyle(color: AppColors.blanco),
      decoration: InputDecoration(
        hintText: 'Buscar...',
        hintStyle: TextStyle(color: AppColors.blancoOpacidad70),
        prefixIcon: const Icon(Icons.search, color: AppColors.grisClaro),
        filled: true,
        fillColor: AppColors.negroOpacidad50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// Sección de clasificación
  Widget _buildClasificacionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Clasificación',
          style: TextStyle(
            color: AppColors.blanco,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Lista de equipos clasificados
        Container(
          decoration: BoxDecoration(
            color: AppColors.blanco,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clasificacion.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final equipo = _clasificacion[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.naranja,
                  child: Text(
                    '${equipo['posicion']}º',
                    style: const TextStyle(
                      color: AppColors.blanco,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  equipo['equipo'],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Text(
                  '${equipo['puntos']} pts',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Sección de noticias
  Widget _buildNoticiasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Noticias',
          style: TextStyle(
            color: AppColors.blanco,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Cards de noticias
        ..._noticias.map((noticia) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.blanco,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen de la noticia (placeholder)
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.grisClaro,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: 64,
                    color: AppColors.blancoOpacidad54,
                  ),
                ),
              ),
              
              // Título de la noticia
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  noticia['titulo']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}