import '../../cerca/application/cerca_format.dart';
import '../../technician/data/technician_repository.dart';
import '../domain/job_request.dart';

/// Human-readable "what was agreed" label for a job, shown on the tracking
/// and rating screens. Differs by job kind: only bidding jobs record a
/// single agreed price (the chosen offer's), direct jobs are cash-negotiated
/// outside the app, and project pricing is derived from the team's cost
/// breakdown plus the client's mobility choice.
String agreedPriceLabel(JobRequest? job, ProvidersPage? providersPage) {
  if (job == null || providersPage == null) return 'Por confirmar';
  switch (job.jobKind) {
    case 'bidding':
      return job.agreedPrice != null ? formatClp(job.agreedPrice!) : 'Por confirmar';
    case 'project':
      for (final t in providersPage.teams) {
        if (t.id == job.techTeamId) {
          final mobility = job.mobilityIncluded ? t.mobilityCost : 0;
          return formatClp(t.laborCost + t.materialsCost + mobility);
        }
      }
      return 'Por confirmar';
    case 'direct':
      return 'Directo con el técnico';
    default:
      return 'Por confirmar';
  }
}
