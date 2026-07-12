import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/job_offer.dart';
import 'job_session_controller.dart';

part 'offers_controller.g.dart';

/// Polls `GET /jobs/{id}/offers` every few seconds while a bidding job's
/// offer list is on screen — the backend has no push/websocket support,
/// so this is the simplest way to reflect new technician bids.
@riverpod
Stream<List<JobOffer>> jobOffers(Ref ref, String jobId) async* {
  final repo = ref.watch(jobRepositoryProvider);
  while (true) {
    yield await repo.getOffers(jobId);
    await Future<void>.delayed(const Duration(seconds: 4));
  }
}
