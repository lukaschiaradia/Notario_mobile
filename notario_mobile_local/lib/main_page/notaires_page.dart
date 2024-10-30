import 'package:flutter/material.dart';
import 'bottomNavBar.dart';
import '../utils/constants/contants_url.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text(
                  'Notaires',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
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
                        if (typeUser != "Client") {
                          print('Se lier pressed');
                        }
                      }, typeUser != "Client"),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildAnimatedContainer('Se dissocier', () {
                        if (typeUser != "User") {
                          print('Se dissocier pressed');
                        }
                      }, typeUser != "User"),
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
                        if (typeUser != "User") {
                          print('Mon Notaire pressed');
                        }
                      }, typeUser != "User"),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildAnimatedContainer('Chat', () {
                        if (typeUser != "User") {
                          print('Chat pressed');
                        }
                      }, typeUser != "User"),
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

  Widget _buildAnimatedContainer(String title, VoidCallback onTap, bool isEnabled) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Transform.scale(
        scale: _animation.value,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isEnabled ? Colors.white : Colors.grey[300],
            border: Border.all(color: Color(0xFF351EA4)),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(2, 2),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isEnabled ? Color(0xFF351EA4) : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
