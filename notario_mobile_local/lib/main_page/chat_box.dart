import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notario_mobile/api/api.dart';
import 'package:notario_mobile/models/utilisateur_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatMessage> messages = []; // Utilisez ChatMessage ici
  TextEditingController _textController = TextEditingController();
  late Future<int> notaryIdFuture;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    notaryIdFuture = _initNotary();
    loadMessages();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      loadMessages();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<int> _initNotary() async {
    var notary = await api_get_notary();
    return notary['user_id'];
  }

  Future<void> loadMessages() async {
    var chatData = await api_get_chat_with_notaire(idChat: 1);
    for (var messageData in chatData) {
      messages.add(ChatMessage.fromJson(
          messageData)); // Utilisez ChatMessage.fromJson ici
    }
    setState(
        () {}); // Met à jour l'interface utilisateur après le chargement des messages
  }

  Future<void> _sendMessage(String sender, int notaryId) async {
    if (_textController.text.isNotEmpty) {
      api_add_message(receiver: notaryId, message: _textController.text);
      setState(() {
        messages.insert(
            0,
            ChatMessage(
                // Utilisez ChatMessage ici
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(messages[index].sender.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                  title: Text(messages[index].text,
                      style: TextStyle(color: Colors.black)),
                  subtitle: Text(
                      DateFormat('hh:mm a').format(messages[index].createdAt),
                      style: TextStyle(color: Colors.grey)),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(hintText: 'Send a message'),
                  ),
                ),
                FutureBuilder<int>(
                  future: notaryIdFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return IconButton(
                        icon: Icon(Icons.send, color: Colors.blueGrey),
                        onPressed: () =>
                            _sendMessage('Your Name', snapshot.data!),
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