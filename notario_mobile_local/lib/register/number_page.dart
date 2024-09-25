import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:notario_mobile/utils/custom_progress_bar.dart';

import '../main_page/delayed_animation.dart';
import '../main.dart';
import 'age_page.dart';
import '../api/api.dart';

class NumberPage extends StatelessWidget {
  int currentStep = 1;

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
              PhoneForm(onPhoneChanged: (value) => phone = value),
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
                        String phonePattern = r'^\+\d{1,3}\d{9,14}$';
                        RegExp regExp = new RegExp(phonePattern);

                        if (phone == null || phone!.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Champs vides"),
                                content:
                                    Text("Veuillez remplir tous les champs."),
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
                        } else if (!regExp.hasMatch(phone!)) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Numéro de téléphone invalide"),
                                content: Text(
                                    "Veuillez entrer un numéro de téléphone valide."),
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
                          print(phone);
                        }
                      },
                    ),
                  )),
              SizedBox(height: 20),
              DelayedAnimation(
                delay: 300,
                child: CustomProgressBar(progress: currentStep / 4),
              ),
            ],
          ),
        ));
  }
}

class PhoneForm extends StatefulWidget {
  final Function(String) onPhoneChanged;

  const PhoneForm({required this.onPhoneChanged});

  @override
  _PhoneFormState createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
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
                bottom: 60,
              ),
              child: IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'Telephone',
                ),
                initialCountryCode: 'FR',
                onChanged: (phone) {
                  widget.onPhoneChanged(phone.completeNumber);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
