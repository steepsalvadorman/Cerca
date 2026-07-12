import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/network_providers.dart';
import '../data/technician_repository.dart';

part 'providers_controller.g.dart';

@riverpod
TechnicianRepository technicianRepository(Ref ref) => TechnicianRepository(ref.watch(apiClientProvider));

/// Home screen's technician/team listing (`GET /providers`).
@riverpod
class ProvidersController extends _$ProvidersController {
  @override
  Future<ProvidersPage> build() => ref.read(technicianRepositoryProvider).getProviders();
}
