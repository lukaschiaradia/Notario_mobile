import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../welcome_page.dart';
import '../models/utilisateur_delete.dart';
import '../login/connexion_page.dart';
import '../utils/constants/privacy_policy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:notario_mobile/main_page/tutorial.dart';
import 'package:notario_mobile/utils/constants/contants_url.dart';
import 'package:notario_mobile/api/api_auth.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paramètres',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: isDarkMode ? Color(0xFF1A1B25) : Color(0xFF351EA4),
      ),
      backgroundColor: isDarkMode ? Color(0xFF1A1B25) : Colors.white,
      body: ListView(
        children: [
          _buildSectionHeader('Général'),
          _buildGeneralSettings(context),
          _buildSectionHeader('Compte'),
          _buildAccountSettings(context),
          _buildSectionHeader('Support'),
          _buildSupportSettings(context),
          _buildSectionHeader('Ressources'),
          _buildResourceSettings(context),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildGeneralSettings(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.help_outline,
              color: isDarkMode ? Colors.white : Colors.black),
          title: Text(
            'Tutoriel',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          onTap: () {
            _showTutorialConfirmationDialog(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.dark_mode,
              color: isDarkMode ? Colors.white : Colors.black),
          title: Text(
            'Mode Nuit',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          trailing: Switch(
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
                _saveThemePreference(value);
              });
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.logout,
              color: isDarkMode ? Colors.white : Colors.black),
          title: Text(
            'Déconnexion',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          onTap: () async {
            await _clearCredentials();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ConnexionPage()),
            );
          },
        ),
      ],
    );
  }

  Future<void> _clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Widget _buildAccountSettings(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.delete,
              color: isDarkMode ? Colors.white : Colors.black),
          title: Text(
            'Supprimer mon compte',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          onTap: () {
            _showDeleteDialog(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip,
              color: isDarkMode ? Colors.white : Colors.black),
          title: Text(
            'Politique de confidentialité',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          onTap: () {
            _showPrivacyPolicyDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildSupportSettings(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.contact_mail,
              color: isDarkMode ? Colors.white : Colors.black),
          title: Text(
            'Nous contacter',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          onTap: () {
            _showContactDialog(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.feedback,
              color: isDarkMode ? Colors.white : Colors.black),
          title: Text(
            'Votre avis compte',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          onTap: () {
            _showFeedbackDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildResourceSettings(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.web, color: isDarkMode ? Colors.white : Colors.black),
      title: Text(
        'Visiter notre site web',
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      ),
      onTap: () {
        _launchURL('http://92.113.25.24/');
      },
    );
  }

  void _showTutorialConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Lancer le tutoriel ?',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          actions: [
            TextButton(
              child: Text('Non',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Oui',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TutorialScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Politique de confidentialité',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          content: SingleChildScrollView(
            child: Text(
              privacyPolicyText,
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
          backgroundColor: isDarkMode ? Color(0xFF351EA4) : Colors.white,
          actions: [
            TextButton(
              child: Text(
                'Fermer',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
          title: Text(
            'Nous contacter',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          content: Text(
            'Voulez-vous ouvrir votre gestionnaire de mails ?',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          actions: [
            TextButton(
              child: Text('Non',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Oui',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black)),
              onPressed: () {
                _launchURL('mailto:notario.team@gmail.com');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Votre avis compte',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Merci de nous faire part de vos retours.',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              SizedBox(height: 10),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Écrivez votre commentaire ici...',
                  hintStyle:
                      TextStyle(color: isDarkMode ? Colors.grey : Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            ],
          ),
          backgroundColor: isDarkMode ? Color(0xFF351EA4) : Colors.white,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Annuler',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                // Logique pour envoyer le feedback
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Merci pour votre feedback !',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  backgroundColor: isDarkMode ? Color(0xFF351EA4) : Colors.blue,
                ));
              },
              child: Text(
                'Envoyer',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
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
          title: Text(
            'Supprimer votre compte',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          actions: [
            TextButton(
              child: Text('Annuler',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black)),
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

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _saveThemePreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }
}
