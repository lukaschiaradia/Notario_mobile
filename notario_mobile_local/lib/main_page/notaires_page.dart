import 'package:flutter/material.dart';
import 'bottomNavBar.dart';
import '../utils/constants/contants_url.dart';
import 'info_notaire.dart';
import 'package:notario_mobile/main_page/chat_box.dart';
import 'package:notario_mobile/main_page/liaisonNotairePage.dart';
import '../api/api.dart';
import 'package:fluttertoast/fluttertoast.dart';

var profil_firstName_notary = '';
var profil_lastName_notary = '';

class Notaires extends StatefulWidget {
  const Notaires({Key? key}) : super(key: key);

  @override
  NotairesPageState createState() => NotairesPageState();
}

class NotairesPageState extends State<Notaires> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void get_notary_infos() async {
    var notary = await api_get_notary();
    profil_firstName_notary = notary['first_name'];
    profil_lastName_notary = notary['last_name'];
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _dissociateNotary(BuildContext context) async {
    try {
      await apiDissociateNotary();
      setState(() {
        profil_firstName_notary = '';
        profil_lastName_notary = '';
      });
      Fluttertoast.showToast(
          msg: "Vous avez été dissocié du notaire.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Erreur lors de la dissociation : $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void _showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Text("Êtes-vous sûr de vouloir vous dissocier de votre notaire ?")),
            SizedBox(height: 10),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _dissociateNotary(context);
            },
            child: Text("Oui"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Non"),
          ),
        ],
      );
    },
  );
}


  void navigateToLiaisonNotairePage(BuildContext context) async {
    List<dynamic> notaires = await api_get_notaires();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiaisonNotairePage(notaires: notaires),
      ),
    );
  }

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
          child: Text('Notaires',
              style: TextStyle(
                  fontSize: 30,
                  color: Color(0Xff6949FF),
                  fontWeight: FontWeight.bold)),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),

                Text(
                  'Affiliation',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildAnimatedContainer('Se lier', () {
                        if (typeUser == "Client") {
                          _showSnackbar("Vous êtes déjà lié à un notaire.");
                        } else {
                          navigateToLiaisonNotairePage(context);
                        }
                      }, typeUser == "Client"),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildAnimatedContainer('Se dissocier', () {
                        if (typeUser == "User") {
                          _showSnackbar("Vous n'avez pas encore de notaire affilié.");
                        } else {
                          _showConfirmationDialog(context);
                        }
                      }, typeUser == "User"),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                Text(
                  'Mes Options',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildAnimatedContainer('Mon Notaire', () {
                        if (typeUser == "User") {
                          _showSnackbar("Vous n'avez pas encore de notaire affilié.");
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => InfoNotairePage()),
                          );
                        }
                      }, typeUser == "User"),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildAnimatedContainer('Chat', () {
                        if (typeUser == "User") {
                          _showSnackbar("Vous n'avez pas encore de notaire affilié.");
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatPage()),
                          );
                        }
                      }, typeUser == "User"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ButtonNavBar(),
    );
  }

  Widget _buildAnimatedContainer(String title, VoidCallback onTap, bool isDisabled) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.scale(
        scale: _animation.value,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDisabled ? Colors.grey[300] : Colors.white,
            border: Border.all(color: Color(0xFF351EA4)),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 2),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDisabled ? Colors.grey[600] : Color(0xFF351EA4),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
