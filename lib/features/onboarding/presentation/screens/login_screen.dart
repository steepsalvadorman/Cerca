import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cerca/application/cerca_controller.dart';
import '../../../cerca/application/cerca_state.dart';
import '../../../cerca/presentation/widgets/cerca_logo_mark.dart';
import '../../../cerca/presentation/widgets/cerca_text_styles.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  Future<void> _doLogin(BuildContext context, CercaController controller, CercaState state) async {
    if (state.loginAnimating) return;
    controller.startLoginAnimation();
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!context.mounted) return;
    controller.finishLoginAnimation();
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 12, 26, 26),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CercaLogoMark(size: 17),
                    const SizedBox(width: 8),
                    Text('Cerca', style: CercaText.lora(fontSize: 17, color: AppColors.cercaPrimary)),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _LoginMark(animating: state.loginAnimating),
                        const SizedBox(height: 22),
                        if (state.loginAnimating)
                          Text('Ingresando…', style: CercaText.sora(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.cercaPrimary))
                        else ...[
                          Text('Bienvenido de vuelta', style: CercaText.lora(fontSize: 29)),
                          const SizedBox(height: 10),
                          Text(
                            'Técnicos verificados,\na un toque de tu puerta.',
                            textAlign: TextAlign.center,
                            style: CercaText.sora(fontSize: 16.5, fontWeight: FontWeight.w500, color: const Color(0xFF5A4E49), height: 1.6),
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                if (state.loginRemembered)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: AppColors.cercaBorder),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: AppColors.cercaSurfaceTint,
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Text(
                                            controller.loginInitial,
                                            style: CercaText.lora(fontSize: 19, color: AppColors.cercaPrimary),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                state.loginName,
                                                overflow: TextOverflow.ellipsis,
                                                style: CercaText.sora(fontSize: 17, fontWeight: FontWeight.w700),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Cuenta recordada en este dispositivo',
                                                style: CercaText.sora(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.cercaTextSecondary),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  TextField(
                                    textAlign: TextAlign.center,
                                    onChanged: controller.setLoginName,
                                    style: CercaText.sora(fontSize: 17, fontWeight: FontWeight.w600),
                                    decoration: InputDecoration(
                                      hintText: 'Tu nombre',
                                      hintStyle: CercaText.sora(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.cercaTextMuted),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: const BorderSide(color: AppColors.cercaBorder),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: const BorderSide(color: AppColors.cercaBorder),
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 16),
                                InkWell(
                                  onTap: () => _doLogin(context, controller, state),
                                  borderRadius: BorderRadius.circular(18),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(22),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.cercaPrimary,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(color: AppColors.cercaPrimary.withValues(alpha: 0.32), blurRadius: 28, offset: const Offset(0, 12)),
                                      ],
                                    ),
                                    child: Text(
                                      controller.loginButtonLabel,
                                      style: CercaText.sora(fontSize: 19, fontWeight: FontWeight.w700, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Text(
                  'Al continuar aceptas nuestros términos y el uso de tu ubicación para mostrarte técnicos cercanos.',
                  textAlign: TextAlign.center,
                  style: CercaText.sora(fontSize: 11.5, fontWeight: FontWeight.w500, color: AppColors.cercaTextMuted, height: 1.5),
                ),
                InkWell(
                  onTap: () => context.go(RoutePaths.register),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Text(
                      '¿Eres nuevo? Crea tu cuenta',
                      style: CercaText.sora(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.cercaPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginMark extends StatefulWidget {
  const _LoginMark({required this.animating});

  final bool animating;

  @override
  State<_LoginMark> createState() => _LoginMarkState();
}

class _LoginMarkState extends State<_LoginMark> with TickerProviderStateMixin {
  late final AnimationController _rotate;
  late final AnimationController _breathe;
  late final AnimationController _ring;
  late final AnimationController _pop;

  @override
  void initState() {
    super.initState();
    _rotate = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    _breathe = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300), lowerBound: 1.0, upperBound: 1.05)
      ..repeat(reverse: true);
    _ring = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
    _pop = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    if (widget.animating) {
      _ring.repeat();
      _pop.forward();
    }
  }

  @override
  void didUpdateWidget(_LoginMark oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating && !oldWidget.animating) {
      _pop.forward(from: 0);
      _ring.repeat();
    } else if (!widget.animating && oldWidget.animating) {
      _ring.stop();
      _pop.reset();
    }
  }

  @override
  void dispose() {
    _rotate.dispose();
    _breathe.dispose();
    _ring.dispose();
    _pop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118,
      height: 118,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _rotate,
            builder: (context, _) => Transform.rotate(
              angle: math.pi / 4 + _rotate.value * 2 * math.pi,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.cercaPrimary.withValues(alpha: 0.3), width: 1.5),
                  borderRadius: BorderRadius.circular(19.2),
                ),
              ),
            ),
          ),
          if (widget.animating)
            AnimatedBuilder(
              animation: _ring,
              builder: (context, _) => Stack(
                alignment: Alignment.center,
                children: [
                  _ringLayer(_ring.value),
                  _ringLayer((_ring.value + 0.318) % 1.0),
                ],
              ),
            ),
          if (widget.animating)
            ScaleTransition(
              scale: CurvedAnimation(parent: _pop, curve: Curves.easeOut),
              child: Transform.rotate(
                angle: math.pi / 4,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF8A2C37), Color(0xFF6B1F28)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: AppColors.cercaPrimary.withValues(alpha: 0.35), blurRadius: 30, offset: const Offset(0, 12))],
                  ),
                ),
              ),
            ),
          if (widget.animating)
            FadeTransition(
              opacity: CurvedAnimation(parent: _pop, curve: const Interval(0.4, 1.0)),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
          if (!widget.animating)
            AnimatedBuilder(
              animation: _breathe,
              builder: (context, child) => Transform.scale(scale: _breathe.value, child: child),
              child: const CercaLogoMark(size: 84),
            ),
        ],
      ),
    );
  }

  Widget _ringLayer(double t) {
    return Opacity(
      opacity: (0.55 * (1 - t)).clamp(0, 1),
      child: Transform.rotate(
        angle: math.pi / 4,
        child: Transform.scale(
          scale: 0.9 + t * 1.0,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.cercaPrimary, width: 2),
              borderRadius: BorderRadius.circular(19.2),
            ),
          ),
        ),
      ),
    );
  }
}
