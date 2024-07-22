class ChatMessage {
  String id;
  String text;
  DateTime sentAt;
  String to;
  String from;
  bool isSeen;

  ChatMessage({
    required this.id,
    required this.text,
    required this.sentAt,
    required this.to,
    required this.from,
    this.isSeen = false,
  });
}
