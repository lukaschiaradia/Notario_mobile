import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:notario_mobile/main_page/profil_page.dart';
import 'welcome_page.dart';
import 'login/connection_controler.dart';
import 'api/api_auth.dart';
import 'main_page/faq_page.dart';

const blue_color = Color(0xFF6949FF);

void main() async {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'alerts',
        channelName: 'Alerts',
        channelDescription: 'Notification tests as alerts',
      ),
    ],
    debug: true,
  );

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  ApiAuth apiAuth = ApiAuth();
  ConnectionControler connectionControler = ConnectionControler(apiAuth: apiAuth);
  
  await connectionControler.loadCredentials();

  runApp(MyApp(connectionControler: connectionControler));
}

class MyApp extends StatelessWidget {
  final ConnectionControler connectionControler;

  const MyApp({super.key, required this.connectionControler});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notario',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: connectionControler.loadCredentials(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur de chargement : ${snapshot.error}"));
          }
          if (connectionControler.stayLoggedIn) {
            return Profil();
          }
          return WelcomePage();
        },
      ),
    );
  }
}
