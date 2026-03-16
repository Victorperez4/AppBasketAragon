class Jugador {
  final String nombre;
  final String apellido;
  final String posicion;
  final double altura;
  final double peso;

  final double promedioPuntos;
  final double promedioRebotes;
  final double promedioAsistencias;
  final double promedioRobos;

  Jugador({
    required this.nombre,
    required this.apellido,
    required this.posicion,
    required this.altura,
    required this.peso,
    required this.promedioPuntos,
    required this.promedioRebotes,
    required this.promedioAsistencias,
    required this.promedioRobos,
  });

  String get nombreCompleto => "$nombre $apellido";

  @override
  bool operator ==(Object other) =>
      other is Jugador && other.nombreCompleto == nombreCompleto;

  @override
  int get hashCode => nombreCompleto.hashCode;
}
