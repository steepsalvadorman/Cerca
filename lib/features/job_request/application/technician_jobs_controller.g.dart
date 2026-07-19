// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technician_jobs_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The signed-in technician's job inbox: jobs assigned to them plus
/// bidding-kind jobs still open for an offer (`GET /technician/jobs`).

@ProviderFor(TechnicianJobsController)
final technicianJobsControllerProvider = TechnicianJobsControllerProvider._();

/// The signed-in technician's job inbox: jobs assigned to them plus
/// bidding-kind jobs still open for an offer (`GET /technician/jobs`).
final class TechnicianJobsControllerProvider
    extends
        $AsyncNotifierProvider<TechnicianJobsController, TechnicianJobsBundle> {
  /// The signed-in technician's job inbox: jobs assigned to them plus
  /// bidding-kind jobs still open for an offer (`GET /technician/jobs`).
  TechnicianJobsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'technicianJobsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$technicianJobsControllerHash();

  @$internal
  @override
  TechnicianJobsController create() => TechnicianJobsController();
}

String _$technicianJobsControllerHash() =>
    r'72f9e7e48e0fd8e63a9b2f9b2c736c73b9097b50';

/// The signed-in technician's job inbox: jobs assigned to them plus
/// bidding-kind jobs still open for an offer (`GET /technician/jobs`).

abstract class _$TechnicianJobsController
    extends $AsyncNotifier<TechnicianJobsBundle> {
  FutureOr<TechnicianJobsBundle> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<TechnicianJobsBundle>, TechnicianJobsBundle>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<TechnicianJobsBundle>,
                TechnicianJobsBundle
              >,
              AsyncValue<TechnicianJobsBundle>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
