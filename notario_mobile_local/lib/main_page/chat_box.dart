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
    print(notary['user_id']);
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
        messages.clear();
        for (var messageData in chatData) {
          messages.add(ChatMessage.fromJson(messageData));
        }
      });
    } catch (e) {
      print('Erreur lors du chargement des messages: $e');
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

  Future<void> _deleteMessage(int messageId) async {
    try {
      await api_delete_message(messageId);
      setState(() {
        messages.removeWhere((msg) => msg.id == messageId);
      });
    } catch (e) {
      print('Erreur lors de la suppression du message: $e');
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
                var message = reversedMessages[index];
                bool isUserMessage = message.sender == int.parse(myId);
                String senderName = isUserMessage ? "Vous" : "Votre notaire";

                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color:
                          isUserMessage ? Colors.green[200] : Colors.blue[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          senderName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isUserMessage
                                ? Colors.green[800]
                                : Colors.blue[800],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          message.text,
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('hh:mm a').format(message.createdAt),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete,
                                  size: 18, color: Colors.red),
                              onPressed: () => _deleteMessage(message.id),
                            ),
                          ],
                        ),
                      ],
                    ),
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
