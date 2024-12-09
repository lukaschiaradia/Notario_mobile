class AddMessage {
  final String receiver;
  final String text;
  final int? replyTo;

  AddMessage({
    required this.receiver,
    required this.text,
    this.replyTo,
  });

  Map<String, dynamic> toJson() {
    return {
      'receiver': receiver,
      'text': text,
      'reply_to': replyTo,
    };
  }
}


class ChatMessage {
  final String id;
  final String sender;
  final String receiver;
  String text;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['uid'] ?? 'unknown-id', // Valeur par défaut pour l'ID
      sender: json['sender'] ?? 'unknown-sender', // Valeur par défaut pour l'expéditeur
      receiver: json['receiver'] ?? 'unknown-receiver', // Valeur par défaut pour le destinataire
      text: json['text'] ?? '', // Texte par défaut vide si non fourni
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(), // Date actuelle si parsing échoue
    );
  }
}

