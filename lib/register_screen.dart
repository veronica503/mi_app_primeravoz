import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  // Simulación de base de datos de usuarios para garantizar unicidad
  static final Set<String> _registeredUsers = {'sofiagarcia123', 'mateolopez456'};

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  final _childNameController = TextEditingController();
  final _guardianNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Valores seleccionados en los dropdowns
  String? _selectedAge;
  String? _selectedGrade;
  String? _selectedGender;

  bool _isPasswordObscured = true;

  // Animación del robot
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _waveAnimation = Tween<double>(begin: -0.1, end: 0.4).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _childNameController.dispose();
    _guardianNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Genera el usuario único con 1 nombre + 1 apellido + sufijo numérico único
  String _generateUniqueUsername(String fullName) {
    List<String> parts = fullName.trim().split(RegExp(r'\s+'));
    String firstName = parts.isNotEmpty ? parts[0] : 'Usuario';
    String lastName = parts.length > 1 ? parts[1] : '';

    String baseName = '$firstName$lastName'.replaceAll(RegExp(r'[^a-zA-Z0-0]'), '').toLowerCase();

    String generatedUser = '';
    final random = math.Random();
    bool isUnique = false;

    while (!isUnique) {
      int randomNum = random.nextInt(900) + 100; // Número entre 100 y 999
      generatedUser = '$baseName$randomNum';
      if (!RegisterScreen._registeredUsers.contains(generatedUser)) {
        isUnique = true;
      }
    }

    RegisterScreen._registeredUsers.add(generatedUser);
    return generatedUser;
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      if (_selectedAge == null || _selectedGrade == null || _selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor completa las opciones de edad, grado y género.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      // Procesa el nombre del niño/a para mostrarlo en el saludo
      List<String> nameParts = _childNameController.text.trim().split(RegExp(r'\s+'));
      String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
      String lastName = nameParts.length > 1 ? nameParts[1] : '';
      String displayName = '$firstName $lastName'.trim();

      // Genera el ID único de usuario
      String uniqueUsername = _generateUniqueUsername(_childNameController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Cuenta creada exitosamente! Tu usuario único es: $uniqueUsername'),
          backgroundColor: const Color(0xFF7C5CFF),
        ),
      );

      // Redirige al HomeScreen pasando el nombre procesado
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userName: displayName),
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8EAF6),
              Color(0xFFF8F4FF),
              Color(0xFFFFF2F6),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 110,
                left: -30,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8C2FF).withValues(alpha: 0.28),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 180,
                right: -20,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC9D8).withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                left: 60,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D0FF).withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Color(0xFF5B41D9),
                                  size: 20,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: const Color(0xFFE5DEFF)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.extension_rounded,
                                      size: 20,
                                      color: Color(0xFF00E5FF),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Mi Primera Voz',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF5B41D9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Crear\ncuenta',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF5B41D9),
                                      height: 1.05,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEE8FF),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: const Text(
                                      'Acceso seguro y divertido',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6D5CE6),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _waveAnimation,
                              builder: (context, child) {
                                return SizedBox(
                                  height: 138,
                                  width: 138,
                                  child: CustomPaint(
                                    painter: SmallRobotPainter(waveAngle: _waveAnimation.value),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: const Color(0xFFE5E0FF), width: 1.2),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1F5B41D9),
                                blurRadius: 18,
                                offset: Offset(0, 9),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Nombres y apellidos del niño/a'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _childNameController,
                                  decoration: _inputDecoration('Ej. Sofía García López', Icons.face_rounded),
                                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa los nombres y apellidos' : null,
                                ),
                                const SizedBox(height: 16),

                                _buildFieldLabel('Edad del niño/a'),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedAge,
                                  decoration: _inputDecoration('Selecciona la edad', Icons.cake_rounded),
                                  items: List.generate(10, (i) => '${i + 3} años')
                                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                      .toList(),
                                  onChanged: (val) => setState(() => _selectedAge = val),
                                ),
                                const SizedBox(height: 16),

                                _buildFieldLabel('Grado al que pertenece'),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedGrade,
                                  decoration: _inputDecoration('Selecciona el grado', Icons.school_rounded),
                                  items: ['Kinder 4', 'Kinder 5', 'Kinder 6']
                                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                      .toList(),
                                  onChanged: (val) => setState(() => _selectedGrade = val),
                                ),
                                const SizedBox(height: 16),

                                _buildFieldLabel('Género'),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedGender,
                                  decoration: _inputDecoration('Selecciona el género', Icons.wc_rounded),
                                  items: ['Niña', 'Niño', 'Otro']
                                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                      .toList(),
                                  onChanged: (val) => setState(() => _selectedGender = val),
                                ),
                                const SizedBox(height: 16),

                                _buildFieldLabel('Nombre del responsable'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _guardianNameController,
                                  decoration: _inputDecoration('Ej. Ana Martínez', Icons.person_rounded),
                                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa el nombre del responsable' : null,
                                ),
                                const SizedBox(height: 16),

                                _buildFieldLabel('Correo electrónico del responsable'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: _inputDecoration('Ej. ana@gmail.com', Icons.email_rounded),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return 'Ingresa el correo';
                                    if (!v.contains('@') || !v.contains('.')) return 'Correo no válido';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                _buildFieldLabel('Crea una contraseña'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _isPasswordObscured,
                                  decoration: _inputDecoration('Mínimo 8 caracteres', Icons.lock_rounded).copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                        color: const Color(0xFF7C5CFF),
                                      ),
                                      onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.length < 8) return 'Debe tener al menos 8 caracteres';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 26),

                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF7C5CFF), Color(0xFFF06292)],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF7C5CFF).withValues(alpha: 0.35),
                                        blurRadius: 10,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _handleRegister,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person_add_rounded, color: Colors.white, size: 24),
                                        SizedBox(width: 8),
                                        Text(
                                          'Crear cuenta',
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
                                const SizedBox(height: 16),

                                Center(
                                  child: TextButton.icon(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF5B41D9)),
                                    label: const Text(
                                      'Volver al login',
                                      style: TextStyle(
                                        color: Color(0xFF5B41D9),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF5B41D9),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF7C5CFF)),
      filled: true,
      fillColor: const Color(0xFFF8F7FF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFE2DDFE)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFE2DDFE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFF7C5CFF), width: 2),
      ),
    );
  }
}

