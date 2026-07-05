import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cachuelitoo2/core/theme/app_theme.dart';
import 'package:cachuelitoo2/features/auth/presentation/screens/login_screen.dart';

Future<void> _pumpLoginScreen(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(theme: AppTheme.light, home: const LoginScreen()),
    ),
  );
}

void main() {
  testWidgets('shows a validation error for an invalid email', (tester) async {
    await _pumpLoginScreen(tester);

    await tester.enterText(find.widgetWithText(TextFormField, 'Correo electrónico'), 'not-an-email');
    await tester.enterText(find.widgetWithText(TextFormField, 'Contraseña'), 'password123');
    await tester.tap(find.text('ENTRAR'));
    await tester.pump(); // start submit
    await tester.pump(const Duration(milliseconds: 800)); // let the fake repo delay resolve

    expect(find.text('Ingresa un correo electrónico válido.'), findsOneWidget);
  });

  testWidgets('logs in successfully with valid credentials', (tester) async {
    await _pumpLoginScreen(tester);

    await tester.enterText(find.widgetWithText(TextFormField, 'Correo electrónico'), 'user@example.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Contraseña'), 'password123');
    await tester.tap(find.text('ENTRAR'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('Inicio de sesión exitoso'), findsOneWidget);
  });

  testWidgets('toggles password visibility', (tester) async {
    await _pumpLoginScreen(tester);

    expect(find.byIcon(Icons.visibility), findsOneWidget);
    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump();
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
  });
}
