// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_account_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clientRepository)
final clientRepositoryProvider = ClientRepositoryProvider._();

final class ClientRepositoryProvider
    extends
        $FunctionalProvider<
          ClientRepository,
          ClientRepository,
          ClientRepository
        >
    with $Provider<ClientRepository> {
  ClientRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientRepositoryHash();

  @$internal
  @override
  $ProviderElement<ClientRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClientRepository create(Ref ref) {
    return clientRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClientRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClientRepository>(value),
    );
  }
}

String _$clientRepositoryHash() => r'320e0851f62f3f16eecd0506417249ca4fa94a07';

/// Backs `client_account_screen`: the caller's saved addresses and
/// payment methods (`GET/POST /client/addresses`, `/client/payment-methods`).

@ProviderFor(ClientAccountController)
final clientAccountControllerProvider = ClientAccountControllerProvider._();

/// Backs `client_account_screen`: the caller's saved addresses and
/// payment methods (`GET/POST /client/addresses`, `/client/payment-methods`).
final class ClientAccountControllerProvider
    extends $AsyncNotifierProvider<ClientAccountController, ClientAccountData> {
  /// Backs `client_account_screen`: the caller's saved addresses and
  /// payment methods (`GET/POST /client/addresses`, `/client/payment-methods`).
  ClientAccountControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientAccountControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientAccountControllerHash();

  @$internal
  @override
  ClientAccountController create() => ClientAccountController();
}

String _$clientAccountControllerHash() =>
    r'df7582d137a26c0f23300d8ef7fa01017fa04c95';

/// Backs `client_account_screen`: the caller's saved addresses and
/// payment methods (`GET/POST /client/addresses`, `/client/payment-methods`).

abstract class _$ClientAccountController
    extends $AsyncNotifier<ClientAccountData> {
  FutureOr<ClientAccountData> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ClientAccountData>, ClientAccountData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ClientAccountData>, ClientAccountData>,
              AsyncValue<ClientAccountData>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
