import 'package:flutter/material.dart';
import 'package:notario_mobile/login/connection_controler.dart';
import 'package:notario_mobile/main_page/faq_page.dart';
import 'package:notario_mobile/main_page/tutorial.dart';
import 'package:notario_mobile/utils/constants/contants_url.dart';
import 'package:notario_mobile/utils/constants/status_code.dart';
import 'package:notario_mobile/welcome_page.dart';
import 'dart:async';
import '../main_page/delayed_animation.dart';
import '../main.dart';
import '../main_page/document_page.dart';
import '../api/api_auth.dart';
import '../api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                if (value.statusCode == successCode) {
                  final stayLoggedIn = connectionControler.stayLoggedIn;
                  if (stayLoggedIn) {
                    await _saveStayLoggedInPreference();
                  }
                  
                  if (stateUser == "NEW") {
                    _showFirstTimeUserDialog(context);
                  } else {
                    _navigateBasedOnUserType(context);
                  }
                } else {
                  alertConnectionFail(context);
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

  Future<void> _saveStayLoggedInPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('stayLoggedIn', true);
    await prefs.setString('email', connectionControler.email);
    await prefs.setString('password', connectionControler.password);
  }

  void _navigateBasedOnUserType(BuildContext context) {
    if (typeUser == "User") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FaqPage()),
      );
    } else if (typeUser == "Client") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DocumentPage()),
      );
    }
  }

  void _showFirstTimeUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF351EA4),
          title: Text(
            'Première connexion',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Text(
            'Voulez-vous lancer le tutoriel ?',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Oui',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TutorialScreen()),
                );
              },
            ),
            TextButton(
              child: Text(
                'Non',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateBasedOnUserType(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> alertConnectionFail(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text("Le mail ou le mot de passe indiqué est incorrect."),
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
  bool _stayLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadStayLoggedInPreference();
  }

  Future<void> _loadStayLoggedInPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? stayLoggedIn = prefs.getBool('stayLoggedIn');
    if (stayLoggedIn != null && stayLoggedIn) {
      String? savedEmail = prefs.getString('email');
      String? savedPassword = prefs.getString('password');
      if (savedEmail != null && savedPassword != null) {
        widget.connectionControler.changeEmail(savedEmail);
        widget.connectionControler.changePassword(savedPassword);
        setState(() {
          _stayLoggedIn = true;
        });
      }
    }
  }

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
              margin: EdgeInsets.only(top: 0, bottom: 30),
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
          CheckboxListTile(
            title: Text("Rester connecté"),
            value: _stayLoggedIn,
            onChanged: (newValue) {
              setState(() {
                _stayLoggedIn = newValue!;
                widget.connectionControler.stayLoggedIn = newValue;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
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
