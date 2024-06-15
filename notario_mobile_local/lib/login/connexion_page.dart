import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notario_mobile/login/connection_controler.dart';
import 'package:notario_mobile/main_page/homePage.dart';
import 'package:notario_mobile/models/utilisateur_login.dart';
import 'package:notario_mobile/utils/constants/contants_url.dart';
import 'package:notario_mobile/utils/constants/status_code.dart';
import 'package:notario_mobile/welcome_page.dart';
import 'dart:async';
import '../main_page/delayed_animation.dart';
import '../main.dart';
import '../main_page/document_page.dart';
import '../api/api_auth.dart';
import '../api/api.dart';

class ConnexionPage extends StatelessWidget {
  final connectionControler = ConnectionControler(apiAuth: ApiAuth());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            Text(
              "Connectez-vous",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            ConnexionForm(
              connectionControler: connectionControler,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                var value = await connectionControler.connection();
                print(value);
                print(value.statusCode);
                if (value.statusCode == successCode) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DocumentPage()),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Erreur"),
                        content:
                            Text("L'email ou le mot de passe est incorrect."),
                        actions: <Widget>[
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blue_color,
                padding: EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                "Connexion",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> alertConnectionFail(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mail ou Mot de passe incorrect'),
          content: Text("Le mail ou le mot de passe indiqué est incorrect"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class ConnexionForm extends StatefulWidget {
  const ConnexionForm({required this.connectionControler});
  final ConnectionControler connectionControler;
  @override
  _ConnexionFormState createState() => _ConnexionFormState();
}

class _ConnexionFormState extends State<ConnexionForm> {
  var _obscureText2 = true;

  // Méthode pour afficher le dialogue de réinitialisation de mot de passe
  void _showPasswordResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Réinitialiser le mot de passe"),
          content: TextField(
            decoration: InputDecoration(labelText: 'Entrez votre email'),
            onChanged: (value) {
              email = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Réinitialiser'),
              onPressed: () {
                apiForgotPassword(email: email);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConnexionPage()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          SizedBox(height: 30),
          DelayedAnimation(
            delay: 300,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onChanged: (value) {
                widget.connectionControler.changeEmail(value);
              },
            ),
          ),
          SizedBox(height: 30),
          DelayedAnimation(
            delay: 300,
            child: Container(
              margin: EdgeInsets.only(top: 0, bottom: 130),
              child: TextField(
                obscureText: _obscureText2,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText2 ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText2 = !_obscureText2;
                      });
                    },
                  ),
                ),
                onChanged: (value) =>
                    widget.connectionControler.changePassword(value),
              ),
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                // Afficher le dialogue de réinitialisation du mot de passe lorsque l'utilisateur clique sur "Mot de passe oublié ?"
                _showPasswordResetDialog(context);
              },
              child: Text(
                'Mot de passe oublié ?',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
