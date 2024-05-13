import 'package:flutter/material.dart';
import 'package:notario_mobile/api/api.dart';

var profil_phone = '';
var profil_firstName = '';
var profil_lastName = '';
var profil_adresse = '';
var profil_email = '';

void get_notary_infos() async {
    var notary = await api_get_notary();
    profil_phone = notary['phone'];
    profil_adresse = notary['address'];
    profil_firstName = notary['first_name'];
    profil_lastName = notary['last_name'];
    profil_email = notary['email'];
}

class InfoNotairePage extends StatefulWidget {
  @override
  _InfoNotairePageState createState() => _InfoNotairePageState();
}

class _InfoNotairePageState extends State<InfoNotairePage> {
  @override
  void initState() {
    super.initState();
    get_notary_infos();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Information de votre notaire'),
      backgroundColor: Colors.blueGrey,
    ),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          Card(
            color: Colors.blue[50],
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person, color: Colors.white),
                backgroundColor: Colors.blue,
              ),
              title: Text('Prenom'),
              subtitle: Text(profil_firstName),
            ),
          ),
          Card(
            color: Colors.green[50],
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person, color: Colors.white),
                backgroundColor: Colors.green,
              ),
              title: Text('Nom de famille'),
              subtitle: Text(profil_lastName),
            ),
          ),
          Card(
            color: Colors.red[50],
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.phone, color: Colors.white),
                backgroundColor: Colors.red,
              ),
              title: Text('Téléphone'),
              subtitle: Text(profil_phone),
            ),
          ),
          Card(
            color: Colors.purple[50],
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.email, color: Colors.white),
                backgroundColor: Colors.purple,
              ),
              title: Text('Email'),
              subtitle: Text(profil_email),
            ),
          ),
          Card(
            color: Colors.orange[50],
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.home, color: Colors.white),
                backgroundColor: Colors.orange,
              ),
              title: Text('Address'),
              subtitle: Text(profil_adresse),
            ),
          ),
        ],
      ),
    ),
  );
}
}