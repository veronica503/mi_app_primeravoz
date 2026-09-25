import 'package:flutter/material.dart';
import 'login_screen.dart'; // Importante para regresar al Login al cerrar sesión

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Animación 1: Flotación del robot
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  // Animación 2: Saludo del brazo
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  // Animación 3: Salto/Rebote cuando el niño toca al robot
  late AnimationController _jumpController;
  late Animation<double> _jumpAnimation;

  int _currentNavIndex = 0;

  // Mensajes dinámicos para el bocadillo de diálogo
  final List<String> _robotPhrases = [
    '¡Vamos a aprender juntos!',
    '¡Qué alegría verte de nuevo!',
    '¿Qué quieres practicar hoy?',
    '¡Toca una tarjeta para empezar!',
    '¡Eres súper inteligente!',
  ];
  int _phraseIndex = 0;

  @override
  void initState() {
    super.initState();

    // 1. Configuración Flotación (Arriba / Abajo)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // 2. Configuración Mover Brazo
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _waveAnimation = Tween<double>(begin: -0.15, end: 0.45).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    // 3. Configuración Salto al Tocar
    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _jumpAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -25).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: -25, end: 0).chain(CurveTween(curve: Curves.bounceOut)), weight: 50),
    ]).animate(_jumpController);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _waveController.dispose();
    _jumpController.dispose();
    super.dispose();
  }

  // Interacción al presionar el robot
  void _onRobotTapped() {
    _jumpController.forward(from: 0.0);
    setState(() {
      _phraseIndex = (_phraseIndex + 1) % _robotPhrases.length;
    });
  }

  // Función para Cerrar Sesión y volver al Login
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cerrar sesión', style: TextStyle(color: Color(0xFF5B41D9), fontWeight: FontWeight.bold)),
        content: const Text('¿Estás seguro de que deseas salir de la aplicación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C5CFF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () {
              Navigator.pop(context); // Cierra el modal
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false, // Elimina todo el historial para volver al Login
              );
            },
            child: const Text('Salir', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Si no recibió nombre, usa "Amiguito"
    final String displayName = widget.userName.isNotEmpty ? widget.userName : 'Amiguito';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEBF3FF), Color(0xFFFFFFFF), Color(0xFFF6EEFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- BARRA SUPERIOR: PERFIL Y BOTÓN CERRAR SESIÓN ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: const Color(0xFFD6C7FF),
                                    child: const Icon(Icons.face_rounded, size: 32, color: Color(0xFF5B41D9)),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '¡Hola, $displayName!',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF5B41D9),
                                        ),
                                      ),
                                      const Text(
                                        '¡Qué bueno verte de nuevo!',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8E7CFF),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // BOTÓN DE CERRAR SESIÓN EN LA PARTE SUPERIOR DERECHA
                              InkWell(
                                onTap: _logout,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
                                    ],
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.logout_rounded, color: Color(0xFFF06292), size: 18),
                                      SizedBox(width: 4),
                                      Text(
                                        'Salir',
                                        style: TextStyle(
                                          color: Color(0xFFF06292),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // --- SECCIÓN DEL ROBOT Y BURBUJA DE DIÁLOGO INTERACTIVA ---
                          GestureDetector(
                            onTap: _onRobotTapped,
                            child: SizedBox(
                              height: 170,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Animaciones combinadas del Robot (Flotación + Salto + Saludo)
                                  AnimatedBuilder(
                                    animation: Listenable.merge([_floatAnimation, _jumpAnimation, _waveAnimation]),
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset: Offset(0, _floatAnimation.value + _jumpAnimation.value),
                                        child: CustomPaint(
                                          size: const Size(180, 160),
                                          painter: DashboardRobotPainter(waveAngle: _waveAnimation.value),
                                        ),
                                      );
                                    },
                                  ),

                                  // Burbuja de Diálogo Interactiva
                                  Positioned(
                                    right: 10,
                                    top: 15,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      constraints: const BoxConstraints(maxWidth: 140),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEAE2FF),
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: const [
                                          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                                        ],
                                      ),
                                      child: Text(
                                        _robotPhrases[_phraseIndex],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF5B41D9),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // --- SECCIÓN: MIS ÁREAS DE APRENDIZAJE ---
                          Row(
                            children: const [
                              Icon(Icons.stars_rounded, color: Color(0xFF5B41D9), size: 24),
                              SizedBox(width: 8),
                              Text(
                                'Mis áreas de aprendizaje',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5B41D9),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'Elige un área para comenzar',
                            style: TextStyle(fontSize: 13, color: Color(0xFF8E7CFF)),
                          ),
                          const SizedBox(height: 16),

                          // TARJETAS DE LECTURA, ESCRITURA Y HABLA
                          Row(
                            children: [
                              Expanded(
                                child: _buildLearningCard(
                                  title: 'Lectura',
                                  subtitle: 'Descubre el mundo de las palabras',
                                  color: const Color(0xFFF0EBFF),
                                  accentColor: const Color(0xFF7C5CFF),
                                  icon: Icons.menu_book_rounded,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildLearningCard(
                                  title: 'Escritura',
                                  subtitle: 'Aprende a escribir paso a paso',
                                  color: const Color(0xFFFFEBF2),
                                  accentColor: const Color(0xFFF06292),
                                  icon: Icons.edit_note_rounded,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildLearningCard(
                                  title: 'Habla',
                                  subtitle: 'Expresa lo que piensas y sientes',
                                  color: const Color(0xFFE8F7FF),
                                  accentColor: const Color(0xFF29B6F6),
                                  icon: Icons.record_voice_over_rounded,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // --- SECCIÓN: MI PROGRESO ---
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFF7C5CFF), size: 30),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Mi progreso',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5B41D9)),
                                      ),
                                      const Text(
                                        '¡Vas muy bien!',
                                        style: TextStyle(fontSize: 11, color: Color(0xFF8E7CFF)),
                                      ),
                                      const SizedBox(height: 6),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: const LinearProgressIndicator(
                                          value: 0.3,
                                          minHeight: 8,
                                          backgroundColor: Color(0xFFEFE8FF),
                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C5CFF)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: const [
                                    Text('Nivel 3', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5B41D9))),
                                    Text('(de 20)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                                const Icon(Icons.chevron_right_rounded, color: Color(0xFF8E7CFF)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // --- BARRA INFERIOR DE NAVEGACIÓN ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
        selectedItemColor: const Color(0xFF5B41D9),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Mi progreso'),
          BottomNavigationBarItem(icon: Icon(Icons.supervisor_account_rounded), label: 'Padres'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildLearningCard({
    required String title,
    required String subtitle,
    required Color color,
    required Color accentColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: accentColor),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: accentColor),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
            child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }
}

/// DIBUJO DEL ROBOT CON BRAZO ANIMADO
class DashboardRobotPainter extends CustomPainter {
  final double waveAngle;

  DashboardRobotPainter({required this.waveAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2 - 20, size.height / 2 + 10);

    final whitePaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final purpleBorder = Paint()
      ..color = const Color(0xFF6C5CE7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final cyanPaint = Paint()..color = const Color(0xFF00E5FF)..style = PaintingStyle.fill;
    final screenPaint = Paint()..color = const Color(0xFF1E1E38)..style = PaintingStyle.fill;

    final cyanGlow = Paint()
      ..color = const Color(0xFF00E5FF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.5;

    // 1. Antena
    canvas.drawLine(Offset(center.dx, center.dy - 45), Offset(center.dx, center.dy - 62), purpleBorder);
    canvas.drawCircle(Offset(center.dx, center.dy - 65), 7, cyanPaint);
    canvas.drawCircle(Offset(center.dx, center.dy - 65), 7, purpleBorder);

    // 2. Orejas
    canvas.drawCircle(Offset(center.dx - 48, center.dy - 18), 9, cyanPaint);
    canvas.drawCircle(Offset(center.dx - 48, center.dy - 18), 9, purpleBorder);
    canvas.drawCircle(Offset(center.dx + 48, center.dy - 18), 9, cyanPaint);
    canvas.drawCircle(Offset(center.dx + 48, center.dy - 18), 9, purpleBorder);

    // 3. Brazo Saludando (Animado)
    canvas.save();
    canvas.translate(center.dx + 35, center.dy + 25);
    canvas.rotate(waveAngle);
    final armPath = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(12, -15, 20, -26);
    canvas.drawPath(armPath, purpleBorder..strokeCap = StrokeCap.round);
    canvas.drawCircle(const Offset(20, -26), 5, whitePaint);
    canvas.drawCircle(const Offset(20, -26), 5, purpleBorder);
    canvas.restore();

    // 4. Cabeza
    final headRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy - 18), width: 90, height: 62),
      const Radius.circular(24),
    );
    canvas.drawRRect(headRRect, whitePaint);
    canvas.drawRRect(headRRect, purpleBorder);

    // Pantalla
    final faceRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy - 18), width: 72, height: 46),
      const Radius.circular(16),
    );
    canvas.drawRRect(faceRRect, screenPaint);

    // Ojos
    final leftEye = Path()
      ..moveTo(center.dx - 22, center.dy - 18)
      ..quadraticBezierTo(center.dx - 15, center.dy - 26, center.dx - 8, center.dy - 18);
    canvas.drawPath(leftEye, cyanGlow);

    final rightEye = Path()
      ..moveTo(center.dx + 8, center.dy - 18)
      ..quadraticBezierTo(center.dx + 15, center.dy - 26, center.dx + 22, center.dy - 18);
    canvas.drawPath(rightEye, cyanGlow);

    // 5. Cuerpo
    final bodyRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 40), width: 56, height: 36),
      const Radius.circular(14),
    );
    canvas.drawRRect(bodyRRect, whitePaint);
    canvas.drawRRect(bodyRRect, purpleBorder);

    // Escudo
    canvas.drawCircle(Offset(center.dx, center.dy + 40), 8, cyanPaint);
  }

  @override
  bool shouldRepaint(covariant DashboardRobotPainter oldDelegate) => oldDelegate.waveAngle != waveAngle;
}