import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notario_mobile/api/api_auth.dart';
import 'package:notario_mobile/login/connexion_page.dart';
import 'package:notario_mobile/models/utilisateur_modif.dart';
import 'package:notario_mobile/utils/constants/contants_url.dart';
import '../welcome_page.dart';
import 'bottomNavBar.dart';
import '../models/utilisateur_delete.dart';
import 'document_page.dart';
import '../api/api.dart';

var profil_phone = '';
var profil_firstName = '';
var profil_lastName = '';
int profil_age = 0;
var profil_email = '';

void get_user_infos() async {
  var user = await getUserInfo();
  profil_phone = user['user']['phone'];
  profil_firstName = user['user']['first_name'];
  profil_lastName = user['user']['last_name'];
  profil_age = user['user']['age'];
  profil_email = user['user']['email'];
}

class Profil extends StatefulWidget {
  const Profil({super.key});
  
  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  void initState() {
    super.initState();
    get_user_infos();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: null,
            ),
            ListTile(
              title: Text('Document'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DocumentPage()));
              },
            ),
            ListTile(
                title: Text('Modifier mes infos'),
                onTap: () {
                  _showEditDialog(context);
                }),
            ListTile(
                title: Text('Déconnexion'),
                onTap: () {
                  TokenUser = '';
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConnexionPage()));
                },
              ),
            ListTile(
                title: Text('Suprimer mon compte'),
                onTap: () {
                  _showDeleteDialog(context);
                }),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Color(0Xff6949FF)),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text('Mon Profil',
              style: TextStyle(
                  color: Color(0Xff6949FF),
                  fontSize: 30,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('images/shrek.jpeg'),
                  ),
                  Text(profil_lastName + ' ' + profil_firstName,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(profil_age.toString() + ' ans',
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                  DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50),
                            Text('Email'),
                            Text(profil_email,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 45),
                            Text('Téléphone'),
                            Text(profil_phone,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 45),
                            Text('Mon notaire'),
                            Text('M. PATOCHE',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 45),
                            Text('Notario ID'),
                            Text('965794584358369',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ButtonNavBar(),
    );
  }
}

class ProfilPage extends StatefulWidget {
  const ProfilPage();

  @override
  ProfilPageState createState() => ProfilPageState();
}

class ProfilPageState extends State<ProfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

void _showEditDialog(BuildContext context) {
  String editedFirstName = profil_firstName;
  String editedLastName = profil_lastName;
  String editedEmail = profil_email;
  int editedAge = profil_age;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Modifier mes informations'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: profil_firstName,
                decoration: InputDecoration(labelText: 'Prénom'),
                onChanged: (value) {
                  editedFirstName = value;
                },
              ),
              TextFormField(
                initialValue: profil_lastName,
                decoration: InputDecoration(labelText: 'Nom'),
                onChanged: (value) {
                  editedLastName = value;
                },
              ),
              TextFormField(
                initialValue: profil_email,
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  editedEmail = value;
                },
              ),
              TextFormField(
                initialValue: profil_age.toString(),
                decoration: InputDecoration(labelText: 'Âge'),
                onChanged: (value) {
                  editedAge = int.tryParse(value) ?? profil_age;
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Enregistrer'),
            onPressed: () async {
              var value = await ApiAuth().apiUpdate(
                  accountsModif: UtilisateurModif(
                LastName: LastName,
                age: age,
                email: email,
                firstName: firstName,
                password: password,
                phone: '+33654545454',
              ));

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _showDeleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Supprimer mon compte'),
        content: SingleChildScrollView(),
        actions: <Widget>[
          TextButton(
            child: Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
         TextButton(
  child: Text('Supprimer mon compte'),
  onPressed: () async {
    UtilisateurDelete utilisateurASupprimer = UtilisateurDelete(idClient: TokenUser);
    try {
      await apiDelete(accountsDeleteId: utilisateurASupprimer);
      print("Suppression réussie");
      print(TokenUser);
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    } catch (e) {
      print("Erreur lors de la suppression du compte : $e");
      // Gérer les erreurs ou afficher un message d'erreur
    }
  },
),

        ],
      );
    },
  );
}
