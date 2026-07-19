import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/job_repository.dart';
import 'job_session_controller.dart';

part 'technician_jobs_controller.g.dart';

/// The signed-in technician's job inbox: jobs assigned to them plus
/// bidding-kind jobs still open for an offer (`GET /technician/jobs`).
@riverpod
class TechnicianJobsController extends _$TechnicianJobsController {
  @override
  Future<TechnicianJobsBundle> build() => ref.read(jobRepositoryProvider).getTechnicianJobs();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(jobRepositoryProvider).getTechnicianJobs());
  }

  Future<void> submitOffer(String jobId, {required int price, required String eta}) async {
    await ref.read(jobRepositoryProvider).submitOffer(jobId, price: price, eta: eta);
    await refresh();
  }
}
