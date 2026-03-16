import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'package:tfg_appfede/services/autenticacion_service.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  // Controladores para los campos del formulario
  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController apellidosCtrl = TextEditingController();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController licenciaCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController confirmPassCtrl = TextEditingController();
  
  // Variables de estado
  bool mostrarPassword = false;
  bool mostrarConfirmPassword = false;
  bool aceptaTerminos = false;
  
  // Tipo de usuario seleccionado
  String tipoUsuario = 'Aficionado';
  final List<String> tiposUsuario = [
    'Aficionado',
    'Jugador',
    'Entrenador',
    'Árbitro',
  ];

  @override
  void dispose() {
    // Liberar recursos de los controladores
    nombreCtrl.dispose();
    apellidosCtrl.dispose();
    usernameCtrl.dispose();
    licenciaCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  /// Verificar si el rol requiere número de licencia
  bool get requiereLicencia {
    return tipoUsuario == 'Jugador' || 
           tipoUsuario == 'Entrenador' || 
           tipoUsuario == 'Árbitro';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo con gradiente
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.gradienteAragon,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botón atrás
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.blanco),
                  onPressed: () => Navigator.pop(context),
                ),

                const SizedBox(height: 20),

                // Logo y título
                Center(
                  child: Column(
                    children: [
                      // Logo de la FAB
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: AppColors.gradienteNaranjaAmarillo,
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset(
                            'assets/images/LogoFAB.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.sports_basketball,
                                  size: 60,
                                  color: AppColors.blanco,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      const Text(
                        'CREAR CUENTA',
                        style: TextStyle(
                          color: AppColors.blanco,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // SELECTOR DE ROL (PRIMERO)
                _buildTipoUsuarioSelector(),

                const SizedBox(height: 24),

                // Campos del formulario
                _buildTextField(
                  controller: nombreCtrl,
                  label: 'Nombre',
                  icon: Icons.person,
                ),
                
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: apellidosCtrl,
                  label: 'Apellidos',
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  controller: usernameCtrl,
                  label: 'Nombre de usuario',
                  icon: Icons.alternate_email,
                ),

                const SizedBox(height: 16),

                // CAMPO DE LICENCIA (solo para Jugador, Entrenador y Árbitro)
                if (requiereLicencia) ...[
                  _buildTextField(
                    controller: licenciaCtrl,
                    label: _getLicenciaLabel(),
                    icon: Icons.badge,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                ],

                _buildTextField(
                  controller: emailCtrl,
                  label: 'Correo Electrónico',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                // Campo de contraseña
                _buildTextField(
                  controller: passCtrl,
                  label: 'Contraseña',
                  icon: Icons.lock,
                  obscureText: !mostrarPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      mostrarPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.blancoOpacidad70,
                    ),
                    onPressed: () {
                      setState(() => mostrarPassword = !mostrarPassword);
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Confirmar contraseña
                _buildTextField(
                  controller: confirmPassCtrl,
                  label: 'Repite la Contraseña',
                  icon: Icons.lock_outline,
                  obscureText: !mostrarConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      mostrarConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.blancoOpacidad70,
                    ),
                    onPressed: () {
                      setState(() => mostrarConfirmPassword = !mostrarConfirmPassword);
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Checkbox de términos y condiciones
                Row(
                  children: [
                    Checkbox(
                      value: aceptaTerminos,
                      onChanged: (value) {
                        setState(() => aceptaTerminos = value ?? false);
                      },
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.naranja;
                        }
                        return AppColors.blanco;
                      }),
                    ),
                    const Expanded(
                      child: Text(
                        'Acepto los Términos y Condiciones',
                        style: TextStyle(
                          color: AppColors.blanco,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Botón de registro
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.naranja,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: aceptaTerminos ? _handleRegistro : null,
                    child: const Text(
                      'REGISTRARSE',
                      style: TextStyle(
                        color: AppColors.blanco,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Divisor
                const Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.blancoOpacidad54)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'O',
                        style: TextStyle(color: AppColors.blanco),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.blancoOpacidad54)),
                  ],
                ),

                const SizedBox(height: 16),

                // Botones de redes sociales
                _socialButton(
                  text: 'Continuar con Google',
                  icon: Icons.g_mobiledata,
                  onPressed: () {
                    // TODO: Implementar login con Google
                  },
                ),
                
                const SizedBox(height: 12),
                
                _socialButton(
                  text: 'Continuar con Facebook',
                  icon: Icons.facebook,
                  onPressed: () {
                    // TODO: Implementar login con Facebook
                  },
                ),

                const SizedBox(height: 24),

                // Enlace a iniciar sesión
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Volver a la pantalla de inicio de sesión
                      Navigator.pop(context);
                    },
                    child: const Text(
                      '¿Ya tienes cuenta? INICIAR SESIÓN',
                      style: TextStyle(
                        color: AppColors.blanco,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget de campo de texto reutilizable
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: AppColors.blanco),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.blancoOpacidad70),
        prefixIcon: Icon(icon, color: AppColors.blancoOpacidad70),
        suffixIcon: suffixIcon,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.blancoOpacidad54),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.blanco),
        ),
      ),
    );
  }

  /// Selector de tipo de usuario con menú desplegable
  Widget _buildTipoUsuarioSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blanco,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.badge, color: AppColors.naranja, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Selecciona tu rol',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.negro,
                ),
              ),
              const Spacer(),
              // Icono de información
              IconButton(
                icon: const Icon(Icons.info_outline, color: AppColors.naranja),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: _mostrarInfoTipoUsuario,
              ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: tipoUsuario,
              isExpanded: true,
              dropdownColor: AppColors.blanco,
              style: const TextStyle(
                color: AppColors.negro,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.naranja),
              items: tiposUsuario.map((String tipo) {
                return DropdownMenuItem<String>(
                  value: tipo,
                  child: Row(
                    children: [
                      Icon(
                        _getIconForRole(tipo),
                        color: AppColors.naranja,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(tipo),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    tipoUsuario = newValue;
                    // Limpiar el campo de licencia si cambia a Aficionado
                    if (!requiereLicencia) {
                      licenciaCtrl.clear();
                    }
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Obtener icono según el rol
  IconData _getIconForRole(String role) {
    switch (role) {
      case 'Jugador':
        return Icons.sports_basketball;
      case 'Entrenador':
        return Icons.sports;
      case 'Árbitro':
        return Icons.sports_score;
      case 'Aficionado':
        return Icons.favorite;
      default:
        return Icons.person;
    }
  }

  /// Obtener label del campo de licencia según el rol
  String _getLicenciaLabel() {
    switch (tipoUsuario) {
      case 'Jugador':
        return 'Número de Licencia de Jugador';
      case 'Entrenador':
        return 'Número de Licencia de Entrenador';
      case 'Árbitro':
        return 'Número de Licencia Arbitral';
      default:
        return 'Número de Licencia';
    }
  }

  /// Botón de redes sociales
  Widget _socialButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.blanco),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.blanco),
        label: Text(
          text,
          style: const TextStyle(color: AppColors.blanco),
        ),
      ),
    );
  }

  /// Mostrar información sobre los tipos de usuario
  void _mostrarInfoTipoUsuario() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tipos de Usuario'),
        content: const Text(
          '🏀 Jugador: Necesitarás tu número de licencia de jugador\n\n'
          '🏆 Entrenador: Necesitarás tu número de licencia de entrenador\n\n'
          '⚖️ Árbitro: Necesitarás tu número de licencia arbitral\n\n'
          '❤️ Aficionado: Acceso como seguidor de equipos (no requiere licencia)',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  /// Manejar el registro del usuario
  void _handleRegistro() async {
    // Validaciones básicas
    if (nombreCtrl.text.isEmpty || 
        apellidosCtrl.text.isEmpty || 
        usernameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty) {
      _mostrarError('Por favor completa todos los campos obligatorios');
      return;
    }

    // Validar licencia si es requerida
    if (requiereLicencia && licenciaCtrl.text.isEmpty) {
      _mostrarError('El número de licencia es obligatorio para ${tipoUsuario}s');
      return;
    }
    
    if (passCtrl.text != confirmPassCtrl.text) {
      _mostrarError('Las contraseñas no coinciden');
      return;
    }
    
    if (passCtrl.text.length < 6) {
      _mostrarError('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    // Validar formato de email
    if (!emailCtrl.text.contains('@')) {
      _mostrarError('Por favor ingresa un correo electrónico válido');
      return;
    }
    
    // Crear objeto Usuario
    Usuario nuevoUsuario = Usuario(
      nombre: nombreCtrl.text,
      apellidos: apellidosCtrl.text,
      email: emailCtrl.text,
      password: passCtrl.text,
      rol: tipoUsuario,
      username: usernameCtrl.text,
      licencia: requiereLicencia ? licenciaCtrl.text : null,
    );
    
    // Registrar usuario usando el servicio
    bool registroExitoso = await AutenticacionService.registrarUsuario(nuevoUsuario);
    
    if (registroExitoso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registro exitoso como $tipoUsuario. Por favor inicia sesión'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Navegar a la pantalla de inicio de sesión
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } else {
      _mostrarError('Error en el registro. El email o usuario ya está registrado.');
    }
  }

  /// Mostrar mensaje de error
  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }
}