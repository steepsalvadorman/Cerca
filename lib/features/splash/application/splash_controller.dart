import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_controller.g.dart';

/// Placeholder splash "gate": once there is a real session/auth check,
/// this is where it belongs (e.g. reading a persisted token) so the
/// splash screen can decide where to navigate without knowing the details.
@riverpod
Future<void> splashGate(Ref ref) async {
  await Future<void>.delayed(const Duration(seconds: 2));
}
