import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/network_providers.dart';
import '../data/chat_repository.dart';
import '../domain/chat_message.dart';

part 'chat_controller.g.dart';

@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) => ChatRepository(ref.watch(apiClientProvider));

/// Polls `GET /jobs/{id}/messages` every few seconds while a chat is on
/// screen — the backend has no push/websocket support.
@riverpod
Stream<List<ChatMessage>> chatMessages(Ref ref, String jobId) async* {
  final repo = ref.watch(chatRepositoryProvider);
  while (true) {
    yield await repo.getMessages(jobId);
    await Future<void>.delayed(const Duration(seconds: 3));
  }
}
