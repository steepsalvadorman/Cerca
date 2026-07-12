// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_job_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The job the client is currently walking through, resolved from
/// [JobSessionController]'s id. `null` while no job has been created yet.

@ProviderFor(ActiveJobController)
final activeJobControllerProvider = ActiveJobControllerProvider._();

/// The job the client is currently walking through, resolved from
/// [JobSessionController]'s id. `null` while no job has been created yet.
final class ActiveJobControllerProvider
    extends $AsyncNotifierProvider<ActiveJobController, JobRequest?> {
  /// The job the client is currently walking through, resolved from
  /// [JobSessionController]'s id. `null` while no job has been created yet.
  ActiveJobControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeJobControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeJobControllerHash();

  @$internal
  @override
  ActiveJobController create() => ActiveJobController();
}

String _$activeJobControllerHash() =>
    r'75ebe532371df1d21e7a7f5eb5337f1aa978c69a';

/// The job the client is currently walking through, resolved from
/// [JobSessionController]'s id. `null` while no job has been created yet.

abstract class _$ActiveJobController extends $AsyncNotifier<JobRequest?> {
  FutureOr<JobRequest?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<JobRequest?>, JobRequest?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<JobRequest?>, JobRequest?>,
              AsyncValue<JobRequest?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
