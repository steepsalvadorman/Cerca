// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_history_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The signed-in client's past requests (`GET /client/history`), shown on
/// `client_account_screen`.

@ProviderFor(clientHistory)
final clientHistoryProvider = ClientHistoryProvider._();

/// The signed-in client's past requests (`GET /client/history`), shown on
/// `client_account_screen`.

final class ClientHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<JobRequest>>,
          List<JobRequest>,
          FutureOr<List<JobRequest>>
        >
    with $FutureModifier<List<JobRequest>>, $FutureProvider<List<JobRequest>> {
  /// The signed-in client's past requests (`GET /client/history`), shown on
  /// `client_account_screen`.
  ClientHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clientHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clientHistoryHash();

  @$internal
  @override
  $FutureProviderElement<List<JobRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<JobRequest>> create(Ref ref) {
    return clientHistory(ref);
  }
}

String _$clientHistoryHash() => r'40060fe80cae47b93ded3532b28d9373505458a5';
