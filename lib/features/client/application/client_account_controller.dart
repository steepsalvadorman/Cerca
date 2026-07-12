import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/network_providers.dart';
import '../data/client_repository.dart';
import '../domain/client_address.dart';
import '../domain/client_payment_method.dart';

part 'client_account_controller.g.dart';

@riverpod
ClientRepository clientRepository(Ref ref) => ClientRepository(ref.watch(apiClientProvider));

class ClientAccountData {
  const ClientAccountData({required this.addresses, required this.paymentMethods});

  final List<ClientAddress> addresses;
  final List<ClientPaymentMethod> paymentMethods;
}

/// Backs `client_account_screen`: the caller's saved addresses and
/// payment methods (`GET/POST /client/addresses`, `/client/payment-methods`).
@riverpod
class ClientAccountController extends _$ClientAccountController {
  @override
  Future<ClientAccountData> build() async {
    final repo = ref.read(clientRepositoryProvider);
    final results = await (repo.getAddresses(), repo.getPaymentMethods()).wait;
    return ClientAccountData(addresses: results.$1, paymentMethods: results.$2);
  }

  Future<void> addAddress({required String label, required String detail}) async {
    final repo = ref.read(clientRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repo.addAddress(label: label, detail: detail);
      final results = await (repo.getAddresses(), repo.getPaymentMethods()).wait;
      return ClientAccountData(addresses: results.$1, paymentMethods: results.$2);
    });
  }

  Future<void> addPaymentMethod({required String label, required String detail}) async {
    final repo = ref.read(clientRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repo.addPaymentMethod(label: label, detail: detail);
      final results = await (repo.getAddresses(), repo.getPaymentMethods()).wait;
      return ClientAccountData(addresses: results.$1, paymentMethods: results.$2);
    });
  }
}
