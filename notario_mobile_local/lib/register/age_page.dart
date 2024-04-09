import 'package:flutter/material.dart';
import '../main_page/delayed_animation.dart';
import '../main.dart';
import 'name_page.dart';
import 'mail_page.dart';
import '../api/api.dart';

class AgePage extends StatelessWidget {
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
                child: Text(
                  "Quel est votre âge ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            AgeForm(),
            DelayedAnimation(
              delay: 300,
              child: Container(
                height: 50,
                margin: EdgeInsets.only(
                  top: 0,
                  bottom: 100,
                ),
                child: Image.asset(
                  "images/progression2.png",
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
                  onPressed: () {
                    // Vérifiez si le champ "Âge" est vide.
                    if (age == null || age!.isEmpty) {
                      // Affichez une boîte de dialogue (alerte) si le champ est vide.
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Champ vide"),
                            content: Text("Veuillez entrer votre âge."),
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
                      int? ageValue = int.tryParse(age!);
                      if (ageValue != null &&
                          ageValue >= 18 &&
                          ageValue <= 100) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MailPage()),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Âge invalide"),
                              content: Text(
                                  "Veuillez entrer un âge valide entre 18 et 100."),
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
                    }
                  },
                  child: Text(
                    "Continuer",
                    textScaleFactor: 1.5,
                    style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AgeForm extends StatefulWidget {
  const AgeForm();

  @override
  _AgeFormState createState() => _AgeFormState();
}

class _AgeFormState extends State<AgeForm> {
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
                bottom: 200,
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Âge',
                ),
                onChanged: (value) => age = value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
