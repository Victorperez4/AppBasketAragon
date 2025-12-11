class Equipo {
  final String id;
  final String nombre;

  Equipo({
    required this.id,
    required this.nombre,

  });



  @override
  String toString() {
    return 'Equipo --> ID: $id, nombre: $nombre';
}
}