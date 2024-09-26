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
          // Bloc Général
          _buildSectionHeader('Général'),
          _buildGeneralSettings(context),

          // Bloc Compte
          _buildSectionHeader('Compte'),
          _buildAccountSettings(context),

          // Bloc Support
          _buildSectionHeader('Support'),
          _buildSupportSettings(context),

          // Bloc Ressources
          _buildSectionHeader('Ressources'),
          _buildResourceSettings(context),

          // Ajout d'un padding en bas
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget pour créer un en-tête de section
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Fonction pour construire le bloc Général
  Widget _buildGeneralSettings(BuildContext context) {
    return Column(
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
      ],
    );
  }

  // Fonction pour construire le bloc Compte
  Widget _buildAccountSettings(BuildContext context) {
    return Column(
      children: [
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
            _showPrivacyPolicyDialog(context);
          },
        ),
      ],
    );
  }

  // Fonction pour construire le bloc Support
  Widget _buildSupportSettings(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.contact_mail, color: Colors.white),
          title: Text(
            'Nous contacter',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            _showContactDialog(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.feedback, color: Colors.white),
          title: Text(
            'Votre avis compte',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            _showFeedbackDialog(context);
          },
        ),
      ],
    );
  }

  // Fonction pour construire le bloc Ressources
  Widget _buildResourceSettings(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.web, color: Colors.white),
      title: Text(
        'Visiter notre site web',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        _launchURL('http://20.111.31.171:3000');
      },
    );
  }

  // Fonction pour montrer le dialogue de confidentialité
  void _showPrivacyPolicyDialog(BuildContext context) {
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
  }
  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nous contacter', style: TextStyle(color: Colors.white)),
          content: Text('Voulez-vous ouvrir votre gestionnaire de mail ?',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF351EA4),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Non', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                _launchEmail();
                Navigator.of(context).pop();
              },
              child: Text('Oui', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'notario.team@gmail.com',
    );

    await launch(emailLaunchUri.toString());
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Votre avis compte', style: TextStyle(color: Colors.white)),
          content: Text('Voulez-vous ouvrir le questionnaire de satisfaction ?',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF351EA4),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Non', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                _launchURL2('https://forms.office.com/e/d7age1dYzk');
                Navigator.of(context).pop();
              },
              child: Text('Oui', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
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

  void _launchURL2(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
