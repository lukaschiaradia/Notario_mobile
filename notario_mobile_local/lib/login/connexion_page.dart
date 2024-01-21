import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notario_mobile/login/connection_controler.dart';
import 'package:notario_mobile/models/utilisateur_login.dart';
import 'package:notario_mobile/utils/constants/contants_url.dart';
import 'package:notario_mobile/utils/constants/status_code.dart';
import 'dart:async';
import '../main_page/delayed_animation.dart';
import '../main.dart';
import '../main_page/document_page.dart';
import '../api/api_auth.dart';

class ConnexionPage extends StatelessWidget {
  final connectionControler = ConnectionControler(apiAuth: ApiAuth());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              DelayedAnimation(
                delay: 200,
                child: Container(
                  height: 100,
                  margin: EdgeInsets.only(
                    top: 40,
                    bottom: 0,
                  ),
                  child: Text("Connectez-vous",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 25,
                      )),
                ),
              ),
              SizedBox(height: 35),
              ConnexionForm(
                connectionControler: connectionControler,
              ),
              SizedBox(height: 35),
              DelayedAnimation(
                  delay: 500,
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blue_color,
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        "Connexion",
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () async {
                        var value = await connectionControler.connection();
                        print(value);
                        if (value.statusCode == successCode) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DocumentPage()),
                          );
                        } else {
                          await alertConnectionFail(context);
                        }
                        ;
                      },
                    ),
                  )),
            ],
          ),
        ));
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30,
      ),
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
                onChanged: (value) =>
                    widget.connectionControler.changeEmail(value),
              )),
          SizedBox(height: 30),
          DelayedAnimation(
              delay: 300,
              child: Container(
                  margin: EdgeInsets.only(
                    top: 0,
                    bottom: 130,
                  ),
                  child: TextField(
                    obscureText: _obscureText2,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText2 == false
                              ? Icons.visibility_off
                              : Icons.visibility,
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
                  ))),
        ],
      ),
    );
  }
}
