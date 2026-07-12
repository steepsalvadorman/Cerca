// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String,
  jobRequestId: json['job_request_id'] as String,
  senderId: json['sender_id'] as String,
  senderRole: json['sender_role'] as String,
  text: json['text'] as String,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'job_request_id': instance.jobRequestId,
      'sender_id': instance.senderId,
      'sender_role': instance.senderRole,
      'text': instance.text,
      'created_at': instance.createdAt,
    };
