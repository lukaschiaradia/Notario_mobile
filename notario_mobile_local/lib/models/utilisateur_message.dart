class Message {
  final String sender;
  final String text;
  final DateTime time;

  Message({required this.sender, required this.text, required this.time});
}

class ChatMessage {
  final int id;
  final bool read;
  final String text;
  final DateTime createdAt;
  final int sender;
  final int receiver;
  final int chat;

  ChatMessage({
    required this.id,
    required this.read,
    required this.text,
    required this.createdAt,
    required this.sender,
    required this.receiver,
    required this.chat,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      read: json['read'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
      sender: json['sender'],
      receiver: json['receiver'],
      chat: json['chat'],
    );
  }
}
