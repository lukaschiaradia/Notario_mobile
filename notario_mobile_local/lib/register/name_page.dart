import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../main_page/delayed_animation.dart';
import '../main.dart';
import 'age_page.dart';
import '../api/api.dart';

class NamePage extends StatelessWidget {
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
                  child: Text("Informations personnelles ?",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 25,
                      )),
                ),
              ),
              NameForm(),
              DelayedAnimation(
                delay: 300,
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(
                    top: 0,
                    bottom: 100,
                  ),
                  child: Image.asset(
                    "images/progression1.png",
                  ),
                ),
              ),
              DelayedAnimation(
                  delay: 500,
                  child: Container(
                    width: 300,
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
                        "Continuer",
                        textScaleFactor: 1.5,
                        style: GoogleFonts.poppins(
                        color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        // Vérifiez si les champs "Nom" et "Prénom" sont vides.
                        if (LastName == null ||
                            LastName!.isEmpty ||
                            firstName == null ||
                            firstName!.isEmpty) {
                          // Affichez une boîte de dialogue (alerte) si les champs sont vides.
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Champs vides"),
                                content: Text(
                                    "Veuillez remplir les champs Nom et Prénom."),
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
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AgePage()),
                          );
                        }
                      },
                    ),
                  )),
            ],
          ),
        ));
  }
}

class NameForm extends StatefulWidget {
  const NameForm();

  @override
  _NameFormState createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Column(
        children: [
          DelayedAnimation(
            delay: 300,
            child: Container(
              margin: EdgeInsets.only(
                top: 0,
                bottom: 50,
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Nom',
                ),
                onChanged: (value) => LastName = value,
              ),
            ),
          ),
          DelayedAnimation(
            delay: 300,
            child: Container(
              margin: EdgeInsets.only(
                top: 0,
                bottom: 50,
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Prénom',
                ),
                onChanged: (value) => firstName = value,
              ),
            ),
          ),
          DelayedAnimation(
            delay: 300,
            child: Container(
              margin: EdgeInsets.only(
                top: 0,
                bottom: 60,
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Telephone',
                ),
                onChanged: (value) => phone = value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
