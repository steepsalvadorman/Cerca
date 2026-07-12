// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(technicianRepository)
final technicianRepositoryProvider = TechnicianRepositoryProvider._();

final class TechnicianRepositoryProvider
    extends
        $FunctionalProvider<
          TechnicianRepository,
          TechnicianRepository,
          TechnicianRepository
        >
    with $Provider<TechnicianRepository> {
  TechnicianRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'technicianRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$technicianRepositoryHash();

  @$internal
  @override
  $ProviderElement<TechnicianRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TechnicianRepository create(Ref ref) {
    return technicianRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TechnicianRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TechnicianRepository>(value),
    );
  }
}

String _$technicianRepositoryHash() =>
    r'891b0ef8668d2836c6dc4135d8388246e17b01c2';

/// Home screen's technician/team listing (`GET /providers`).

@ProviderFor(ProvidersController)
final providersControllerProvider = ProvidersControllerProvider._();

/// Home screen's technician/team listing (`GET /providers`).
final class ProvidersControllerProvider
    extends $AsyncNotifierProvider<ProvidersController, ProvidersPage> {
  /// Home screen's technician/team listing (`GET /providers`).
  ProvidersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'providersControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$providersControllerHash();

  @$internal
  @override
  ProvidersController create() => ProvidersController();
}

String _$providersControllerHash() =>
    r'db61d689e9768d8a5a2b8765850de5ef977d9c7c';

/// Home screen's technician/team listing (`GET /providers`).

abstract class _$ProvidersController extends $AsyncNotifier<ProvidersPage> {
  FutureOr<ProvidersPage> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ProvidersPage>, ProvidersPage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProvidersPage>, ProvidersPage>,
              AsyncValue<ProvidersPage>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
