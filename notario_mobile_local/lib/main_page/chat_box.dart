import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notario_mobile/api/api.dart';
import 'package:notario_mobile/api/api_auth.dart';
import 'package:notario_mobile/models/utilisateur_message.dart';
import 'package:notario_mobile/utils/constants/contants_url.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // ScrollController ajouté
  List<ChatMessage> messages = [];
  late Future<String> chatUidFuture;
  late Future<String> notaryIdFuture;

  String myId = ''; // ID de l'utilisateur

  @override
  void initState() {
    super.initState();
    notaryIdFuture = _initNotary();
    _initMyId();
    chatUidFuture = api_get_chat_id();
    _loadChat();
  }

  Future<String> _initNotary() async {
    var notary = await api_get_notary();
    return notary['user_id']
        .toString(); // Retourner l'ID du notaire en tant que chaîne
  }

  Future<String> _initMyId() async {
    var userInfo =
        await getUserInfo(); // Appel de l'API pour obtenir les infos utilisateur
    String uid = userInfo['user']['uid']; // Extraction de l'UID de la réponse
    myId = uid;
    return uid;
  }

  Future<void> _loadChat() async {
    try {
      String chatUid = await chatUidFuture; // Attendre l'UID du chat
      Map<String, dynamic> chatDetails = await api_get_chat_details(chatUid);

      // Extraire les messages de la réponse
      List<dynamic> messagesData = chatDetails['data'];
      setState(() {
        messages = messagesData
            .map((messageData) => ChatMessage.fromJson(messageData))
            .toList()
            .reversed
            .toList(); // Inverser les messages pour afficher les plus récents en bas

        _scrollToBottom(); // Faire défiler automatiquement après le chargement
      });
    } catch (e) {
      print('Erreur lors du chargement du chat: $e');
    }
  }

  Future<void> _sendMessage(String notaryId) async {
    if (_textController.text.isNotEmpty) {
      String receiver = notaryId; // ID du notaire
      String messageText = _textController.text; // Texte du message

      // Créez une instance de AddMessage
      AddMessage message = AddMessage(
        receiver: receiver,
        text: messageText,
      );

      try {
        await api_add_message(message); // Envoyer le message
        _textController.clear(); // Effacer le champ de texte après l'envoi
        _loadChat(); // Recharger les messages après envoi
      } catch (e) {
        print('Erreur lors de l\'envoi du message: $e');
      }
    }
  }

  // Fonction pour éditer un message
  void _editMessage(ChatMessage message) {
    // Exemple d'implémentation : afficher une boîte de dialogue pour modifier le message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController editController =
            TextEditingController(text: message.text);
        return AlertDialog(
          title: Text('Modifier le message'),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(hintText: "Éditez votre message"),
          ),
          actions: [
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Sauvegarder"),
              onPressed: () {
                // Logique de mise à jour du message
                setState(() {
                  message.text = editController.text;
                  // Ajouter la logique pour sauvegarder la modification
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Fonction pour supprimer un message
  void _deleteMessage(ChatMessage message) async {
    try {
      // Appel de la fonction de suppression avec l'UID du message
      print(message.id);
      await apiDeleteMessage(messageUid: message.id);
      setState(() {
        messages.remove(message); // Supprimer le message de la liste localement
      });
    } catch (e) {
      print('Erreur lors de la suppression du message : $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Attacher le ScrollController
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];

                bool isUserMessage = message.sender == myId;
                bool isNotaryMessage = message.sender != myId;

                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isUserMessage
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: isUserMessage
                              ? Colors.blue[100]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Afficher le nom de l'expéditeur
                            Text(
                              isUserMessage
                                  ? 'Moi'
                                  : 'Notaire', // Afficher "Moi" pour l'utilisateur, "Notaire" pour le notaire
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isUserMessage ? Colors.blue : Colors.red,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              message.text,
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              DateFormat('HH:mm').format(message.createdAt),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      if (isUserMessage) // N'affichez les boutons que pour l'utilisateur
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              iconSize: 14, // Taille réduite
                              onPressed: () => _editMessage(message),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              iconSize: 14, // Taille réduite
                              onPressed: () => _deleteMessage(message),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          FutureBuilder<String>(
            future: notaryIdFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erreur lors du chargement du notaire');
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: 'Envoyer un message',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () => _sendMessage(snapshot.data!),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
