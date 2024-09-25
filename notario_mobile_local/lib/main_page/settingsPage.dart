import 'package:flutter/material.dart';
import '../welcome_page.dart';
import '../models/utilisateur_delete.dart';
import '../login/connexion_page.dart';
import '../utils/constants/privacy_policy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:notario_mobile/main_page/tutorial.dart';
import 'package:notario_mobile/utils/constants/contants_url.dart';
import 'package:notario_mobile/api/api_auth.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
        'Paramètres',
        style: TextStyle(color: Colors.white),
      ),
        backgroundColor: Color(0xFF351EA4),
      ),
      backgroundColor: Color(0xFF1A1B25),
      body: ListView(
        children: [
          ListTile(
      leading: Icon(Icons.help_outline, color: Colors.white),
      title: Text(
        'Tutoriel',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        _showTutorialConfirmationDialog(context);
      },
    ),
    ListTile(
      leading: Icon(Icons.logout, color: Colors.white),
      title: Text(
        'Déconnexion',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ConnexionPage()),
        );
      },
    ),
    ListTile(
      leading: Icon(Icons.delete, color: Colors.white),
      title: Text(
        'Supprimer mon compte',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        _showDeleteDialog(context);
      },
    ),
    ListTile(
      leading: Icon(Icons.privacy_tip, color: Colors.white),
      title: Text(
        'Politique de confidentialité',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Politique de confidentialité',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Text(
                  privacyPolicyText,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              backgroundColor: Color(0xFF351EA4),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Fermer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    ),
    ListTile(
      leading: Icon(Icons.web, color: Colors.white),
      title: Text(
        'Visiter notre site web',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        _launchURL('http://20.111.31.171:3000');
      },
    ),
        ],
      ),
    );
  }

  void _showTutorialConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Lancer le tutoriel ?',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: Text(
                    'Non',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF351EA4),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 20),
                TextButton(
                  child: Text(
                    'Oui',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF351EA4),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TutorialScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
          backgroundColor: Color(0xFF351EA4),
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
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomePage()),
                  );
                } catch (e) {
                  print("Erreur lors de la suppression du compte : $e");
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $url';
    }
  }
}
