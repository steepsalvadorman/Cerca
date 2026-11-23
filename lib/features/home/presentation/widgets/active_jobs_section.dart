import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cerca/application/cerca_seed_data.dart';
import '../../../cerca/presentation/widgets/cerca_text_styles.dart';
import '../../../job_request/application/client_history_controller.dart';
import '../../../job_request/application/job_session_controller.dart';
import '../../../job_request/domain/job_request.dart';

/// "En curso" on the client's home: every pending or active request, so
/// leaving the tracking screen never loses the job. Hidden when there is
/// nothing in progress.
class ActiveJobsSection extends ConsumerWidget {
  const ActiveJobsSection({super.key});

  static bool _inProgress(JobRequest job) => job.isPending || job.isActive;

  static String _statusLabel(JobRequest job) {
    if (job.isPending) {
      return job.jobKind == 'bidding' ? 'Esperando ofertas' : 'Esperando respuesta del técnico';
    }
    for (final step in CercaSeedData.timelineSteps) {
      if (step.step == job.timelineStep) return step.label;
    }
    return 'En curso';
  }

  void _open(BuildContext context, WidgetRef ref, JobRequest job) {
    ref.read(jobSessionControllerProvider.notifier).setJobId(job.id);
    final waitingForOffers = job.jobKind == 'bidding' && job.isPending && job.technicianProfileId == null;
    context.push(waitingForOffers ? RoutePaths.jobBidding : RoutePaths.tracking);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = (ref.watch(clientHistoryProvider).value ?? const <JobRequest>[]).where(_inProgress).toList();
    if (jobs.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text('En curso', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 8),
          for (final job in jobs)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: AppColors.cercaSurfaceTint,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Color(0xFFEAD6D2)),
                ),
                child: InkWell(
                  onTap: () => _open(context, ref, job),
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (job.title?.isNotEmpty ?? false) ? job.title! : 'Solicitud',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _statusLabel(job),
                                style: CercaText.sora(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.cercaPrimary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.cercaPrimary),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
