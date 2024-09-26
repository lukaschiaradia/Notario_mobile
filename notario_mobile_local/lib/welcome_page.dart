import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'main_page/delayed_animation.dart';
import 'main.dart';
import 'register/name_page.dart';
import 'login/connexion_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

triggerNotification() {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 10,
          channelKey: 'alerts',
          title: 'notifaction de test',
          body: 'Simple button'));
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }

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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              SizedBox(height: 40),
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
                      shadowColor: Colors.blue.withOpacity(0.5),
                      elevation: 5,
                    ),
                    onPressed: () {
                      //triggerNotification();
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
              SizedBox(height: 20),
              DelayedAnimation(
                delay: 500,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ConnexionPage()),
                    );
                  },
                  child: Text(
                    "J'ai déjà un compte",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
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
