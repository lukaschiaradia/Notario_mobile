import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main_page/delayed_animation.dart';
import 'welcome_page.dart';
import 'main_page/homePage.dart';
import 'register/name_page.dart';
import 'main_page/document_page.dart';
import 'main_page/profil_page.dart';
import 'main_page/message_page.dart';
import 'main_page/faq_page.dart';

const blue_color = Color(0xFF6949FF);


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notario',
      //debugShowCheckedModeBanner: false,
      home: WelcomePage(),

      //home: HomePage(),
    );
  }
}
