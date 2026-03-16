import 'package:tfg_appfede/models/jugador.dart';

class LogicaJugador {
  static final LogicaJugador _instance = LogicaJugador._internal();
  factory LogicaJugador() => _instance;
  LogicaJugador._internal();

  /// Lista de jugadores de ejemplo
  final List<Jugador> _jugadores = [
    Jugador(
      nombre: "Pablo",
      apellido: "Pérez",
      posicion: "Escolta",
      altura: 1.92,
      peso: 85,
      promedioPuntos: 18.6,
      promedioRebotes: 6.2,
      promedioAsistencias: 3.8,
      promedioRobos: 1.5,
    ),
    Jugador(
      nombre: "Adrián",
      apellido: "Fernández",
      posicion: "Ala-Pívot",
      altura: 1.98,
      peso: 92,
      promedioPuntos: 15.4,
      promedioRebotes: 8.1,
      promedioAsistencias: 2.5,
      promedioRobos: 1.1,
    ),
    Jugador(
      nombre: "Miguel",
      apellido: "Torres",
      posicion: "Base",
      altura: 1.85,
      peso: 78,
      promedioPuntos: 12.7,
      promedioRebotes: 4.3,
      promedioAsistencias: 5.9,
      promedioRobos: 0.9,
    ),
  ];

  /// Obtener todos los jugadores
  List<Jugador> get jugadores => List.unmodifiable(_jugadores);

  /// Buscar jugador por nombre completo
Jugador? buscarPorNombre(String nombreCompleto) {
  try {
    return _jugadores.firstWhere(
      (j) => j.nombreCompleto.toLowerCase() == nombreCompleto.toLowerCase(),
    );
  } catch (_) {
    return null;
  }
}

}
