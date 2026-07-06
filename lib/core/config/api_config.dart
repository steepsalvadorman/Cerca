/// Backend base URL, resolved at build/run time via `--dart-define`.
///
/// Local dev (default): `flutter run` talks to the backend running on
/// your machine via `cargo run` (see `backend/README.md`). `10.0.2.2` is
/// the Android emulator's alias for the host machine's `localhost`.
///
/// Other targets:
///   Desktop/iOS simulator/web:
///     flutter run --dart-define=API_BASE_URL=http://localhost:8080
///   Physical device (replace with your machine's LAN IP):
///     flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8080
///   Against the deployed backend:
///     flutter run --dart-define=API_BASE_URL=https://cerca-backend-twilight-sun-9716.fly.dev
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );
}
