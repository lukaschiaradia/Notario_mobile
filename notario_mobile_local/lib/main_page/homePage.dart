import 'package:flutter/material.dart';
import 'document_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
            child: Column(
          children: <Widget>[
            SizedBox(height: 80),
            Center(
              child: Text(
                'Bienvenue chez',
                style: TextStyle(fontSize: 28.0),
              ),
            ),
            Image.asset("images/logo-not.png",
            width: 270,
            height: 270,),
            SizedBox(height: 5),
            InkWell(
              child: Container(
              width: 300,
              height: 65,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Center(
                  child: Text(
                    'Document',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DocumentPage()),
                );
              },
            ),
            SizedBox(height: 20),
            Container(
              width: 300,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Center(
                child: Text(
                  'Profil',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 300,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Center(
                child: Text(
                  'test',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
