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
      unselectedItemColor: Colors.white.withOpacity(0.6), // Couleur pour les éléments non sélectionnés
      selectedItemColor: Color(0xFF351EA4), // Couleur pour l'élément sélectionné
      backgroundColor: Color(0xFF1A1B25), // Couleur de fond de la barre
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage("images/folder-white.png"),
            size: 30,
          ),
          label: 'Documents',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage("images/planning-white.png"),
            size: 30,
          ),
          label: 'Agenda',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage("images/notary.png"),
            size: 30,
          ),
          label: 'Notaires',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage("images/tchat.png"),
            size: 30,
          ),
          label: 'FAQ',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage("images/profil-white.png"),
            size: 30,
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
            } else {
              _showAccessDeniedDialog(context, 'documents');
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
            } else {
              _showAccessDeniedDialog(context, 'agenda');
            }
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profil()),
            );
          } else if (index == 3) {
            faq_list = Future(() => api_get_questions());
            faq_list.then((value) {
              faq_list = value;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FaqPage()),
              );
            });
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profil()),
            );
          }
        });
      },
    );
  }

  void _showAccessDeniedDialog(BuildContext context, String page) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accès refusé'),
          content: Text('Vous devez être client d\'un notaire pour consulter vos $page.'),
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
}
