import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:uuid/uuid.dart';

class BaseObject{
  static final Map<String, CoreActionWidgetState> registry = {};
  static void registerWidget( CoreActionWidgetState widget) {
    registry[widget.getName() ] = widget;
  }
  static void action(String name){
    if(registry.containsKey(name)){
      CoreActionWidgetState state = registry[name] as CoreActionWidgetState;
      state.setNumber(0);
    }
    registry.forEach((key, widget) {
      if (key != name) {
        final state = widget;
        state.setNumber(state.getNumber() + 1);
      }
    });
    
  }

}




class CoreActionWidget extends StatefulWidget {
  CoreActionWidget(this.number,this.width,{super.key});

  final double number;
  final double width;
  @override
  State<CoreActionWidget> createState() => CoreActionWidgetState(number,width);
}

class CoreActionWidgetState extends State<CoreActionWidget> {
  CoreActionWidgetState(this.number,this.width);
  double number;
  double width;
  final String name = const Uuid().v4();
  @override
  void initState() {
    super.initState();
    BaseObject.registerWidget(this);
  }

  @override
  void dispose() {
    super.dispose();
  }
  String getName(){
    return name;
  }
  double getNumber(){
    return number;
  }

  void setNumber(double newNumber){
    setState(() {
      number = newNumber;
    });
  }

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
                        BaseObject.action(name);
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

class SixsideWidget extends StatelessWidget {
  SixsideWidget(this.number,{super.key});

  final double number ;
  @override
  Widget build(BuildContext context) {
    return CoreActionWidget(
      number,
      100,
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
            child: CoreActionWidget(
              number,
              90,
          ),
          )
        );
  }
}
