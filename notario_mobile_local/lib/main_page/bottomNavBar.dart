import 'package:notario_mobile/main.dart';
import 'package:flutter/material.dart';
import 'profil_page.dart';
import 'document_page.dart';
import 'planning_page.dart';
import 'faq_page.dart';
import '../api/api.dart';
import '../utils/constants/contants_url.dart';

int _currentIndex = 0;

class ButtonNavBar extends StatefulWidget {
  const ButtonNavBar();

  @override
  _ButtonNavBarState createState() => _ButtonNavBarState();
}

class _ButtonNavBarState extends State<ButtonNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      unselectedItemColor: Colors.grey,
      selectedItemColor: blue_color,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: ImageIcon(
            size: 40,
            AssetImage("images/folder-white-min.png"),
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          label: 'Documents',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            size: 40,
            AssetImage("images/planning-white-min.png"),
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          label: 'Agenda',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            size: 40,
            AssetImage("images/tchat-min.png"),
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          label: 'FAQ',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            size: 40,
            AssetImage("images/profil-white-min.png"),
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          label: 'Profil',
        ),
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
          if (index == 0) {
            if (typeUser == "Client") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DocumentPage()),
              );
            } else if (typeUser == "User") {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Accès refusé'),
                    content: Text('Vous devez être client d\'un notaire pour consulter vos documents.'),
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
            } 
          } else if (index == 1) {
            if (typeUser == "Client") {
              rdv_list = Future(() => api_get_planning());
              rdv_list.then((value) {
                rdv_list = value;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Planning()),
                );
              });
            } else if (typeUser == "User") {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Accès refusé'),
                    content: Text('Vous devez être client d\'un notaire pour consulter votre agenda.'),
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
            } 
          } else if (index == 2) {
            faq_list = Future(() => api_get_questions());
            faq_list.then((value) {
              faq_list = value;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FaqPage()),
              );
            });
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profil()),
            );
          }
        });
      },
    );
  }
}
