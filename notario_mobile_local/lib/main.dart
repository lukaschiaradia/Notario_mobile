import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'welcome_page.dart';

const blue_color = Color(0xFF6949FF);

void main() {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'alerts',
        channelName: 'Alerts',
        channelDescription: 'Notification tests as alerts',
        defaultColor: blue_color,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
      NotificationChannel(
        channelKey: 'messages',
        channelName: 'Messages',
        channelDescription: 'Notifications for new messages',
        defaultColor: Colors.orange,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
      ),
    ],
    debug: true,
  );

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notario',
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),

      //home: HomePage(),
    );
  }
}
