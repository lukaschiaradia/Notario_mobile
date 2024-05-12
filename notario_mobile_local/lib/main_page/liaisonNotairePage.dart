import 'package:flutter/material.dart';
import 'package:notario_mobile/api/api.dart';

class LiaisonNotairePage extends StatefulWidget {
  final List<dynamic> notaires;

  LiaisonNotairePage({required this.notaires});

  @override
  _LiaisonNotairePageState createState() => _LiaisonNotairePageState();
}

class _LiaisonNotairePageState extends State<LiaisonNotairePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des notaires'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.add),
                iconSize: 24.0,
                onPressed: () {
                  api_get_invite_requests();
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.notaires.length,
              itemBuilder: (context, index) {
                var notaire = widget.notaires[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(notaire['first_name'][0]),
                      backgroundColor: const Color.fromARGB(255, 143, 183, 202),
                    ),
                    title: Text(
                      notaire['first_name'] +
                          ' ' +
                          notaire['last_name'] +
                          ' - ' +
                          'City: ' +
                          notaire['city'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        print(notaire['email']);
                        api_link_notary(notary_id: notaire['email']);
                      },
                      child: Text('Lier'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}