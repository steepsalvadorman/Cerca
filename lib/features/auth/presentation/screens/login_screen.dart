import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../application/login_controller.dart';
import '../widgets/email_text_field.dart';
import '../widgets/login_button.dart';
import '../widgets/password_text_field.dart';
import '../widgets/social_login_buttons.dart';
import '../widgets/top_background_image.dart';
import '../widgets/welcome_text.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    final success = await ref.read(loginControllerProvider.notifier).submit();
    if (!context.mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión exitoso')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginControllerProvider);
    final controller = ref.read(loginControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const TopBackgroundImage(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        const WelcomeText(),
                        const SizedBox(height: 8),
                        EmailTextField(
                          value: state.email,
                          onChanged: controller.emailChanged,
                        ),
                        const SizedBox(height: 8),
                        PasswordTextField(
                          value: state.password,
                          obscureText: state.obscurePassword,
                          onChanged: controller.passwordChanged,
                          onToggleVisibility: controller.togglePasswordVisibility,
                        ),
                        if (state.errorMessage != null) ...[
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Text(
                              state.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        LoginButton(
                          isLoading: state.isSubmitting,
                          onPressed: () => _submit(context, ref),
                        ),
                      ],
                    ),
                    const SocialLoginButtons(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
