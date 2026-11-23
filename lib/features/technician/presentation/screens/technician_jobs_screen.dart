import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../cerca/presentation/widgets/cerca_text_styles.dart';
import '../../../job_request/application/job_session_controller.dart';
import '../../../job_request/application/technician_jobs_controller.dart';
import '../../../job_request/domain/job_request.dart';

class TechnicianJobsScreen extends ConsumerWidget {
  const TechnicianJobsScreen({super.key});

  void _open(BuildContext context, WidgetRef ref, JobRequest job) {
    ref.read(jobSessionControllerProvider.notifier).setJobId(job.id);
    context.push(RoutePaths.technicianJobDetail);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(authControllerProvider).value?.user.name.trim().split(' ').first ?? '';
    final jobsAsync = ref.watch(technicianJobsControllerProvider);
    final jobs = jobsAsync.value;

    return Scaffold(
      backgroundColor: AppColors.cercaBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hola, $userName', style: CercaText.sora(fontSize: 13, color: AppColors.cercaTextSecondary)),
                        const SizedBox(height: 2),
                        Text('Tus trabajos', style: CercaText.lora(fontSize: 20)),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(technicianJobsControllerProvider.notifier).refresh(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (jobsAsync.isLoading && jobs == null)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (jobsAsync.hasError && jobs == null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No se pudieron cargar tus trabajos. Revisa tu conexión e inténtalo de nuevo.',
                                style: CercaText.sora(fontSize: 13, color: AppColors.cercaTextSecondary),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: () => ref.read(technicianJobsControllerProvider.notifier).refresh(),
                                icon: const Icon(Icons.refresh_rounded, size: 18),
                                label: const Text('Reintentar'),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(0, 48),
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                ),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        Text('Trabajos asignados', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        if ((jobs?.assigned ?? const []).isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text('Aún no tienes trabajos asignados.', style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaTextSecondary)),
                          )
                        else
                          for (final job in jobs!.assigned) _JobCard(job: job, onTap: () => _open(context, ref, job)),
                        const SizedBox(height: 16),
                        Text('Solicitudes abiertas a licitación', style: CercaText.sora(fontSize: 13.5, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        if ((jobs?.openForBid ?? const []).isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text('No hay solicitudes abiertas por ahora.', style: CercaText.sora(fontSize: 12.5, color: AppColors.cercaTextSecondary)),
                          )
                        else
                          for (final job in jobs!.openForBid) _JobCard(job: job, onTap: () => _open(context, ref, job)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  const _JobCard({required this.job, required this.onTap});
  final JobRequest job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.cercaBorder),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job.title?.isNotEmpty == true ? job.title! : job.kindLabel, style: CercaText.sora(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(
                    job.address?.isNotEmpty == true ? job.address! : job.kindLabel,
                    style: CercaText.sora(fontSize: 11.5, color: AppColors.cercaTextSecondary),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(color: AppColors.cercaSurfaceTint, borderRadius: BorderRadius.circular(20)),
              child: Text(job.statusLabel, style: CercaText.sora(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.cercaPrimary)),
            ),
          ],
        ),
      ),
    );
  }
}
