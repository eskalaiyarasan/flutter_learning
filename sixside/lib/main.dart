import 'package:flutter/material.dart';
import 'sixside.dart';



void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SixsideWidget(1.0),
              //SizedBox(height: 20),
              QueensideWidget(50.3),              
              SixsideWidget(80.7),],),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SixsideWidget(2.0),
              //SizedBox(height: 20),
              QueensideWidget(30.3),              
              SixsideWidget(120.7),],)
              
            ],
          ),
        ),
      ),
    );
  }
}
