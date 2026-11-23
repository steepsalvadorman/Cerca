import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/network_providers.dart';
import '../../auth/application/auth_controller.dart';
import '../data/job_repository.dart';

part 'job_session_controller.g.dart';

class ServiceRequestDraft {
  const ServiceRequestDraft({this.categoryId, this.categoryLabel, this.description = '', this.address});

  final String? categoryId;
  final String? categoryLabel;
  final String description;

  /// Where the job happens. Without it the technician has nowhere to go,
  /// so no job is created until one is chosen.
  final String? address;

  bool get isComplete => categoryId != null && description.trim().isNotEmpty;
  String get title => '${categoryLabel ?? 'Servicio'}: ${description.trim()}';
}

class ServiceRequestDraftController extends Notifier<ServiceRequestDraft> {
  @override
  ServiceRequestDraft build() {
    // Not auto-disposed: without this, the previous account's address and
    // job description survived a logout and pre-filled the next account's
    // request on the same device (security audit run-1).
    ref.listen(authControllerProvider, (_, next) {
      if (next.value == null) clear();
    });
    return const ServiceRequestDraft();
  }

  void save({
    required String categoryId,
    required String categoryLabel,
    required String description,
    String? address,
  }) {
    state = ServiceRequestDraft(
      categoryId: categoryId,
      categoryLabel: categoryLabel,
      description: description.trim(),
      address: address ?? state.address,
    );
  }

  void setAddress(String address) => state = ServiceRequestDraft(
        categoryId: state.categoryId,
        categoryLabel: state.categoryLabel,
        description: state.description,
        address: address,
      );

  void clear() => state = const ServiceRequestDraft();
}

final serviceRequestDraftProvider =
    NotifierProvider<ServiceRequestDraftController, ServiceRequestDraft>(ServiceRequestDraftController.new);

@Riverpod(keepAlive: true)
JobRepository jobRepository(Ref ref) => JobRepository(ref.watch(apiClientProvider));

/// Bridges the app's single-shared-session UI flow (CercaController) into
/// the backend's job-id-keyed model: holds the id of whichever job the
/// client is currently walking through (bidding → fee → tracking →
/// rating), set once a `job_requests` row is actually created.
@Riverpod(keepAlive: true)
class JobSessionController extends _$JobSessionController {
  @override
  String? build() {
    // Being keepAlive, this survives sign-out on its own, and the next
    // account would inherit the previous one's active job.
    ref.listen(authControllerProvider, (_, next) {
      if (next.value == null) clear();
    });
    return null;
  }

  void setJobId(String jobId) => state = jobId;

  void clear() => state = null;
}
