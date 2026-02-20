import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  // Controladores para los campos del formulario
  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController apellidosCtrl = TextEditingController();
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
    'Jugador',
    'Entrenador',
    'Árbitro',
    'Aficionado',
  ];

  @override
  void dispose() {
    // Liberar recursos de los controladores
    nombreCtrl.dispose();
    apellidosCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.asset(
                          'assets/images/LogoFAB.png',
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      const Text(
                        'ARAGÓN BASKET',
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
                  controller: emailCtrl,
                  label: 'Correo Electrónico',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                // Selector de tipo de usuario
                _buildTipoUsuarioSelector(),

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
                  label: 'Confirmar Contraseña',
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
                        'Acepto los Términos y Condiciones y la Política de Privacidad',
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.blancoOpacidad54),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.badge, color: AppColors.blancoOpacidad70),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: tipoUsuario,
                isExpanded: true,
                dropdownColor: AppColors.negro,
                style: const TextStyle(color: AppColors.blanco, fontSize: 16),
                items: tiposUsuario.map((String tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => tipoUsuario = newValue);
                  }
                },
              ),
            ),
          ),
          // Icono de información
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.blancoOpacidad70),
            onPressed: () {
              _mostrarInfoTipoUsuario();
            },
          ),
        ],
      ),
    );
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
          'Jugador: Necesitarás tu número de licencia\n\n'
          'Entrenador: Necesitarás tu título de entrenador\n\n'
          'Árbitro: Necesitarás tu licencia arbitral\n\n'
          'Aficionado: Acceso como seguidor de equipos',
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
  void _handleRegistro() {
    // Validaciones básicas
    if (nombreCtrl.text.isEmpty || 
        apellidosCtrl.text.isEmpty || 
        emailCtrl.text.isEmpty) {
      _mostrarError('Por favor completa todos los campos');
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
    
    // TODO: Implementar lógica de registro con la base de datos
    // Por ahora solo mostramos un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registro exitoso. Por favor inicia sesión'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    
    // Navegar a la pantalla de inicio de sesión
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
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