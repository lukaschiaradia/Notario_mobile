import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notario_mobile/api/api.dart';
import 'package:notario_mobile/models/utilisateur_message.dart';
import 'package:notario_mobile/utils/constants/contants_url.dart';


class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  final List<ChatMessage> messages = [];
  TextEditingController _textController = TextEditingController();
  late Future<int> notaryIdFuture;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    notaryIdFuture = _initNotary();
    loadChatId();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => loadChatId());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<int> _initNotary() async {
    var notary = await api_get_notary();
    return notary['user_id'];
  }

  Future<void> loadChatId() async {
    try {
      List<String> chatIdData = await api_get_chat_id();
      String id = chatIdData[0];
      await loadMessages(id);
    } catch (e) {
      print('Erreur lors du chargement de l\'identifiant du chat: $e');
    }
  }

  Future<void> loadMessages(String chatId) async {
    try {
      var chatData = await api_get_chat_with_notaire(idChat: chatId);
      setState(() {
        messages.clear(); // Vider la liste des messages
        for (var messageData in chatData) {
          messages.add(ChatMessage.fromJson(messageData));
        }
      });
    } catch (e) {
      print('Erreur lors du chargement des messages: $e');
      // Gérer l'erreur ici
    }
  }

  Future<void> _sendMessage(String sender, int notaryId) async {
    if (_textController.text.isNotEmpty) {
      api_add_message(receiver: notaryId, message: _textController.text);
      setState(() {
        messages.insert(
            0,
            ChatMessage(
                id: messages.length,
                read: false,
                text: _textController.text,
                createdAt: DateTime.now(),
                sender: int.parse(sender),
                receiver: notaryId,
                chat: 1));
        _textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var reversedMessages = messages.reversed.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: reversedMessages.length,
              itemBuilder: (context, index) {
                bool isUserMessage;

                if (reversedMessages[index].sender.toString() == myId)
                  isUserMessage = true;
                else
                  isUserMessage = false;
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isUserMessage ? 'Vous' : 'Votre notaire',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isUserMessage ? Colors.red : Colors.blueGrey,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        child: ListTile(
                          title: Text(
                            reversedMessages[index].text,
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            DateFormat('hh:mm a')
                                .format(reversedMessages[index].createdAt),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(hintText: 'Send a message'),
                  ),
                ),
                FutureBuilder(
                  future: notaryIdFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return IconButton(
                        icon: Icon(Icons.send, color: Colors.blueGrey),
                        onPressed: () => _sendMessage(myId, snapshot.data!),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
