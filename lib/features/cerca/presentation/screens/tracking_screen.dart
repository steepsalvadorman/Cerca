import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/cerca_controller.dart';
import '../../application/cerca_seed_data.dart';
import '../../domain/entities/timeline_step.dart';
import '../widgets/cerca_header.dart';
import '../widgets/cerca_text_styles.dart';
import '../widgets/monogram_avatar.dart';
import '../widgets/primary_action_button.dart';

class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cercaControllerProvider);
    final controller = ref.watch(cercaControllerProvider.notifier);
    final provider = controller.selectedProvider;
    final canAdvance = state.jobStep < 3;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CercaHeader(title: 'Seguimiento', onBack: () => context.go(RoutePaths.home)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        height: 120,
                        color: AppColors.cercaMapBackground,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.cercaMapMarker, borderRadius: BorderRadius.circular(20)),
                                child: Text('ETA 18 min', style: CercaText.sora(fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.white)),
                              ),
                            ),
                            Positioned(
                              top: 36,
                              left: 90,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(color: AppColors.cercaPrimary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                              ),
                            ),
                            Positioned(
                              top: 78,
                              left: 250,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(color: AppColors.cercaMapPin, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        for (final step in CercaSeedData.timelineSteps)
                          Expanded(child: _TimelineDot(step: step, currentStep: state.jobStep)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.cercaBorder),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          MonogramAvatar(text: provider.mono, size: 38, borderRadius: 10, fontSize: 13),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(provider.name, style: CercaText.sora(fontSize: 13, fontWeight: FontWeight.w600)),
                                Text(provider.oficio, style: CercaText.sora(fontSize: 11.5, color: AppColors.cercaTextSecondary)),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => context.go(RoutePaths.chat),
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: 34,
                              height: 34,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(color: AppColors.cercaSurfaceTint, shape: BoxShape.circle),
                              child: const Text('💬', style: TextStyle(fontSize: 14)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.cercaBorder),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          _SummaryRow('Trabajo', 'Fuga de agua'),
                          const SizedBox(height: 6),
                          _SummaryRow('Dirección', 'Av. Providencia 1234'),
                          const SizedBox(height: 6),
                          _SummaryRow('Acordado', '\$32.000', valueColor: AppColors.cercaPrimary, bold: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PrimaryActionButton(
              label: canAdvance ? 'Actualizar estado' : 'Ir a pagar y calificar',
              onTap: () {
                if (canAdvance) {
                  controller.advanceJob();
                } else {
                  context.go(RoutePaths.jobRating);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({required this.step, required this.currentStep});
  final TimelineStepDef step;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final active = step.step <= currentStep;
    final isCurrent = step.step == currentStep;
    final mark = step.step < currentStep ? '✓' : '';
    final labelColor = isCurrent
        ? AppColors.cercaTextPrimary
        : (active ? AppColors.cercaTextSecondary : AppColors.cercaTextMuted);

    return Column(
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.cercaPrimary : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: active ? AppColors.cercaPrimary : const Color(0xFFD8CFC9), width: 2),
          ),
          child: Text(mark, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 6),
        Text(step.label, textAlign: TextAlign.center, style: CercaText.sora(fontSize: 9.5, color: labelColor, height: 1.2)),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.valueColor = AppColors.cercaTextPrimary, this.bold = false});
  final String label;
  final String value;
  final Color valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaTextSecondary)),
        Text(value, style: CercaText.sora(fontSize: 12.5, fontWeight: bold ? FontWeight.w700 : FontWeight.w600, color: valueColor)),
      ],
    );
  }
}
