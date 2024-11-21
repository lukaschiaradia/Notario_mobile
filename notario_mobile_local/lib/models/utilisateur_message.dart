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
  final String id; // L'ID du message
  final String sender; // Expéditeur
  final String receiver; // Destinataire
  String text; // Texte mutable
  final DateTime createdAt; // Date de création

  ChatMessage({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.createdAt,
  });

  // Factory pour créer un ChatMessage à partir d'un JSON
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

