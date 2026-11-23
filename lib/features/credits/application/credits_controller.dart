import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/network_providers.dart';
import '../data/credits_repository.dart';
import '../data/culqi_tokenizer.dart';
import '../domain/credits_overview.dart';

final creditsRepositoryProvider = Provider<CreditsRepository>(
  (ref) => CreditsRepository(ref.watch(apiClientProvider)),
);

final culqiTokenizerProvider = Provider<CulqiTokenizer>((ref) => CulqiTokenizer());

/// The signed-in technician's wallet, packs and payment configuration.
/// Invalidate it after a purchase, an offer, or a win.
final creditsOverviewProvider = FutureProvider.autoDispose<CreditsOverview>(
  (ref) => ref.watch(creditsRepositoryProvider).getOverview(),
);
