import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notario_mobile/api/api_auth.dart';
import 'package:notario_mobile/main_page/articlePage.dart';
import 'package:notario_mobile/main_page/chat_box.dart';
import 'package:notario_mobile/main_page/liaisonNotairePage.dart';
import 'package:notario_mobile/models/utilisateur_modif.dart';
import 'package:notario_mobile/utils/constants/contants_url.dart';
import '../welcome_page.dart';
import 'bottomNavBar.dart';
import '../models/utilisateur_delete.dart';
import 'info_notaire.dart';
import '../api/api.dart';
import '../login/connexion_page.dart';
import '../utils/constants/privacy_policy.dart';


var profil_phone = '';
var profil_firstName = '';
var profil_lastName = '';
int profil_age = 0;
var profil_email = '';
var profil_firstName_notary = '';
var profil_lastName_notary = '';

void navigateToLiaisonNotairePage(BuildContext context) async {
  List<dynamic> notaires = await api_get_notaires();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LiaisonNotairePage(notaires: notaires),
    ),
  );
}

void get_user_infos() async {
  var user = await getUserInfo();
  profil_phone = user['user']['phone'];
  profil_firstName = user['user']['first_name'];
  profil_lastName = user['user']['last_name'];
  profil_age = user['user']['age'];
  profil_email = user['user']['email'];
}

void get_notary_infos() async {
  var notary = await api_get_notary();
  profil_firstName_notary = notary['first_name'];
  profil_lastName_notary = notary['last_name'];
}

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  void initState() {
    super.initState();
    get_user_infos();
    get_notary_infos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: null,
            ),
            ListTile(
              title: Text('Lier avec un notaire'),
              onTap: () {
                navigateToLiaisonNotairePage(context);
              },
            ),
            ListTile(
              title: Text('Information notaire'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InfoNotairePage()));
              },
            ),
            ListTile(
              title: Text('Acceder au articles'),
              onTap: () {
                api_get_articles();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ArticlesPage()));
              },
            ),
            ListTile(
                title: Text('Modifier mes infos'),
                onTap: () {
                  _showEditDialog(context);
                }),
            ListTile(
              title: Text('Message'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatPage()));
              },
            ),
            ListTile(
              title: Text('Déconnexion'),
              onTap: () {
                TokenUser = '';
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ConnexionPage()));
              },
            ),
            ListTile(
                title: Text('Supprimer mon compte'),
                onTap: () {
                  _showDeleteDialog(context);
                }),
            ListTile(
                title: Text('Politique de confidentialité'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Politique de confidentialité'),
                        content: SingleChildScrollView(
                          child: Text(
                            privacyPolicyText,
                            style: TextStyle(
                              color: Colors.black,
                            )
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Fermer'),
                          ),
                        ],
                      );
                    },
                  );
                },     
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFF351EA4),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF351EA4),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'Mon Profil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF351EA4),
                    Color(0xFF1A1B25),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('images/bg.jpeg'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Beau Tristan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '22 ans',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ProfileInfoItem(
                          title: '                  Email',
                          value: 'beautristan33@gmail.com',
                        ),
                        Divider(),
                        ProfileInfoItem(
                          title: 'Téléphone',
                          value: '06 12 34 56 78',
                        ),
                        Divider(),
                        ProfileInfoItem(
                          title: 'Mon notaire',
                          value: 'Bobby Brown',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: ButtonNavBar(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
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
                  first_name: editedFirstName,
                  last_name: editedLastName,
                  age: editedAge,
                  email: editedEmail,
                );

              Navigator.of(context).pop();
              get_user_infos();
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
              UtilisateurDelete utilisateurASupprimer =
                  UtilisateurDelete(idClient: TokenUser);
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
