import 'package:order_up/models/chat_message.dart';

class Chat {
  String id;
  String? secondUserId;
  ChatUser? chatUser;
  List<ChatMessage> chatMessages;

  Chat({
    required this.id,
    required this.chatMessages,
    this.secondUserId,
    this.chatUser,
  });

  DateTime get lastMessageTime {
    return chatMessages
        .map((msg) => msg.sentAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);
  }
}

class ChatUser {
  String name;
  String imageUrl = '';

  ChatUser({
    required this.name,
    required this.imageUrl,
  });
}
