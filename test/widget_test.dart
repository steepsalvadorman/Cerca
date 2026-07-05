import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cachuelitoo2/main.dart';

void main() {
  testWidgets('App boots into the animated splash and advances to Login', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CachuelitooApp()));
    await tester.pump();

    expect(find.text('Técnicos verificados, cerca de ti'), findsOneWidget);

    // Let the splash's 3.2s auto-navigate timer fire.
    await tester.pump(const Duration(milliseconds: 3300));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('¿Eres nuevo? Crea tu cuenta'), findsOneWidget);
  });
}
