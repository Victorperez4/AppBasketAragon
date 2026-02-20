import 'package:flutter/material.dart';

/// Colores corporativos de la Federación Aragonesa de Baloncesto
/// Basados en la bandera de Aragón (rojo y amarillo)
class AppColors {
  // ===== COLORES PRINCIPALES =====
  
  /// Rojo de Aragón - Color principal de la app
  static const Color rojoAragon = Color(0xFFC4161C);
  
  /// Amarillo de Aragón - Color complementario
  static const Color amarilloAragon = Color(0xFFF2C200);
  
  /// Naranja - Color de acción y elementos interactivos
  static const Color naranja = Color(0xFFF28C00);
  
  // ===== COLORES NEUTROS =====
  
  /// Negro - Fondos y textos principales
  static const Color negro = Color(0xFF0D0D0D);
  
  /// Blanco - Textos sobre fondos oscuros y fondos claros
  static const Color blanco = Color(0xFFFFFFFF);
  
  /// Gris claro - Elementos inactivos y secundarios
  static const Color grisClaro = Color(0xFFD9D9D9);
  
  // ===== GRADIENTES =====
  
  /// Gradiente rojo-amarillo (vertical, de arriba a abajo)
  static const LinearGradient gradienteAragon = LinearGradient(
    colors: [rojoAragon, amarilloAragon],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  /// Gradiente rojo-naranja (diagonal)
  static const LinearGradient gradienteRojoNaranja = LinearGradient(
    colors: [rojoAragon, naranja],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Gradiente naranja-amarillo (horizontal)
  static const LinearGradient gradienteNaranjaAmarillo = LinearGradient(
    colors: [naranja, amarilloAragon],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  // ===== COLORES CON OPACIDAD =====
  
  /// Negro con 50% opacidad - Para overlays
  static const Color negroOpacidad50 = Color(0x800D0D0D);
  
  /// Blanco con 70% opacidad - Para textos secundarios sobre oscuro
  static const Color blancoOpacidad70 = Color(0xB3FFFFFF);
  
  /// Blanco con 54% opacidad - Para bordes y divisores
  static const Color blancoOpacidad54 = Color(0x8AFFFFFF);
}