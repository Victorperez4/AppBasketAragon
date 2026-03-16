class Liga {
  final String categoria;
  final String nivel;

  Liga({
    required this.categoria,
    required this.nivel,
  });

  String get nombre => "$categoria $nivel";

  @override
  bool operator ==(Object other) =>
      other is Liga && other.nombre == nombre;

  @override
  int get hashCode => nombre.hashCode;
}
