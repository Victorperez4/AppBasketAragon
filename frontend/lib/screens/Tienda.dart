import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'package:tfg_appfede/widgets/Header.dart';
import 'package:tfg_appfede/widgets/MenuLateral.dart';
import 'package:tfg_appfede/widgets/BarraInferior.dart';

class TiendaPage extends StatefulWidget {
  const TiendaPage({super.key});

  @override
  State<TiendaPage> createState() => _TiendaPageState();
}

class _TiendaPageState extends State<TiendaPage> {
  final List<String> _categorias = [
    'Todo',
    'Camisetas',
    'Balones',
    'Accesorios',
    'Equipamiento',
  ];

  String _categoriaSeleccionada = 'Todo';

  final List<Map<String, dynamic>> _productos = [];
  final Map<int, int> _carrito = {};

  @override
  Widget build(BuildContext context) {
    int cantidadTotal = _carrito.values.fold(0, (sum, cantidad) => sum + cantidad);

    return Scaffold(
      drawer: const MenuLateral(),

      appBar: const HeaderApp(titulo: "Tienda"),

      bottomNavigationBar: const BarraInferior(selectedIndex: 1),

      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradienteAragon,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Carrito arriba a la derecha
              _buildCarritoIcon(cantidadTotal),

              // Filtro por categorías
              _buildCategorias(),

              // Contenido
              Expanded(
                child: _productos.isEmpty
                    ? _buildEstadoVacio()
                    : _buildListaProductos(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Icono de carrito (separado del header original)
  Widget _buildCarritoIcon(int cantidadTotal) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 16, top: 8),
      child: Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: AppColors.blanco),
            iconSize: 28,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Carrito vacío'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          if (cantidadTotal > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.rojoAragon,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Text(
                  '$cantidadTotal',
                  style: const TextStyle(
                    color: AppColors.blanco,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Filtro de categorías
  Widget _buildCategorias() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categorias.length,
        itemBuilder: (context, index) {
          final categoria = _categorias[index];
          final isSelected = categoria == _categoriaSeleccionada;

          return GestureDetector(
            onTap: () {
              setState(() {
                _categoriaSeleccionada = categoria;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.gradienteNaranjaAmarillo : null,
                color: isSelected ? null : AppColors.blanco.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColors.blanco.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                categoria,
                style: TextStyle(
                  color: AppColors.blanco,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Lista de productos
  Widget _buildListaProductos() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _productos.length,
      itemBuilder: (context, index) {
        final producto = _productos[index];
        return _buildProductoCard(producto);
      },
    );
  }

  /// Card de producto
  Widget _buildProductoCard(Map<String, dynamic> producto) {
    return Container(
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
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.gradienteNaranjaAmarillo,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.shopping_bag,
                  size: 60,
                  color: AppColors.blanco,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto['nombre'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${producto['precio']} €',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.naranja,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Estado vacío
  Widget _buildEstadoVacio() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                gradient: AppColors.gradienteNaranjaAmarillo,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.naranja.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 80,
                color: AppColors.blanco,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Tienda Oficial FAB',
              style: TextStyle(
                color: AppColors.blanco,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Text(
              'Próximamente podrás adquirir productos oficiales de la Federación Aragonesa de Baloncesto',
              style: TextStyle(
                color: AppColors.blancoOpacidad70,
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            _buildCaracteristica(
              icon: Icons.checkroom,
              titulo: 'Equipamiento Oficial',
              descripcion: 'Camisetas, pantalones y más',
            ),

            const SizedBox(height: 16),

            _buildCaracteristica(
              icon: Icons.sports_basketball,
              titulo: 'Balones y Accesorios',
              descripcion: 'Material deportivo de calidad',
            ),

            const SizedBox(height: 16),

            _buildCaracteristica(
              icon: Icons.local_shipping,
              titulo: 'Envío a Domicilio',
              descripcion: 'Recibe tus productos donde quieras',
            ),

            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.blanco.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.blanco.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.notifications_active,
                    color: AppColors.amarilloAragon,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '¿Quieres que te avisemos?',
                    style: TextStyle(
                      color: AppColors.blanco,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Te notificaremos cuando la tienda esté disponible',
                    style: TextStyle(
                      color: AppColors.blancoOpacidad70,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.naranja,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('¡Te avisaremos cuando esté lista!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text(
                      'Notifícame',
                      style: TextStyle(
                        color: AppColors.blanco,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaracteristica({
    required IconData icon,
    required String titulo,
    required String descripcion,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blanco.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.blanco.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppColors.gradienteNaranjaAmarillo,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.blanco,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: AppColors.blanco,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  descripcion,
                  style: TextStyle(
                    color: AppColors.blancoOpacidad70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
