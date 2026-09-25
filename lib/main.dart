import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const MiPrimeraVozApp());
}

class MiPrimeraVozApp extends StatelessWidget {
  const MiPrimeraVozApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Primera Voz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C5CFF),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}