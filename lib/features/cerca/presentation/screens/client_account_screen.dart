import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/cerca_controller.dart';
import '../../application/cerca_seed_data.dart';
import '../../domain/entities/client_history_entry.dart';
import '../widgets/cerca_header.dart';
import '../widgets/cerca_text_styles.dart';
import '../widgets/monogram_avatar.dart';

class ClientAccountScreen extends ConsumerWidget {
  const ClientAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cercaControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CercaHeader(title: 'Mi cuenta', onBack: () => context.go(RoutePaths.home)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const MonogramAvatar(text: 'SH', size: 56, borderRadius: 16, fontSize: 18),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sofía Herrera', style: CercaText.sora(fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text('Editar datos personales', style: CercaText.sora(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.cercaPrimary)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('Direcciones guardadas', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    for (final address in CercaSeedData.clientAddresses)
                      _InfoRow(title: address.label, detail: address.detail),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cercaDashedBorder),
                      ),
                      child: Text('+ Agregar dirección', style: CercaText.sora(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.cercaPrimary)),
                    ),
                    const SizedBox(height: 16),
                    Text('Métodos de pago', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    for (final method in CercaSeedData.clientPaymentMethods)
                      _InfoRow(title: method.label, detail: method.detail),
                    const SizedBox(height: 8),
                    Text('Historial de solicitudes', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    for (final entry in CercaSeedData.clientHistory) _HistoryRow(entry: entry),
                    const SizedBox(height: 10),
                    if (state.clientProfileSaved)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: AppColors.cercaSuccessBg,
                          border: Border.all(color: AppColors.cercaSuccessBorder),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('✓ Cambios guardados correctamente.', style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaSuccessText)),
                      ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text('Cerrar sesión', style: CercaText.sora(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.cercaTextMuted)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.title, required this.detail});
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.cercaBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: CercaText.sora(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(detail, style: CercaText.sora(fontSize: 11.5, color: AppColors.cercaTextSecondary)),
              ],
            ),
          ),
          Text('›', style: CercaText.sora(fontSize: 14, color: AppColors.cercaTextMuted)),
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});
  final ClientHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final completed = entry.status == ClientHistoryStatus.completed;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.cercaBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(entry.category, style: CercaText.sora(fontSize: 13, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: completed ? AppColors.cercaSuccessBg : AppColors.cercaDangerBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  completed ? 'Completado' : 'Cancelado',
                  style: CercaText.sora(fontSize: 10.5, fontWeight: FontWeight.w700, color: completed ? AppColors.cercaSuccessText : AppColors.cercaDangerText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('${entry.tech} · ${entry.date} · ${entry.price}', style: CercaText.sora(fontSize: 11.5, color: AppColors.cercaTextSecondary)),
        ],
      ),
    );
  }
}
