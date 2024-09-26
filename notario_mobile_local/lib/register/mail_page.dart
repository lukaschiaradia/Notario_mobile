import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notario_mobile/utils/custom_progress_bar.dart';
import 'dart:async';
import '../main_page/delayed_animation.dart';
import '../main.dart';
import 'name_page.dart';
import 'password_page.dart';
import '../api/api.dart';

void main() {
  runApp(MaterialApp(
    home: MailPage(),
  ));
}

class MailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int currentStep = 3;
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
                child: Text(
                  "Entrez votre adresse mail",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            EmailForm(),
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
                    "Continuer",
                    textScaleFactor: 1.5,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    if (isValidEmail(email)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PasswordPage()),
                      );
                    } else {
                      showAlert(context);
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            DelayedAnimation(
              delay: 300,
              child: CustomProgressBar(progress: currentStep / 4),
            ),
          ],
        ),
      ),
    );
  }

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Erreur"),
          content: Text("L'adresse e-mail n'est pas valide."),
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

class EmailForm extends StatefulWidget {
  const EmailForm();

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
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
                  labelText: 'Email',
                ),
                onChanged: (value) => email = value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

bool isValidEmail(String email) {
  final emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegExp.hasMatch(email);
}
