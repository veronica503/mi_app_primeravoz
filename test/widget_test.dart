import 'package:flutter_test/flutter_test.dart';

import 'package:mi_app/main.dart';

void main() {
  testWidgets('La pantalla de login se renderiza correctamente', (tester) async {
    await tester.pumpWidget(const MiPrimeraVozApp());

    expect(find.text('¡Hola!'), findsOneWidget);
    expect(find.text('Inicia sesión para continuar\nen Mi Primera Voz'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Crear cuenta'), findsOneWidget);
  });
}
