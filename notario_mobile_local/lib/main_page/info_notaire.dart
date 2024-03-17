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
        title: Text('Notary Information'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text(
              'Information Notaire',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Phone Number: $profil_phone',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Email: $profil_email',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Adresse: $profil_adresse',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'First Name: $profil_firstName',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Last Name: $profil_lastName',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}