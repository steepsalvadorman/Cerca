import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cerca/application/cerca_controller.dart';
import '../../../cerca/presentation/widgets/cerca_header.dart';
import '../../../cerca/presentation/widgets/cerca_text_styles.dart';
import '../../../cerca/presentation/widgets/primary_action_button.dart';

class JobRatingScreen extends ConsumerWidget {
  const JobRatingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cercaControllerProvider);
    final controller = ref.watch(cercaControllerProvider.notifier);
    final provider = controller.selectedProvider;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CercaHeader(title: 'Calificación final', onBack: () => context.go(RoutePaths.tracking)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          _CostRow('Servicio', '\$28.000'),
                          const SizedBox(height: 10),
                          _CostRow('Materiales', '\$4.000'),
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            margin: const EdgeInsets.only(top: 0),
                            decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.cercaBorder))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total pactado con el técnico', style: CercaText.sora(fontSize: 15, fontWeight: FontWeight.w700)),
                                Text('\$32.000', style: CercaText.sora(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.cercaPrimary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: AppColors.cercaWarnBg,
                        border: Border.all(color: AppColors.cercaWarnBorder),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Este monto se paga directo al técnico (efectivo o transferencia). Cerca no procesa el pago del trabajo — solo cobró la tarifa de servicio al iniciar el contacto.',
                        style: CercaText.sora(fontSize: 11.5, color: AppColors.cercaWarnText, height: 1.5),
                      ),
                    ),
                    if (state.paymentDone)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cercaSuccessBg,
                          border: Border.all(color: AppColors.cercaSuccessBorder),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Text('✓', style: CercaText.sora(fontSize: 26)),
                            const SizedBox(height: 6),
                            Text('¡Gracias por tu calificación!', style: CercaText.sora(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.cercaSuccessText)),
                            const SizedBox(height: 4),
                            Text(
                              '${provider.name} recibió tu reseña. Recuerda coordinar el pago del trabajo directamente con él/ella.',
                              textAlign: TextAlign.center,
                              style: CercaText.sora(fontSize: 12, color: const Color(0xFF4C7A63), height: 1.5),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      Text('¿Cómo estuvo el trabajo de ${provider.name}?', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          for (var i = 1; i <= 5; i++)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () => controller.setRating(i),
                                child: Text(
                                  '★',
                                  style: TextStyle(fontSize: 30, color: i <= state.rating ? AppColors.cercaStar : const Color(0xFFD8CFC9)),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        maxLines: 3,
                        style: CercaText.sora(fontSize: 12.5),
                        decoration: InputDecoration(
                          hintText: 'Cuéntanos cómo fue tu experiencia (opcional)',
                          hintStyle: CercaText.sora(fontSize: 12.5, color: AppColors.cercaTextMuted),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(12),
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
                    ],
                  ],
                ),
              ),
            ),
            if (!state.paymentDone)
              PrimaryActionButton(label: 'Confirmar y calificar', onTap: controller.confirmPayment),
          ],
        ),
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  const _CostRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaTextSecondary)),
        Text(value, style: CercaText.sora(fontSize: 12.5)),
      ],
    );
  }
}
