import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(
        child: HexagonWidget.flat(
          width: 200,
          color: Colors.limeAccent,
          child: Center(
            child: Text(
              'Hexagon',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      )),
    );
  }
}
