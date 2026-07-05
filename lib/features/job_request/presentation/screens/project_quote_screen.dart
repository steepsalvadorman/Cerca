import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cerca/application/cerca_controller.dart';
import '../../../cerca/application/cerca_format.dart';
import '../../../cerca/domain/entities/service_provider.dart';
import '../../../cerca/presentation/widgets/cerca_header.dart';
import '../../../cerca/presentation/widgets/cerca_text_styles.dart';
import '../../../cerca/presentation/widgets/primary_action_button.dart';

class ProjectQuoteScreen extends ConsumerWidget {
  const ProjectQuoteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cercaControllerProvider);
    final controller = ref.watch(cercaControllerProvider.notifier);
    final provider = controller.selectedProvider;
    final team = provider is TechTeam ? provider : null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CercaHeader(title: 'Cotización de proyecto', onBack: () => context.go(RoutePaths.providerProfile)),
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
                          Text('Proyecto de ${provider.oficio}', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(
                            '${provider.name} · trabajo a mediano plazo con equipo de ${team?.crew ?? 0} personas',
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
                            child: Text('Fotos y detalles del terreno/obra', style: CercaText.sora(fontSize: 11, color: AppColors.cercaPrimary)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text('Estimado referencial', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
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
                        children: [
                          _AmountRow('Mano de obra', formatClp(team?.laborCost ?? 0)),
                          const SizedBox(height: 8),
                          _AmountRow('Materiales (referencial)', formatClp(team?.materialsCost ?? 0)),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.only(top: 2),
                            decoration: const BoxDecoration(
                              border: Border(top: BorderSide(color: AppColors.cercaBorder)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Movilización del equipo', style: CercaText.sora(fontSize: 12.5, fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 1),
                                      Text(
                                        'Traslado de personal y herramientas · ${formatClp(team?.mobilityCost ?? 0)}',
                                        style: CercaText.sora(fontSize: 10.5, color: AppColors.cercaTextSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: state.mobilityIncluded,
                                  activeThumbColor: Colors.white,
                                  activeTrackColor: AppColors.cercaPrimary,
                                  onChanged: (_) => controller.toggleMobility(),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            decoration: const BoxDecoration(
                              border: Border(top: BorderSide(color: AppColors.cercaBorder)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total estimado', style: CercaText.sora(fontSize: 15, fontWeight: FontWeight.w700)),
                                Text(
                                  formatClp(controller.projectTotal),
                                  style: CercaText.sora(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.cercaPrimary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Cotización referencial. El equipo confirma el valor final tras una visita técnica. La obra y la movilización se pagan directo al equipo — Cerca solo cobra la tarifa de agendamiento de la visita.',
                      style: CercaText.sora(fontSize: 11.5, color: AppColors.cercaTextMuted, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            PrimaryActionButton(
              label: 'Solicitar visita y agendar',
              onTap: () {
                controller.requestProjectVisit();
                context.go(RoutePaths.jobFee);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaTextSecondary)),
        Text(value, style: CercaText.sora(fontSize: 12.5, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
