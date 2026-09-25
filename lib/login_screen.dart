import 'dart:math' as math;
import 'home_screen.dart';
import 'register_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  // Clave global para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para capturar los datos ingresados
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Estado para ocultar/mostrar contraseña
  bool _obscurePassword = true;

  // Controladores de animación para el robot
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Animación del saludo (movimiento de la mano)
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _waveAnimation = Tween<double>(begin: -0.1, end: 0.4).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    // 2. Animación de flotación suave
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _floatController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Función de inicio de sesión 100% funcional
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final usuario = _userController.text.trim();

      // Navega a la pantalla HomeScreen enviándole el usuario
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userName: usuario),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Fondo degradado pastel idéntico al diseño
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF3E8FF),
              Color(0xFFFFFFFF),
              Color(0xFFFFE5EC),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: ConstrainedBox(
                // ANCHO MÁXIMO PARA TABLET: Mantiene el formulario centrado y con un tamaño ideal
                constraints: const BoxConstraints(maxWidth: 460),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ROBOT ANIMADO POR CÓDIGO
                      AnimatedBuilder(
                        animation: Listenable.merge([_waveAnimation, _floatAnimation]),
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatAnimation.value),
                            child: SizedBox(
                              height: 190,
                              width: 220,
                              child: CustomPaint(
                                painter: RobotSaludandoPainter(waveAngle: _waveAnimation.value),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Título
                      const Text(
                        '¡Hola!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5B41D9),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Subtítulo
                      const Text(
                        'Inicia sesión para continuar\nen Mi Primera Voz',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5B41D9),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Campo Usuario
                      TextFormField(
                        controller: _userController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa tu nombre de usuario';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Color(0xFF5B41D9), fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person, color: Color(0xFF7C5CFF)),
                          hintText: 'Usuario',
                          hintStyle: const TextStyle(color: Color(0xFF9E8BEE)),
                          filled: true,
                          fillColor: const Color(0xFFF0EBFF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Campo Contraseña
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa tu contraseña';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Color(0xFF5B41D9), fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFF7C5CFF)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: const Color(0xFF7C5CFF),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          hintText: 'Contraseña',
                          hintStyle: const TextStyle(color: Color(0xFF9E8BEE)),
                          filled: true,
                          fillColor: const Color(0xFFF0EBFF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Botón Iniciar Sesión (Degradado con icono)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C5CFF), Color(0xFFF06292)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C5CFF).withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.login, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Iniciar sesión',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿No tienes una cuenta? ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5B41D9),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Regístrate',
                              style: TextStyle(
                                color: Color(0xFF5B41D9),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// CLASE PARA DIBUJAR AL ROBOT DE MI PRIMERA VOZ CON CÓDIGO VECTORIAL
class RobotSaludandoPainter extends CustomPainter {
  final double waveAngle;

  RobotSaludandoPainter({required this.waveAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final whitePaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final purpleBorder = Paint()
      ..color = const Color(0xFF6C5CE7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final cyanPaint = Paint()..color = const Color(0xFF00E5FF)..style = PaintingStyle.fill;
    final screenPaint = Paint()..color = const Color(0xFF1E1E38)..style = PaintingStyle.fill;

    final cyanGlow = Paint()
      ..color = const Color(0xFF00E5FF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    // 1. Antena
    canvas.drawLine(Offset(center.dx, center.dy - 55), Offset(center.dx, center.dy - 75), purpleBorder);
    canvas.drawCircle(Offset(center.dx, center.dy - 80), 8, cyanPaint);
    canvas.drawCircle(Offset(center.dx, center.dy - 80), 8, purpleBorder);

    // 2. Orejas / Auriculares
    canvas.drawCircle(Offset(center.dx - 58, center.dy - 22), 11, cyanPaint);
    canvas.drawCircle(Offset(center.dx - 58, center.dy - 22), 11, purpleBorder);
    canvas.drawCircle(Offset(center.dx + 58, center.dy - 22), 11, cyanPaint);
    canvas.drawCircle(Offset(center.dx + 58, center.dy - 22), 11, purpleBorder);

    // 3. Brazo izquierdo (fijo)
    final leftArm = Path()
      ..moveTo(center.dx - 40, center.dy + 35)
      ..quadraticBezierTo(center.dx - 58, center.dy + 48, center.dx - 48, center.dy + 65);
    canvas.drawPath(leftArm, purpleBorder..strokeCap = StrokeCap.round);

    // 4. Brazo derecho (saludando con animación)
    canvas.save();
    canvas.translate(center.dx + 40, center.dy + 35);
    canvas.rotate(waveAngle);
    final rightArm = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(15, -18, 24, -32);
    canvas.drawPath(rightArm, purpleBorder..strokeCap = StrokeCap.round);
    canvas.drawCircle(const Offset(24, -32), 6, whitePaint);
    canvas.drawCircle(const Offset(24, -32), 6, purpleBorder);
    canvas.restore();

    // 5. Cuerpo
    final bodyRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 50), width: 70, height: 46),
      const Radius.circular(18),
    );
    canvas.drawRRect(bodyRRect, whitePaint);
    canvas.drawRRect(bodyRRect, purpleBorder);

    // Escudo/Logo del centro
    canvas.drawCircle(Offset(center.dx, center.dy + 50), 10, Paint()..color = const Color(0xFF6C5CE7));
    canvas.drawCircle(Offset(center.dx, center.dy + 50), 6, cyanPaint);

    // 6. Cabeza
    final headRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy - 22), width: 108, height: 74),
      const Radius.circular(28),
    );
    canvas.drawRRect(headRRect, whitePaint);
    canvas.drawRRect(headRRect, purpleBorder);

    // Pantalla de la cara
    final faceRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy - 22), width: 86, height: 56),
      const Radius.circular(20),
    );
    canvas.drawRRect(faceRRect, screenPaint);

    // Ojos alegres (curvas de sonrisa)
    final leftEye = Path()
      ..moveTo(center.dx - 26, center.dy - 22)
      ..quadraticBezierTo(center.dx - 18, center.dy - 31, center.dx - 10, center.dy - 22);
    canvas.drawPath(leftEye, cyanGlow);

    final rightEye = Path()
      ..moveTo(center.dx + 10, center.dy - 22)
      ..quadraticBezierTo(center.dx + 18, center.dy - 31, center.dx + 26, center.dy - 22);
    canvas.drawPath(rightEye, cyanGlow);

    // Estrellitas decorativas alrededor
    _drawStar(canvas, Offset(center.dx - 70, center.dy + 20), 6, const Color(0xFFFFB74D));
    _drawStar(canvas, Offset(center.dx + 70, center.dy - 40), 8, const Color(0xFFFF80AB));
  }

  void _drawStar(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path();
    for (int i = 0; i < 5; i++) {
      double x = center.dx + size * math.cos(i * 4 * math.pi / 5);
      double y = center.dy + size * math.sin(i * 4 * math.pi / 5);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant RobotSaludandoPainter oldDelegate) {
    return oldDelegate.waveAngle != waveAngle;
  }
}