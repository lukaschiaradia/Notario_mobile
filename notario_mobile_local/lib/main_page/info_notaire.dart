import 'package:flutter/material.dart';
import 'package:notario_mobile/api/api.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants/contants_url.dart';

var profil_phone = '';
var profil_firstName = '';
var profil_lastName = '';
var profil_adresse = '';
var profil_email = '';
var profil_photo = '';

class InfoNotairePage extends StatefulWidget {
  @override
  _InfoNotairePageState createState() => _InfoNotairePageState();
}

class _InfoNotairePageState extends State<InfoNotairePage> {
  late Future<Map<String, dynamic>> _notaryInfoFuture;

  @override
  void initState() {
    super.initState();
    _notaryInfoFuture = get_notary_infos();
  }

  Future<Map<String, dynamic>> get_notary_infos() async {
    var notary = await api_get_notary();
    return notary;
  }

  void _contactNotary() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Contacter le notaire"),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _sendEmail();
                },
                child: Text("Mail"),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Annuler"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: profil_email,
      query: Uri.encodeQueryComponent('Bonjour,'),
    );
    await launch(emailLaunchUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information de votre notaire'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _notaryInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erreur de chargement des données'),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text('Aucune donnée disponible'),
              );
            } else {
              var notary = snapshot.data!;
              profil_photo = notary['photo'] ?? '';
              profil_firstName = notary['first_name'] ?? '';
              profil_lastName = notary['last_name'] ?? '';
              profil_email = notary['email'] ?? '';
              profil_phone = notary['phone'] ?? '';
              profil_adresse = notary['address'] ?? '';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: profil_photo.isEmpty
                        ? AssetImage('images/noicon.jpg')
                        : NetworkImage('http://' + ip + profil_photo) as ImageProvider,
                  ),
                  SizedBox(height: 20),
                  Text(
                    profil_firstName + ' ' + profil_lastName,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileInfoItem(
                          title: 'Email',
                          value: profil_email,
                        ),
                        Divider(),
                        ProfileInfoItem(
                          title: 'Téléphone',
                          value: profil_phone,
                        ),
                        Divider(),
                        ProfileInfoItem(
                          title: 'Adresse',
                          value: profil_adresse,
                        ),
                        SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: _contactNotary,
                            child: Text('Contacter'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class ProfileInfoItem extends StatelessWidget {
  final String title;
  final String value;

  const ProfileInfoItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
