import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/auth_repository_impl.dart';
import '../domain/entities/auth_credentials.dart';
import '../domain/repositories/auth_repository.dart';
import 'login_state.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  LoginState build() => const LoginState();

  void emailChanged(String value) {
    state = state.copyWith(email: value, errorMessage: null);
  }

  void passwordChanged(String value) {
    state = state.copyWith(password: value, errorMessage: null);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  /// Returns true on success so the screen can navigate.
  Future<bool> submit() async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    final AuthRepository repository = ref.read(authRepositoryProvider);
    try {
      await repository.login(
        AuthCredentials(email: state.email, password: state.password),
      );
      state = state.copyWith(isSubmitting: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.message);
      return false;
    }
  }
}
