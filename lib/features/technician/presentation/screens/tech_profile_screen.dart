import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cerca/application/cerca_controller.dart';
import '../../../cerca/application/cerca_seed_data.dart';
import '../../../cerca/presentation/widgets/cerca_header.dart';
import '../../../cerca/presentation/widgets/cerca_text_styles.dart';
import '../../../cerca/presentation/widgets/monogram_avatar.dart';
import '../../../cerca/presentation/widgets/primary_action_button.dart';

class TechProfileScreen extends ConsumerWidget {
  const TechProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cercaControllerProvider);
    final controller = ref.watch(cercaControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CercaHeader(title: 'Mi perfil', onBack: () => context.go(RoutePaths.techDocs)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const MonogramAvatar(text: 'MR', size: 56, borderRadius: 16, fontSize: 18),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Marcelo Reyes', style: CercaText.sora(fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text('Cambiar foto', style: CercaText.sora(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.cercaPrimary)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _FieldLabel('Nombre'),
                    _ReadonlyField('Marcelo Reyes'),
                    const SizedBox(height: 14),
                    _FieldLabel('Oficio principal'),
                    _ReadonlyField('Gasfitero'),
                    const SizedBox(height: 14),
                    _FieldLabel('Categorías que ofreces'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final c in CercaSeedData.categories)
                          _Chip(
                            label: c.label,
                            active: state.techCategories.contains(c.id),
                            onTap: () => controller.toggleTechCategory(c.id),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _FieldLabel('Radio de cobertura'),
                        Text(
                          '${state.coverageKm} km',
                          style: CercaText.sora(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.cercaPrimary),
                        ),
                      ],
                    ),
                    Slider(
                      value: state.coverageKm.toDouble(),
                      min: 1,
                      max: 25,
                      divisions: 24,
                      activeColor: AppColors.cercaPrimary,
                      onChanged: (v) => controller.setCoverageKm(v.round()),
                    ),
                    const SizedBox(height: 8),
                    _FieldLabel('Disponibilidad'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (final d in CercaSeedData.weekDays)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: _DayChip(
                                label: d.label,
                                active: state.availableDays.contains(d.key),
                                onTap: () => controller.toggleDay(d.key),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    InkWell(
                      onTap: () => context.go(RoutePaths.techDocs),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.cercaBorder),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('Documentación y verificación', style: CercaText.sora(fontSize: 13, fontWeight: FontWeight.w600)),
                            ),
                            Text('›', style: CercaText.sora(fontSize: 14, color: AppColors.cercaTextMuted)),
                          ],
                        ),
                      ),
                    ),
                    if (state.techProfileSaved) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.cercaSuccessBg,
                          border: Border.all(color: AppColors.cercaSuccessBorder),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '✓ Cambios guardados correctamente.',
                          style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaSuccessText),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            PrimaryActionButton(label: 'Guardar cambios', onTap: controller.saveTechProfile),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: CercaText.sora(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.cercaTextSecondary),
    );
  }
}

class _ReadonlyField extends StatelessWidget {
  const _ReadonlyField(this.value);
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.cercaBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(value, style: CercaText.sora(fontSize: 13.5)),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.cercaPrimary : Colors.white,
          border: Border.all(color: active ? AppColors.cercaPrimary : AppColors.cercaBorder),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: CercaText.sora(fontSize: 12, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.cercaTextPrimary),
        ),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.cercaPrimary : Colors.white,
          border: Border.all(color: active ? AppColors.cercaPrimary : AppColors.cercaBorder),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: CercaText.sora(fontSize: 11.5, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.cercaTextPrimary),
        ),
      ),
    );
  }
}
