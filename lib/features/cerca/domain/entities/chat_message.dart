enum ChatSender { technician, user }

class ChatMessageEntry {
  const ChatMessageEntry({required this.from, required this.text});

  final ChatSender from;
  final String text;
}
