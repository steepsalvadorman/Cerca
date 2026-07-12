import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../domain/chat_message.dart';

/// Talks to the `chat` feature of the backend (`/jobs/{id}/messages`).
class ChatRepository {
  ChatRepository(this._dio);

  final Dio _dio;

  Future<List<ChatMessage>> getMessages(String jobId) async {
    try {
      final response = await _dio.get('/jobs/$jobId/messages');
      return (response.data as List).map((e) => ChatMessage.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw apiExceptionOf(e);
    }
  }

  Future<ChatMessage> sendMessage(String jobId, {required String senderRole, required String text}) async {
    try {
      final response = await _dio.post('/jobs/$jobId/messages', data: {'sender_role': senderRole, 'text': text});
      return ChatMessage.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw apiExceptionOf(e);
    }
  }
}
