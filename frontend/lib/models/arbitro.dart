class Arbitro {
  final String dni;
  final String id;
  final String nombre;
  final String apellido;
  final String edad;
  final String email;
  final String contrasenya;
  final int telefono;

  Arbitro({
    required this.dni,
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.edad,
    required this.email,
    required this.contrasenya,
    required this.telefono,
  });



  @override
  String toString() {
    return 'Arbitro -->ID: $id, DNI: $dni, nombre: $nombre, apellido: $apellido edad: $edad, email: $email, contraseña: $contrasenya, teléfono: $telefono';
  }
}
