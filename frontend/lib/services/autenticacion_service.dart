import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Usuario {
  final String nombre;
  final String apellidos;
  final String email;
  final String password;
  final String rol;
  final String? licencia;
  final String username;

  Usuario({
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.password,
    required this.rol,
    required this.username,
    this.licencia,
  });

  // Convertir a JSON para almacenamiento
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellidos': apellidos,
      'email': email,
      'password': password,
      'rol': rol,
      'username': username,
      'licencia': licencia,
    };
  }

  // Construir desde JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nombre: json['nombre'] ?? '',
      apellidos: json['apellidos'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      rol: json['rol'] ?? 'Aficionado',
      username: json['username'] ?? '',
      licencia: json['licencia'],
    );
  }
}

class AutenticacionService {
  static const String _usuariosKey = 'usuarios_registrados';
  static const String _usuarioActualKey = 'usuario_actual';

  // Registrar un nuevo usuario
  static Future<bool> registrarUsuario(Usuario usuario) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Obtener lista de usuarios existentes
      List<Usuario> usuarios = await obtenerTodosLosUsuarios();
      
      // Verificar si el email ya existe
      if (usuarios.any((u) => u.email == usuario.email)) {
        return false; // Email ya registrado
      }
      
      // Verificar si el username ya existe
      if (usuarios.any((u) => u.username == usuario.username)) {
        return false; // Username ya registrado
      }
      
      // Agregar el nuevo usuario
      usuarios.add(usuario);
      
      // Guardar la lista actualizada
      List<String> usuariosJson = usuarios.map((u) => jsonEncode(u.toJson())).toList();
      await prefs.setStringList(_usuariosKey, usuariosJson);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Iniciar sesión
  static Future<bool> iniciarSesion(String email, String password) async {
    try {
      List<Usuario> usuarios = await obtenerTodosLosUsuarios();
      
      // Buscar usuario con email y contraseña
      Usuario? usuario = usuarios.firstWhere(
        (u) => u.email == email && u.password == password,
        orElse: () => Usuario(
          nombre: '',
          apellidos: '',
          email: '',
          password: '',
          rol: '',
          username: '',
        ),
      );
      
      if (usuario.nombre.isEmpty) {
        return false; // Usuario no encontrado
      }
      
      // Guardar usuario actualmente logueado
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_usuarioActualKey, jsonEncode(usuario.toJson()));
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Obtener usuario actual
  static Future<Usuario?> obtenerUsuarioActual() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? usuarioJson = prefs.getString(_usuarioActualKey);
      
      if (usuarioJson == null) {
        return null;
      }
      
      return Usuario.fromJson(jsonDecode(usuarioJson));
    } catch (e) {
      return null;
    }
  }

  // Cerrar sesión
  static Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usuarioActualKey);
  }

  // Obtener todos los usuarios registrados
  static Future<List<Usuario>> obtenerTodosLosUsuarios() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String>? usuariosJson = prefs.getStringList(_usuariosKey);
      
      if (usuariosJson == null || usuariosJson.isEmpty) {
        return [];
      }
      
      return usuariosJson.map((u) => Usuario.fromJson(jsonDecode(u))).toList();
    } catch (e) {
      return [];
    }
  }

  // Verificar si hay usuario actualmente logueado
  static Future<bool> tieneUsuarioActual() async {
    Usuario? usuario = await obtenerUsuarioActual();
    return usuario != null;
  }
}
