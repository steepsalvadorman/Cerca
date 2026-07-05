import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cachuelitoo2/main.dart';

void main() {
  testWidgets('App boots and shows the splash screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CachuelitooApp()));

    expect(find.text('Bienvenido a la app, cargando...'), findsOneWidget);

    // Let the splash gate's 2-second delay complete so no timer is left
    // pending when the test tears down.
    await tester.pump(const Duration(seconds: 2));
  });
}
