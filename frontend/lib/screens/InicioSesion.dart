import 'package:flutter/material.dart';
import 'package:tfg_appfede/config/common/resources/colores.dart';
import 'Registro.dart';
import 'Inicio.dart';

class InicioSesionPage extends StatefulWidget {
  const InicioSesionPage({super.key});

  @override
  State<InicioSesionPage> createState() => _InicioSesionPageState();
}

class _InicioSesionPageState extends State<InicioSesionPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  bool mostrarPassword = false;

  @override
  void dispose() {
    // Liberar recursos de los controladores
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                // Botón atrás (opcional si hay navegación previa)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.blanco),
                  onPressed: () => Navigator.pop(context),
                ),

                const SizedBox(height: 20),

                // Logo + título
                Center(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.asset(
                          'assets/images/LogoFAB.png',
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "FEDERACIÓN ARAGONESA DE BASKET",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.blanco,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "INICIAR SESIÓN",
                        style: TextStyle(
                          color: AppColors.blanco,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Campo email
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.blanco),
                  decoration: _inputDecoration("Correo Electrónico"),
                ),

                const SizedBox(height: 20),

                // Campo contraseña
                TextField(
                  controller: passCtrl,
                  obscureText: !mostrarPassword,
                  style: const TextStyle(color: AppColors.blanco),
                  decoration: _inputDecoration("Contraseña").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        mostrarPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.blancoOpacidad70,
                      ),
                      onPressed: () {
                        setState(() => mostrarPassword = !mostrarPassword);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Olvidaste contraseña
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implementar recuperación de contraseña
                    },
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(color: AppColors.blanco),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Botón iniciar sesión
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
                    onPressed: _handleLogin,
                    child: const Text(
                      "INICIAR SESIÓN",
                      style: TextStyle(
                        color: AppColors.blanco,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

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

                const SizedBox(height: 20),

                // Botones Google / Facebook
                _socialButton(
                  text: "Continuar con Google",
                  icon: Icons.g_mobiledata,
                  onPressed: () {
                    // TODO: Implementar login con Google
                  },
                ),
                const SizedBox(height: 12),
                _socialButton(
                  text: "Continuar con Facebook",
                  icon: Icons.facebook,
                  onPressed: () {
                    // TODO: Implementar login con Facebook
                  },
                ),

                const SizedBox(height: 30),

                // Registro
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Navegar a pantalla de registro
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistroPage()),
                      );
                    },
                    child: const Text(
                      "¿No tienes cuenta? REGÍSTRATE",
                      style: TextStyle(
                        color: AppColors.blanco,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Botón de invitado
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navegar a la app como invitado (funcionalidad limitada)
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const InicioPage()),
                      );
                    },
                    child: const Text(
                      "Continuar como invitado",
                      style: TextStyle(
                        color: AppColors.blancoOpacidad70,
                        fontSize: 14,
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

  /// Decoración de los campos de entrada
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.blancoOpacidad70),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.blancoOpacidad54),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.blanco),
      ),
    );
  }

  /// Widget de botón de redes sociales
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

  /// Manejar el inicio de sesión
  void _handleLogin() {
    // Validaciones básicas
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Implementar lógica de autenticación con la base de datos
    // Por ahora solo mostramos un mensaje de éxito y navegamos
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Inicio de sesión exitoso'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );

    // Navegar a la pantalla de inicio
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InicioPage()),
      );
    });
  }
}