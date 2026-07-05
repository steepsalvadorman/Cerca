import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/cerca_controller.dart';
import '../widgets/cerca_header.dart';
import '../widgets/cerca_text_styles.dart';
import '../widgets/monogram_avatar.dart';
import '../widgets/verified_badge.dart';

class DirectQuoteScreen extends ConsumerWidget {
  const DirectQuoteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(cercaControllerProvider.notifier);
    ref.watch(cercaControllerProvider);
    final provider = controller.selectedProvider;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CercaHeader(title: 'Cotización', onBack: () => context.go(RoutePaths.providerProfile)),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fuga de agua en el baño', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(
                            'Gasfitería · Av. Providencia 1234, depto 502',
                            style: CercaText.sora(fontSize: 12, color: AppColors.cercaTextSecondary, height: 1.5),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            height: 70,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.cercaSurfaceTint,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('Foto adjunta del problema', style: CercaText.sora(fontSize: 11, color: AppColors.cercaPrimary)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text('Cotización de ${provider.name}', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.cercaBorder),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              MonogramAvatar(text: provider.mono, size: 38, borderRadius: 10, fontSize: 13),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(provider.name, style: CercaText.sora(fontSize: 13, fontWeight: FontWeight.w600)),
                                        const SizedBox(width: 5),
                                        const VerifiedBadge(),
                                      ],
                                    ),
                                    Text(provider.oficio, style: CercaText.sora(fontSize: 11.5, color: AppColors.cercaTextSecondary)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text('\$32.000', style: CercaText.lora(fontSize: 26, color: AppColors.cercaPrimary)),
                          const SizedBox(height: 6),
                          Text(
                            'Puede llegar hoy a las 17:00 · trae materiales básicos',
                            style: CercaText.sora(fontSize: 12, color: AppColors.cercaTextSecondary),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.cercaBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '"Reviso la llave de paso y cambio el sello. Si es la cañería, te aviso antes de continuar."',
                              style: CercaText.sora(fontSize: 12.5, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.cercaBorder))),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go(RoutePaths.chat),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.cercaPrimary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('Chatear', style: CercaText.sora(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.cercaPrimary)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.acceptDirect();
                        context.go(RoutePaths.jobFee);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cercaPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('Aceptar cotización', style: CercaText.sora(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: Text(
                'Al aceptar, Cerca cobra una tarifa de contacto. El pago del trabajo (\$32.000) es directo con el técnico.',
                textAlign: TextAlign.center,
                style: CercaText.sora(fontSize: 11, color: AppColors.cercaTextMuted, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
