import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cerca/application/cerca_controller.dart';
import '../../../cerca/application/cerca_seed_data.dart';
import '../../../cerca/domain/entities/doc_requirement.dart';
import '../../../cerca/presentation/widgets/back_circle_button.dart';
import '../../../cerca/presentation/widgets/cerca_text_styles.dart';
import '../../../cerca/presentation/widgets/monogram_avatar.dart';
import '../../../cerca/presentation/widgets/primary_action_button.dart';

class TechDocsScreen extends ConsumerWidget {
  const TechDocsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cercaControllerProvider);
    final controller = ref.watch(cercaControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  BackCircleButton(onTap: () => context.go(RoutePaths.welcome)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Verifica tu perfil', style: CercaText.lora(fontSize: 19)),
                  ),
                  InkWell(
                    onTap: () => context.go(RoutePaths.techProfile),
                    borderRadius: BorderRadius.circular(16),
                    child: const MonogramAvatar(text: 'MR', size: 32, borderRadius: 16, fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Antes de recibir solicitudes, sube tu documentación. Así los hogares confían en abrirte la puerta.',
                      style: CercaText.sora(fontSize: 13.5, color: AppColors.cercaTextSecondary, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progreso', style: CercaText.sora(fontSize: 12, color: AppColors.cercaTextSecondary)),
                        Text(
                          '${controller.uploadedDocsCount} de ${CercaSeedData.docRequirements.length}',
                          style: CercaText.sora(fontSize: 12, color: AppColors.cercaTextSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: controller.docsProgress,
                        minHeight: 6,
                        backgroundColor: AppColors.cercaBorder,
                        color: AppColors.cercaPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    for (final doc in CercaSeedData.docRequirements)
                      _DocRow(
                        doc: doc,
                        uploaded: state.docs[doc.key] == DocStatus.uploaded,
                        onTap: () => controller.toggleDoc(doc.key),
                      ),
                    if (state.docsSubmitted)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.cercaSuccessBg,
                          border: Border.all(color: AppColors.cercaSuccessBorder),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '✓ Tu perfil fue enviado a revisión. Te avisaremos en 24–48 horas.',
                          style: CercaText.sora(fontSize: 13, color: AppColors.cercaSuccessText, height: 1.5),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            PrimaryActionButton(
              label: state.docsSubmitted ? 'Enviado a revisión' : 'Enviar a revisión',
              enabled: controller.allDocsUploaded,
              onTap: controller.submitDocs,
            ),
          ],
        ),
      ),
    );
  }
}

class _DocRow extends StatelessWidget {
  const _DocRow({required this.doc, required this.uploaded, required this.onTap});

  final DocRequirement doc;
  final bool uploaded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.cercaBorder)),
        ),
        child: Row(
          children: [
            MonogramAvatar(text: doc.mono, size: 38, borderRadius: 10, fontSize: 14),
            const SizedBox(width: 12),
            Expanded(
              child: Text(doc.label, style: CercaText.sora(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: uploaded ? AppColors.cercaSuccessBg : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: uploaded
                    ? Border.all(color: AppColors.cercaSuccessBorder)
                    : Border.all(color: const Color(0xFFD8CFC9), style: BorderStyle.solid),
              ),
              child: Text(
                uploaded ? 'Subido' : 'Pendiente',
                style: CercaText.sora(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: uploaded ? AppColors.cercaSuccessText : AppColors.cercaTextMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
