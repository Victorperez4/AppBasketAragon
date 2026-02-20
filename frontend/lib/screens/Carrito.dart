import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';

class CarritoPage extends StatefulWidget {
  final Map<int, int> carrito;
  final List<Map<String, dynamic>> productos;
  final Function(Map<int, int>) onCarritoActualizado;

  const CarritoPage({
    super.key,
    required this.carrito,
    required this.productos,
    required this.onCarritoActualizado,
  });

  @override
  State<CarritoPage> createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  late Map<int, int> _carritoLocal;

  @override
  void initState() {
    super.initState();
    _carritoLocal = Map.from(widget.carrito);
  }

  @override
  Widget build(BuildContext context) {
    double total = _calcularTotal();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradienteAragon,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Lista de productos o estado vacío
              Expanded(
                child: _carritoLocal.isEmpty
                    ? _buildEstadoVacio()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _carritoLocal.length,
                        itemBuilder: (context, index) {
                          int productId = _carritoLocal.keys.elementAt(index);
                          var producto = widget.productos.firstWhere(
                            (p) => p['id'] == productId,
                          );
                          int cantidad = _carritoLocal[productId]!;

                          return _buildProductoEnCarrito(producto, cantidad);
                        },
                      ),
              ),

              // Footer con total y botón de pago
              if (_carritoLocal.isNotEmpty) _buildFooter(total),
            ],
          ),
        ),
      ),
    );
  }

  /// Header
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
            onPressed: () {
              // Actualizar el carrito en la pantalla padre
              widget.onCarritoActualizado(_carritoLocal);
              Navigator.pop(context);
            },
          ),
          const Text(
            'MI CARRITO',
            style: TextStyle(
              color: AppColors.blanco,
              fontSize: 24,
              fontWeight: FontWeight.bold,
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
          const Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: AppColors.blancoOpacidad70,
          ),
          const SizedBox(height: 16),
          const Text(
            'Tu carrito está vacío',
            style: TextStyle(
              color: AppColors.blanco,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Añade productos desde la tienda',
            style: TextStyle(
              color: AppColors.blancoOpacidad70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.naranja,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            onPressed: () {
              widget.onCarritoActualizado(_carritoLocal);
              Navigator.pop(context);
            },
            child: const Text(
              'Ir a la tienda',
              style: TextStyle(color: AppColors.blanco),
            ),
          ),
        ],
      ),
    );
  }

  /// Card de producto en el carrito
  Widget _buildProductoEnCarrito(Map<String, dynamic> producto, int cantidad) {
    double subtotal = producto['precio'] * cantidad;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
        children: [
          // Imagen del producto (placeholder)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.gradienteNaranjaAmarillo,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.shopping_bag,
              color: AppColors.blanco,
              size: 40,
            ),
          ),

          const SizedBox(width: 12),

          // Info del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto['nombre'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${producto['precio'].toStringAsFixed(2)} € x $cantidad',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Subtotal: ${subtotal.toStringAsFixed(2)} €',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.naranja,
                  ),
                ),
              ],
            ),
          ),

          // Controles de cantidad
          Column(
            children: [
              // Botón eliminar
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                iconSize: 20,
                onPressed: () {
                  setState(() {
                    _carritoLocal.remove(producto['id']);
                  });
                },
              ),

              // Contador
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grisClaro,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          if (cantidad > 1) {
                            _carritoLocal[producto['id']] = cantidad - 1;
                          }
                        });
                      },
                    ),
                    Text(
                      '$cantidad',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          _carritoLocal[producto['id']] = cantidad + 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Footer con total y botón de pago
  Widget _buildFooter(double total) {
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
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${total.toStringAsFixed(2)} €',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.naranja,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Botón de pago
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.naranja,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // TODO: Navegar a pantalla de pago
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Procesando pago... (función pendiente)'),
                  ),
                );
              },
              child: const Text(
                'PROCEDER AL PAGO',
                style: TextStyle(
                  color: AppColors.blanco,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Calcular total del carrito
  double _calcularTotal() {
    double total = 0;
    _carritoLocal.forEach((productId, cantidad) {
      var producto = widget.productos.firstWhere((p) => p['id'] == productId);
      total += producto['precio'] * cantidad;
    });
    return total;
  }
}