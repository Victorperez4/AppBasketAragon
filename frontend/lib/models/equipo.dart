import 'package:tfg_appfede/models/jugador.dart';

class Equipo {
  final String nombre;
  final int victorias;
  final int derrotas;
  final double puntosAFavor;
  final double puntosEnContra;
  final List <Jugador> jugadores;

  Equipo({
    required this.nombre,
    required this.victorias,
    required this.derrotas,
    required this.puntosAFavor,
    required this.puntosEnContra,
    required this.jugadores,
  });

  @override
  bool operator ==(Object other) =>
      other is Equipo && other.nombre == nombre;

  @override
  int get hashCode => nombre.hashCode;
}
