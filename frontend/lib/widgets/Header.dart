import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';

class HeaderApp extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final bool mostrarMenu;
  final VoidCallback? onBackPressed;
  final bool? isFavorito;
  final VoidCallback? onFavoritoPressed;

  const HeaderApp({
    super.key,
    required this.titulo,
    this.mostrarMenu = true,
    this.onBackPressed,
    this.isFavorito,
    this.onFavoritoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.negro,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón izquierdo (menú o atrás)
          IconButton(
            icon: Icon(
              mostrarMenu ? Icons.menu : Icons.arrow_back,
              color: AppColors.blanco,
            ),
            iconSize: 30,
            onPressed: () {
              if (mostrarMenu) {
                Scaffold.of(context).openDrawer();
              } else if (onBackPressed != null) {
                onBackPressed!();
              } else {
                Navigator.pop(context);
              }
            },
          ),

          // Título centrado
          Expanded(
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.blanco,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Botón derecho (favoritos u espaciador)
          if (isFavorito != null && onFavoritoPressed != null)
            IconButton(
              icon: Icon(
                isFavorito! ? Icons.star : Icons.star_border,
                color: isFavorito! ? AppColors.amarilloAragon : AppColors.blanco,
              ),
              iconSize: 28,
              onPressed: onFavoritoPressed,
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
