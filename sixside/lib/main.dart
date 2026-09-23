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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                sixsideWidget(1.0),
              //SizedBox(height: 20),
              QueensideWidget(50.3),              
              sixsideWidget(80.7),],),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                sixsideWidget(2.0),
              //SizedBox(height: 20),
              QueensideWidget(30.3),              
              sixsideWidget(120.7),],)
              
            ],
          ),
        ),
      ),
    );
  }
}

class sixsideWidget extends StatelessWidget {
  sixsideWidget(this.number,{super.key});

  double number ;
  @override
  Widget build(BuildContext context) {
    return HexagonWidget.pointy(
          width: 100,
          //cornerRadius: 40.0,
          color: Colors.amber,
          child: Center(
                child: TextButton(
                  child: Text(
                    number.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //number = number + 1;
                    print(number);
                  },
                ),
              ),
        );
  }
}
class QueensideWidget extends StatelessWidget {
  QueensideWidget(this.number,{super.key});

  final double number ;
  @override
  Widget build(BuildContext context) {
    return HexagonWidget.pointy(
          width: 100,
          //cornerRadius: 40.0,
          color: Colors.grey,
          child: Center(
            child: HexagonWidget.pointy(
              width: 90,
              color: Colors.amber,
              child: Center(
                child: TextButton(
                  onPressed: (){
                    print('QueensideWidget pressed');
                    print(number);
                  }, 
                  child:  Text(
                  number.toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ),
            ),
          ),
        );
  }
}