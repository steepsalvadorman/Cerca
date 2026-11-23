import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/job_repository.dart';
import '../domain/job_request.dart';
import 'job_session_controller.dart';

part 'active_job_controller.g.dart';

/// The job the client is currently walking through, resolved from
/// [JobSessionController]'s id. `null` while no job has been created yet.
@riverpod
class ActiveJobController extends _$ActiveJobController {
  @override
  Future<JobRequest?> build() async {
    final jobId = ref.watch(jobSessionControllerProvider);
    if (jobId == null) return null;

    // The technician drives the timeline from their phone; without
    // re-reading the job the client never sees "En camino" or the rating
    // unlock. Polls only while someone watches (autoDispose) and stops
    // once the job can no longer change.
    final timer = Timer.periodic(const Duration(seconds: 10), (_) => _pollOnce(jobId));
    ref.onDispose(timer.cancel);

    return ref.read(jobRepositoryProvider).getJob(jobId);
  }

  Future<void> _pollOnce(String jobId) async {
    final current = state.value;
    if (state.isLoading || current == null || current.isCompleted || current.isCancelled) return;
    try {
      final fresh = await ref.read(jobRepositoryProvider).getJob(jobId);
      if (ref.read(jobSessionControllerProvider) == jobId) state = AsyncData(fresh);
    } catch (_) {
      // A missed poll keeps the last known state; the next tick retries.
    }
  }

  Future<void> _refresh() async {
    final jobId = ref.read(jobSessionControllerProvider);
    if (jobId == null) return;
    state = await AsyncValue.guard(() => ref.read(jobRepositoryProvider).getJob(jobId));
  }

  Future<PayFeeResult?> payFee(String paymentMethod) async {
    final jobId = ref.read(jobSessionControllerProvider);
    if (jobId == null) return null;
    state = const AsyncLoading();
    final result = await ref.read(jobRepositoryProvider).payFee(jobId, paymentMethod);
    await _refresh();
    return result;
  }

  Future<void> advance() async {
    final jobId = ref.read(jobSessionControllerProvider);
    if (jobId == null) return;
    await ref.read(jobRepositoryProvider).advance(jobId);
    await _refresh();
  }

  Future<void> rate(int rating, {String? comment}) async {
    final jobId = ref.read(jobSessionControllerProvider);
    if (jobId == null) return;
    state = const AsyncLoading();
    await ref.read(jobRepositoryProvider).rate(jobId, rating, comment: comment);
    await _refresh();
  }

  Future<void> chooseOffer(int offerId) async {
    final jobId = ref.read(jobSessionControllerProvider);
    if (jobId == null) return;
    state = const AsyncLoading();
    await ref.read(jobRepositoryProvider).chooseOffer(jobId, offerId);
    await _refresh();
  }
}
