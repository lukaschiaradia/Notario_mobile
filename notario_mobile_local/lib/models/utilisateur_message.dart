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
  final String id; // Gardez ceci comme final, car l'ID ne devrait pas changer
  final String sender; // Idem, l'expéditeur ne change pas
  final String receiver; // Idem pour le destinataire
  String text;  // Supprimez `final` pour rendre cette propriété mutable
  final DateTime createdAt;

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
      id: json['uid'],
      sender: json['sender'],
      receiver: json['receiver'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

