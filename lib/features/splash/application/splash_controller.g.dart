// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Placeholder splash "gate": once there is a real session/auth check,
/// this is where it belongs (e.g. reading a persisted token) so the
/// splash screen can decide where to navigate without knowing the details.

@ProviderFor(splashGate)
final splashGateProvider = SplashGateProvider._();

/// Placeholder splash "gate": once there is a real session/auth check,
/// this is where it belongs (e.g. reading a persisted token) so the
/// splash screen can decide where to navigate without knowing the details.

final class SplashGateProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Placeholder splash "gate": once there is a real session/auth check,
  /// this is where it belongs (e.g. reading a persisted token) so the
  /// splash screen can decide where to navigate without knowing the details.
  SplashGateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashGateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashGateHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return splashGate(ref);
  }
}

String _$splashGateHash() => r'ae8af8727a99874284c3f5c04f8c76b9b255cd0f';
