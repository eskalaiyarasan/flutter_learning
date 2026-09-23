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

  final double number ;
  @override
  Widget build(BuildContext context) {
    return coreActionWidget(number,100);
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
            child: coreActionWidget(number,90),
          ),
        );
  }
}

class coreActionWidget extends StatefulWidget {
  coreActionWidget(this.number,this.width,{super.key});

  double number;
  double width;
  @override
  State<coreActionWidget> createState() => _coreActionWidgetState(number,width);
}

class _coreActionWidgetState extends State<coreActionWidget> {
  _coreActionWidgetState(this.number,this.width);
  double number;
  double width;
  @override
  Widget build(BuildContext context) {
    return HexagonWidget.pointy(
          width: width,
          //cornerRadius: 40.0,
          color: Colors.limeAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
                children:[ 
                  Container(
                    //width: 30,
                    height: 30,
                    child: TextButton(
                      child: Text(
                        number.toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          number = number + 1;
                        });
                        print(number);
                      },
                    ),
                  ),
                  for (int i = 0; i < 10; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for(int j=0;j<10;j++)
                      Container(
                        width: 5,height: 5,
                        color: number >= i*10+j ? Colors.amber : Colors.limeAccent,
                      ),
                    ],
                  ),
                ]
              ),
        );
  }
}