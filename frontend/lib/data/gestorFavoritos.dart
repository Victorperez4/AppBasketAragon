import 'package:tfg_appfede/models/liga.dart';

class FavoritosManager {
  static final FavoritosManager _instance = FavoritosManager._internal();
  factory FavoritosManager() => _instance;
  FavoritosManager._internal();

  final Set<String> jugadoresFavoritos = {};
  final Set<String> equiposFavoritos = {};
  final Set<String> categoriasFavoritas = {};
  final Set<Liga> ligasFavoritas = {};

  // JUGADORES
  bool esJugadorFavorito(String nombreJugador) =>
      jugadoresFavoritos.contains(nombreJugador);

  void toggleJugadorFavorito(String nombreJugador) {
    if (esJugadorFavorito(nombreJugador)) {
      jugadoresFavoritos.remove(nombreJugador);
    } else {
      jugadoresFavoritos.add(nombreJugador);
    }
  }

  // EQUIPOS
  bool esEquipoFavorito(String equipoNombre) =>
      equiposFavoritos.contains(equipoNombre);

  void toggleEquipoFavorito(String equipoNombre) {
    if (esEquipoFavorito(equipoNombre)) {
      equiposFavoritos.remove(equipoNombre);
    } else {
      equiposFavoritos.add(equipoNombre);
    }
  }

  // CATEGORÍAS
  bool esCategoriaSfavorita(String categoria) =>
      categoriasFavoritas.contains(categoria);

  void toggleCategoriaFavorita(String categoria) {
    if (esCategoriaSfavorita(categoria)) {
      categoriasFavoritas.remove(categoria);
    } else {
      categoriasFavoritas.add(categoria);
    }
  }

  // LIGAS
  bool esLigaFavorita(Liga liga) =>
      ligasFavoritas.contains(liga);

  void toggleLigaFavorita(Liga liga) {
    if (esLigaFavorita(liga)) {
      ligasFavoritas.remove(liga);
    } else {
      ligasFavoritas.add(liga);
    }
  }
}
