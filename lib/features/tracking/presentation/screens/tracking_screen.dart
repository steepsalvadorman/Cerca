import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/router/back_navigation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cerca/application/cerca_seed_data.dart';
import '../../../cerca/domain/entities/timeline_step.dart';
import '../../../cerca/presentation/widgets/cerca_header.dart';
import '../../../cerca/presentation/widgets/cerca_text_styles.dart';
import '../../../cerca/presentation/widgets/monogram_avatar.dart';
import '../../../cerca/presentation/widgets/primary_action_button.dart';
import '../../../job_request/application/active_job_controller.dart';
import '../../../job_request/domain/job_request.dart';
import '../../../job_request/presentation/agreed_price_label.dart';
import '../../../technician/application/providers_controller.dart';
import '../../application/tracking_controller.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  @override
  Widget build(BuildContext context) {
    final job = ref.watch(activeJobControllerProvider).value;
    final providersPage = ref.watch(providersControllerProvider).value;
    final jobStep = job?.timelineStep ?? 0;
    final locationAsync = job == null ? null : ref.watch(technicianLocationProvider(job.id));
    final location = locationAsync?.value;

    String providerName = '';
    String providerOficio = '';
    String providerMono = '?';
    if (providersPage != null && job != null) {
      if (job.technicianProfileId != null) {
        for (final t in providersPage.technicians) {
          if (t.id == job.technicianProfileId) {
            providerName = t.name;
            providerOficio = t.oficio;
            providerMono = t.mono;
          }
        }
      } else if (job.techTeamId != null) {
        for (final t in providersPage.teams) {
          if (t.id == job.techTeamId) {
            providerName = t.name;
            providerOficio = t.oficio;
            providerMono = t.mono;
          }
        }
      }
    }
    final agreedLabel = agreedPriceLabel(job, providersPage);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CercaHeader(title: 'Seguimiento', onBack: () => context.goBack(RoutePaths.home)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        height: 160,
                        child: location == null
                            ? Container(
                                color: AppColors.cercaMapBackground,
                                alignment: Alignment.center,
                                child: Text(
                                  job == null || (job.technicianProfileId == null && job.techTeamId == null)
                                      ? 'Aún no hay técnico asignado.'
                                      : 'Esperando la ubicación del técnico…',
                                  textAlign: TextAlign.center,
                                  style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaTextSecondary),
                                ),
                              )
                            : FlutterMap(
                                options: MapOptions(
                                  initialCenter: LatLng(location.latitude, location.longitude),
                                  initialZoom: 15,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.salvador.cerca',
                                  ),
                                  MarkerLayer(markers: [
                                    Marker(
                                      point: LatLng(location.latitude, location.longitude),
                                      width: 34,
                                      height: 34,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.cercaPrimary,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 3),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                      ),
                    ),
                    if (job != null && job.jobKind == 'direct' && job.isPending) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.cercaWarnBg,
                          border: Border.all(color: AppColors.cercaWarnBorder),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Esperando que $providerName acepte tu solicitud. Te avisaremos aquí cuando responda.',
                          style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaWarnText, height: 1.4),
                        ),
                      ),
                    ] else if (job != null && job.isCancelled) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Esta solicitud fue cancelada${job.jobKind == 'direct' ? ' o el técnico no pudo tomarla' : ''}. Puedes pedir a otro técnico desde Inicio.',
                        style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaTextSecondary, height: 1.4),
                      ),
                    ],
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        for (final step in CercaSeedData.timelineSteps)
                          Expanded(child: _TimelineDot(step: step, currentStep: jobStep)),
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
                          MonogramAvatar(text: providerMono, size: 38, borderRadius: 10, fontSize: 13),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(providerName, style: CercaText.sora(fontSize: 13, fontWeight: FontWeight.w600)),
                                Text(providerOficio, style: CercaText.sora(fontSize: 11.5, color: AppColors.cercaTextSecondary)),
                              ],
                            ),
                          ),
                          // 48dp hit area around a 36dp visual, and a real
                          // name for TalkBack instead of the emoji's.
                          IconButton(
                            onPressed: () => context.push(job == null ? RoutePaths.chat : RoutePaths.chatFor(job.id)),
                            tooltip: 'Abrir chat con $providerName',
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.cercaSurfaceTint,
                              foregroundColor: AppColors.cercaPrimary,
                              minimumSize: const Size(48, 48),
                            ),
                            icon: const Icon(Icons.chat_bubble_outline, size: 20),
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
                          _SummaryRow('Trabajo', (job?.title?.isNotEmpty ?? false) ? job!.title! : 'Sin título'),
                          const SizedBox(height: 6),
                          _SummaryRow('Dirección', (job?.address?.isNotEmpty ?? false) ? job!.address! : 'Sin dirección'),
                          const SizedBox(height: 6),
                          _SummaryRow('Acordado', agreedLabel, valueColor: AppColors.cercaPrimary, bold: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // The client does not drive the timeline. `advance` is the
            // assigned technician's action (they are the only one who can
            // attest the work happened), and the backend refuses it from
            // anyone else. This screen shows progress and offers the two
            // things a client can actually do: chat, and pay/rate.
            // See GAP-15.
            // Rating before the work happened would corrupt the technician's
            // reputation, so the CTA unlocks only once the technician marks
            // the job finished — and says why until then.
            if (job?.isCompleted != true)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Text(
                  'Podrás calificar cuando el técnico marque el trabajo como terminado.',
                  textAlign: TextAlign.center,
                  style: CercaText.sora(fontSize: 12, color: AppColors.cercaTextSecondary, height: 1.4),
                ),
              ),
            PrimaryActionButton(
              label: 'Calificar el trabajo',
              enabled: job?.isCompleted == true,
              onTap: () => context.push(RoutePaths.jobRating),
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
    // The value wraps under its own column: titles and addresses are real
    // user text now and run long.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaTextSecondary)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: CercaText.sora(fontSize: 12.5, fontWeight: bold ? FontWeight.w700 : FontWeight.w600, color: valueColor),
          ),
        ),
      ],
    );
  }
}
