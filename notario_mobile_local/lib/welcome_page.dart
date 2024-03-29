import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main_page/delayed_animation.dart';
import 'main.dart';
import 'register/name_page.dart';
import 'login/connexion_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 60,
            horizontal: 30,
          ),
          child: Column(
            children: [
              DelayedAnimation(
                delay: 200,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 0,
                    bottom: 40,
                  ),
                  height: 150,
                  child: Image.asset('images/notario.png'),
                ),
              ),
              DelayedAnimation(
                delay: 220,
                child: Container(
                  height: 300,
                  child: Image.asset('images/man.png', scale: 1.5),
                ),
              ),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NamePage()),
                      );
                    },
                    child: Text(
                      "S'inscrire",
                      textScaleFactor: 1.5,
                      style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              DelayedAnimation(
                delay: 500,
                child: RichText(
                  text: TextSpan(
                    text: "J'ai déjà un compte",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConnexionPage(),
                          ),
                        );
                      },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
