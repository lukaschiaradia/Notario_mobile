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
  final String id; // ID du message
  final String sender; // ID de l'expéditeur
  final String receiver; // ID du destinataire
  late final String text; // Contenu du message
  final DateTime createdAt; // Date de création

  ChatMessage({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.createdAt,
  });

  // Fonction pour créer un ChatMessage à partir d'un JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['uid'], // Assurez-vous que cela correspond à votre structure
      sender: json['sender'],
      receiver: json['receiver'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']), // Assurez-vous que le format est correct
    );
  }
}
