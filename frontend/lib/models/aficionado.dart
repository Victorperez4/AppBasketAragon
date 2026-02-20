class Aficionado {
  final String dni;
  final String nombre;
  final String edad;
  final String email;
  final String contrasenya;
  final int telefono;

  Aficionado({
    required this.dni,
    required this.nombre,
    required this.edad,
    required this.email,
    required this.contrasenya,
    required this.telefono,
  });



  @override
  String toString() {
    return 'Aficionado --> DNI: $dni, nombre: $nombre, edad: $edad, email: $email, contraseña: $contrasenya, teléfono: $telefono';
  }
}