/// DIBUJO DEL ROBOT ANIMADO SUPERIOR
class SmallRobotPainter extends CustomPainter {
  final double waveAngle;

  SmallRobotPainter({required this.waveAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 10);

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

    // Antena
    canvas.drawLine(Offset(center.dx, center.dy - 35), Offset(center.dx, center.dy - 50), purpleBorder);
    canvas.drawCircle(Offset(center.dx, center.dy - 52), 6, cyanPaint);
    canvas.drawCircle(Offset(center.dx, center.dy - 52), 6, purpleBorder);

    // Orejas
    canvas.drawCircle(Offset(center.dx - 42, center.dy - 12), 8, cyanPaint);
    canvas.drawCircle(Offset(center.dx - 42, center.dy - 12), 8, purpleBorder);
    canvas.drawCircle(Offset(center.dx + 42, center.dy - 12), 8, cyanPaint);
    canvas.drawCircle(Offset(center.dx + 42, center.dy - 12), 8, purpleBorder);

    // Cabeza
    final headRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy - 12), width: 76, height: 52),
      const Radius.circular(20),
    );
    canvas.drawRRect(headRRect, whitePaint);
    canvas.drawRRect(headRRect, purpleBorder);

    // Pantalla
    final faceRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy - 12), width: 60, height: 38),
      const Radius.circular(14),
    );
    canvas.drawRRect(faceRRect, screenPaint);

    // Ojos
    final leftEye = Path()
      ..moveTo(center.dx - 18, center.dy - 12)
      ..quadraticBezierTo(center.dx - 12, center.dy - 19, center.dx - 6, center.dy - 12);
    canvas.drawPath(leftEye, cyanGlow);

    final rightEye = Path()
      ..moveTo(center.dx + 6, center.dy - 12)
      ..quadraticBezierTo(center.dx + 12, center.dy - 19, center.dx + 18, center.dy - 12);
    canvas.drawPath(rightEye, cyanGlow);

    // Cuerpo
    final bodyRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 32), width: 48, height: 30),
      const Radius.circular(12),
    );
    canvas.drawRRect(bodyRRect, whitePaint);
    canvas.drawRRect(bodyRRect, purpleBorder);
  }

  @override
  bool shouldRepaint(covariant SmallRobotPainter oldDelegate) => oldDelegate.waveAngle != waveAngle;
}