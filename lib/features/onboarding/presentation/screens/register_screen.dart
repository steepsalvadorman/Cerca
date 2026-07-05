import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cerca/application/cerca_controller.dart';
import '../../../cerca/presentation/widgets/back_circle_button.dart';
import '../../../cerca/presentation/widgets/cerca_logo_mark.dart';
import '../../../cerca/presentation/widgets/cerca_text_styles.dart';
import '../widgets/social_provider_button.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  Future<void> _selectSocial(BuildContext context, CercaController controller, String provider) async {
    controller.startSocial(provider);
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (!context.mounted) return;
    controller.finishSocial();
    context.go(RoutePaths.welcome);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cercaControllerProvider);
    final controller = ref.watch(cercaControllerProvider.notifier);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.cercaBackground, AppColors.cercaSurfaceTint],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
                child: Row(
                  children: [
                    BackCircleButton(onTap: () => context.go(RoutePaths.login)),
                  ],
                ),
              ),
              Expanded(
                child: state.socialAnimating
                    ? _ConnectingView(label: controller.socialProviderLabel)
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                        child: Column(
                          children: [
                            const CercaLogoMark(size: 44),
                            const SizedBox(height: 14),
                            Text('Crea tu cuenta', style: CercaText.lora(fontSize: 24)),
                            const SizedBox(height: 8),
                            Text(
                              'Elige cómo quieres ingresar',
                              style: CercaText.sora(fontSize: 15, color: AppColors.cercaTextSecondary),
                            ),
                            const SizedBox(height: 22),
                            SocialProviderButton(
                              label: 'Continuar con Google',
                              onTap: () => _selectSocial(context, controller, 'Google'),
                              iconBackground: Colors.white,
                              iconBorder: AppColors.cercaBorder,
                              icon: const _GoogleIcon(),
                            ),
                            const SizedBox(height: 12),
                            SocialProviderButton(
                              label: 'Continuar con Facebook',
                              onTap: () => _selectSocial(context, controller, 'Facebook'),
                              iconBackground: const Color(0xFF1877F2),
                              icon: const Icon(Icons.facebook, color: Colors.white, size: 22),
                            ),
                            const SizedBox(height: 12),
                            SocialProviderButton(
                              label: 'Continuar con TikTok',
                              onTap: () => _selectSocial(context, controller, 'TikTok'),
                              iconBackground: const Color(0xFF111111),
                              icon: const Icon(Icons.music_note, color: Colors.white, size: 20),
                            ),
                            const SizedBox(height: 12),
                            SocialProviderButton(
                              label: 'Continuar con WhatsApp',
                              onTap: controller.toggleWhatsapp,
                              iconBackground: const Color(0xFF25D366),
                              icon: const Icon(Icons.chat, color: Colors.white, size: 20),
                              trailing: Text(
                                state.whatsappOpen ? '︿' : '›',
                                style: CercaText.sora(fontSize: 15, color: AppColors.cercaTextMuted),
                              ),
                            ),
                            if (state.whatsappOpen)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: AppColors.cercaBorder),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    TextField(
                                      onChanged: controller.setWhatsappPhone,
                                      keyboardType: TextInputType.phone,
                                      style: CercaText.sora(fontSize: 15),
                                      decoration: InputDecoration(
                                        hintText: 'Tu número de WhatsApp',
                                        hintStyle: CercaText.sora(fontSize: 15, color: AppColors.cercaTextMuted),
                                        filled: true,
                                        fillColor: AppColors.cercaBackground,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: AppColors.cercaBorder),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: AppColors.cercaBorder),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    InkWell(
                                      onTap: () => _selectSocial(context, controller, 'WhatsApp'),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(14),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF25D366),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Enviar código por WhatsApp',
                                          style: CercaText.sora(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 24),
                            InkWell(
                              onTap: () => context.go(RoutePaths.login),
                              child: Text(
                                '¿Ya tienes cuenta? Inicia sesión',
                                style: CercaText.sora(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.cercaPrimary),
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
    );
  }
}

class _ConnectingView extends StatefulWidget {
  const _ConnectingView({required this.label});

  final String label;

  @override
  State<_ConnectingView> createState() => _ConnectingViewState();
}

class _ConnectingViewState extends State<_ConnectingView> with SingleTickerProviderStateMixin {
  late final AnimationController _breathe;

  @override
  void initState() {
    super.initState();
    _breathe = AnimationController(vsync: this, duration: const Duration(milliseconds: 500), lowerBound: 1.0, upperBound: 1.08)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _breathe,
            builder: (context, child) => Transform.scale(scale: _breathe.value, child: child),
            child: const CercaLogoMark(size: 72),
          ),
          const SizedBox(height: 18),
          Text(widget.label, style: CercaText.sora(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.cercaPrimary)),
        ],
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'G',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF4285F4)),
    );
  }
}
