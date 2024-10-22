import 'package:flutter/material.dart';
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

class Planning extends StatefulWidget {
  @override
  _PlanningState createState() => _PlanningState();
}

class _PlanningState extends State<Planning> {
  bool showPastAppointments = false; // État pour afficher ou non les rendez-vous passés
  List rdvList = create_planning_list(rdv_list);

  bool isPastAppointment(String date) {
    DateTime appointmentDate = DateFormat('dd/MM/yyyy').parse(date);
    return appointmentDate.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    // Filtrer les rendez-vous en fonction de l'état de showPastAppointments
    List filteredAppointments = rdvList.where((appointment) {
      if (showPastAppointments) {
        return !isPastAppointment(appointment['date']);
      } else {
        return true;
      }
    }).toList();

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
                    backgroundColor: Color(0xFF351EA4),  // Fond bleu-violet de l'alerte
                    title: Text(
                      "Demande d'événement",
                      style: TextStyle(
                        color: Colors.white, // Titre en blanc pour un bon contraste
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          TextFormField(
                            style: TextStyle(color: Colors.white), // Texte des champs en blanc
                            onChanged: (value) {
                              date = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Quand voulez vous un rendez-vous',
                              hintStyle: TextStyle(
                                color: Colors.white70, // Texte indicatif en blanc clair
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white, // Bordure blanche quand non sélectionné
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white, // Bordure blanche quand sélectionné
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16), // Espacement entre les champs
                          TextFormField(
                            style: TextStyle(color: Colors.white), // Texte des champs en blanc
                            onChanged: (value) {
                              reason = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Expliquez pourquoi vous voulez un rendez-vous',
                              hintStyle: TextStyle(
                                color: Colors.white70, // Texte indicatif en blanc clair
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white, // Bordure blanche
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white, // Bordure blanche
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'Envoyer',
                          style: TextStyle(
                            color: Colors.white, // Texte des boutons en blanc
                          ),
                        ),
                        onPressed: () {
                          api_ask_rdv(Date: date, reason: reason);
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Color(0xFF351EA4), // Fond bleu-violet pour la confirmation
                                title: Text(
                                  'Confirmation',
                                  style: TextStyle(
                                    color: Colors.white, // Texte en blanc pour un bon contraste
                                  ),
                                ),
                                content: Text(
                                  'Votre demande a été soumise avec succès.',
                                  style: TextStyle(
                                    color: Colors.white, // Texte en blanc
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                      'OK',
                                      style: TextStyle(
                                        color: Colors.white, // Texte du bouton en blanc
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
      body: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: showPastAppointments,
                onChanged: (bool? value) {
                  setState(() {
                    showPastAppointments = value!;
                  });
                },
              ),
              Text(
                'Afficher uniquement les rendez-vous à venir',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAppointments.length,
              itemBuilder: (context, index) {
                return rdvCard(filteredAppointments[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: ButtonNavBar(),
    );
  }
}

class rdvCard extends StatefulWidget {
  final Map rdvData;
  rdvCard(this.rdvData);

  @override
  _rdvCardState createState() => _rdvCardState();
}

class _rdvCardState extends State<rdvCard> {
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Text(
                      widget.rdvData['description'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
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
