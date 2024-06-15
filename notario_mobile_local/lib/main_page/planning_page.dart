import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notario_mobile/models/utilisateur_create_rdv.dart';
import 'dart:async';
import 'delayed_animation.dart';
import '../main.dart';
import 'profil_page.dart';
import 'bottomNavBar.dart';
import '../api/api.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:lottie/lottie.dart';

var date;
var reason;

List<dynamic> create_planning_list(List rdvList) {
  List<dynamic> planningList = [];
  for (int x = 0; x < rdvList.length; x++) {
    planningList = [
      ...planningList,
      {
        'title': rdvList[x]['name'],
        'date': DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(rdvList[x]['begin'])),
        'time': DateFormat('HH:mm').format(DateTime.parse(rdvList[x]['begin'])),
        'description': rdvList[x]['description'],
      }
    ];
  }
  return planningList;
}

class Planning extends StatelessWidget {
  final List rdvList = create_planning_list(rdv_list);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Color(0Xff6949FF)),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 5.0),
          child: Text('Mes rendez-vous',
              style: TextStyle(
                  fontSize: 30,
                  color: Color(0Xff6949FF),
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold)),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Enter Information'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          TextFormField(
                            onChanged: (value) {
                              date = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Quand voulez vous un rendez-vous',
                            ),
                          ),
                          TextFormField(
                            onChanged: (value) {
                              reason = value;
                            },
                            decoration: InputDecoration(
                              hintText:
                                  'Expliquez pourquoi vous voulez un rendez-vous',
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Submit'),
                        onPressed: () {
                          api_ask_rdv(Date: date, reason: reason);
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirmation'),
                                content: Text(
                                    'Votre demande a été soumise avec succès.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Column(
            children: [
              Column(
                children: rdvList.map((rdv) {
                  return rdvCard(rdv);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ButtonNavBar(),
    );
  }
}

class rdvCard extends StatefulWidget {
  // replaced StatelessWidget with StatefulWidget
  final Map rdvData;
  rdvCard(this.rdvData);

  @override
  _rdvCardState createState() => _rdvCardState();
}

class _rdvCardState extends State<rdvCard> {
  // added state class
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFav = !isFav;
        });
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFF351EA4),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, color: Colors.white),
                      SizedBox(width: 10),
                      Text(widget.rdvData['date'],
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white),
                      SizedBox(width: 10),
                      Text(widget.rdvData['time'],
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(widget.rdvData['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.rdvData['description'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (isFav)
                    FadeInUp(
                      child: Lottie.asset(
                        './images/fav_lottie.json',
                        repeat: false,
                        height: 60,
                        width: 60,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanningPage extends StatefulWidget {
  const PlanningPage();

  @override
  PlanningPageState createState() => PlanningPageState();
}

class PlanningPageState extends State<PlanningPage> {
  @override
  Widget build(BuildContext context) {
    return Planning();
  }
}
