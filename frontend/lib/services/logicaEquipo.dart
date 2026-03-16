import 'package:tfg_appfede/models/equipo.dart';
import 'package:tfg_appfede/services/logicaJugador.dart';

class LogicaEquipo {
  static final LogicaEquipo _instance = LogicaEquipo._internal();
  factory LogicaEquipo() => _instance;
  LogicaEquipo._internal();

  final jugadores = LogicaJugador().jugadores;

  /// Equipos de ejemplo
  late final List<Equipo> _equipos = [
    Equipo(
      nombre: "Basket Zaragoza",
      victorias: 18,
      derrotas: 4,
      puntosAFavor: 82.5,
      puntosEnContra: 75.3,
      jugadores: jugadores.sublist(0, 2),
    ),
    Equipo(
      nombre: "CD Huesca",
      victorias: 12,
      derrotas: 10,
      puntosAFavor: 76.2,
      puntosEnContra: 78.1,
      jugadores: jugadores.sublist(1, 3),
    ),
    Equipo(
      nombre: "Oliver Basket",
      victorias: 20,
      derrotas: 2,
      puntosAFavor: 88.1,
      puntosEnContra: 70.4,
      jugadores: jugadores.sublist(0, 3),
    ),
  ];

  /// Obtener todos los equipos
  List<Equipo> get equipos => List.unmodifiable(_equipos);

  /// Buscar equipo por nombre
Equipo? buscarPorNombre(String nombre) {
  try {
    return _equipos.firstWhere(
      (e) => e.nombre.toLowerCase() == nombre.toLowerCase(),
    );
  } catch (_) {
    return null;
  }
}

}
