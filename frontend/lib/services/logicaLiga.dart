import 'package:tfg_appfede/models/liga.dart';


class LogicaLiga {
  static final LogicaLiga _instance = LogicaLiga._internal();
  factory LogicaLiga() => _instance;
  LogicaLiga._internal();

  /// Categorías de edad disponibles
  final List<String> categoriasEdad = [
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

  /// Categorías de nivel disponibles
  final List<String> categoriasNivel = [
    'Seleccionar nivel...',
    'Categoría A',
    'Categoría B',
    'Categoría C',
  ];

  /// Ligas reales (mock)
  final List<Liga> _ligas = [
    Liga(categoria: "Senior", nivel: "Categoría A"),
    Liga(categoria: "Infantil", nivel: "Categoría B"),
    Liga(categoria: "Cadete", nivel: "Categoría C"),
    Liga(categoria: "Junior", nivel: "Categoría A"),
  ];

  /// Obtener todas las ligas
  List<Liga> get ligas => List.unmodifiable(_ligas);

  /// Buscar liga por nombre completo
  Liga? buscarPorNombre(String nombre) {
    try {
      return _ligas.firstWhere(
        (l) => l.nombre.toLowerCase() == nombre.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Buscar liga por categoría y nivel
  Liga? buscarPorCategoriaNivel(String categoria, String nivel) {
    try {
      return _ligas.firstWhere(
        (l) =>
            l.categoria.toLowerCase() == categoria.toLowerCase() &&
            l.nivel.toLowerCase() == nivel.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
